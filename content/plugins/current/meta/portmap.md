---
title: Port-mapping plugin
description: "plugins/meta/portmap/README.md"
date: 2020-11-02
toc: true
draft: false
weight: 200
---

This plugin will forward traffic from one or more ports on the host to the
container. It expects to be run as a chained plugin.

## Usage
You should use this plugin as part of a network configuration list. It accepts
the following configuration options:

* `snat` - boolean, default true. If true or omitted, set up the SNAT chains
* `masqAll` - boolean, default false. If false or omitted, the `snat` rule set up on loopback & hairpin traffic, else will `snat` all source traffic. 
* `markMasqBit` - int, (0-31), default 13. The mark bit to use for masquerading (see section SNAT). Cannot be set when `externalSetMarkChain` is used. (Only used by the "iptables" backend.)
* `externalSetMarkChain` - string, default nil. If you already have a Masquerade mark chain (e.g. Kubernetes), specify it here. This will use that instead of creating a separate chain. When this is set, `markMasqBit` must be unspecified. (Only used by the "iptables" backend.)
* `conditionsV4`, `conditionsV6` - array of strings. A list of arbitrary `iptables` or `nft`
matches to add to the per-container rule. This may be useful if you wish to 
exclude specific IPs from port-mapping
* `backend` - string. The backend ("iptables" or "nftables") to use for rules. Defaults to "iptables", unless iptables is unavailable, or nftables-specific configuration is provided (e.g., in `conditionsV4`).

The plugin expects to receive the actual list of port mappings via the 
`portMappings` [capability argument](https://github.com/containernetworking/cni/blob/master/CONVENTIONS.md)

A sample standalone config list for Kubernetes (with the file extension .conflist) might
look like:

```json
{
        "cniVersion": "0.3.1",
        "name": "mynet",
        "plugins": [
                {
                        "type": "ptp",
                        "ipMasq": true,
                        "ipam": {
                                "type": "host-local",
                                "subnet": "172.16.30.0/24",
                                "routes": [
                                        {
                                                "dst": "0.0.0.0/0"
                                        }
                                ]
                        }
                },
                {
                        "type": "portmap",
                        "capabilities": {"portMappings": true},
                }
        ]
}
```

(Note that `"externalSetMarkChain": "KUBE-MARK-MASQ"` is [not
recommended] with recent releases of Kubernetes, since that chain is
considered private to kube-proxy, and may change in the future (and
does not exist when using kube-proxy in "nftables" mode).)

[not recommended]: https://kubernetes.io/blog/2022/09/07/iptables-chains-not-api/

A configuration file with all options set:
```json
{
        "type": "portmap",
        "backend": "iptables",
        "capabilities": {"portMappings": true},
        "snat": true,
        "markMasqBit": 13,
        "externalSetMarkChain": "CNI-HOSTPORT-SETMARK",
        "conditionsV4": ["!", "-d", "192.0.2.0/24"],
        "conditionsV6": ["!", "-d", "fc00::/7"]
}
```

Or using the "nftables" backend:
```json
{
        "type": "portmap",
        "backend": "nftables",
        "capabilities": {"portMappings": true},
        "snat": true,
        "conditionsV4": ["ip", "daddr", "!=", "192.0.2.0/24"],
        "conditionsV6": ["ip6", "daddr", "!=", "fc00::/7"]
}
```

## Rule structure (iptables)
The plugin sets up two sequences of chains and rules - one "primary" DNAT
sequence to rewrite the destination, and one additional SNAT sequence that
will masquerade traffic as needed.


### DNAT
The DNAT rule rewrites the destination port and address of new connections.
There is a top-level chain, `CNI-HOSTPORT-DNAT` which is always created and
never deleted. Each plugin execution creates an additional chain for ease
of cleanup. So, if a single container exists on IP 172.16.30.2/24 with ports
8080 and 8043 on the host forwarded to ports 80 and 443 in the container, the 
rules look like this:

`PREROUTING`, `OUTPUT` chains:
- `--dst-type LOCAL -j CNI-HOSTPORT-DNAT`

`CNI-HOSTPORT-DNAT` chain:
- `${ConditionsV4/6} -p tcp --destination-ports 8080,8043 -j CNI-DN-xxxxxx` (where xxxxxx is a function of the ContainerID and network name)

`CNI-HOSTPORT-SETMARK` chain:
- `-j MARK --set-xmark 0x2000/0x2000`

`CNI-DN-xxxxxx` chain:
- `-p tcp -s 172.16.30.0/24 --dport 8080 -j CNI-HOSTPORT-SETMARK` (masquerade hairpin traffic)
- `-p tcp -s 127.0.0.1 --dport 8080 -j CNI-HOSTPORT-SETMARK` (masquerade localhost traffic)
- `-p tcp --dport 8080 -j DNAT --to-destination 172.16.30.2:80` (rewrite destination)
- `-p tcp -s 172.16.30.0/24 --dport 8043 -j CNI-HOSTPORT-SETMARK`
- `-p tcp -s 127.0.0.1 --dport 8043 -j CNI-HOSTPORT-SETMARK`
- `-p tcp --dport 8043 -j DNAT --to-destination 172.16.30.2:443`

### SNAT (Masquerade)
Some packets also need to have the source address rewritten:
* connections from localhost
* Hairpin traffic back to the container.
* Plugins whose traffic does not go through the default net namespace e.g., ipvlan,macvlan,etc. (need `masqAll` option)

In the DNAT chain, a bit is set on the mark for packets that need snat. This
chain performs that masquerading. By default, bit 13 is set, but this is
configurable. If you are using other tools that also use the iptables mark,
you should make sure this doesn't conflict.

`POSTROUTING`:
- `-j CNI-HOSTPORT-MASQ`

`CNI-HOSTPORT-MASQ`:
- `--mark 0x2000 -j MASQUERADE`

## Rule structure (nftables)
The organization is slightly simpler than in the iptables case. All
rules are created in the `cni_hostport` table (of the `ip` or `ip6`
family, as appropriate).

### DNAT
The DNAT rule rewrites the destination port and address of new connections.
DNAT rules are added to the `hostports` or `hostip_hostports` chains
of the `cni_hostport` table, depending on whether the mapping is for
all host IPs or only for a single host IP.

So, if a single container exists on IP 172.16.30.2/24 with ports 8080
and 8043 on the host forwarded to ports 80 and 443 in the container,
the rules look like this:

```
table ip cni_hostport {
    comment "CNI portmap plugin"

    chain input {
        type nat hook input priority dstnat;
        jump hostports
    }
    chain output {
        type nat hook output priority dstnat;
        fib daddr type local jump hostports
    }

    chain hostports {
        ip protocol tcp th dport 8080  dnat ip addr . port to 172.16.30.2 . 80
        ip protocol tcp th dport 8043  dnat ip addr . port to 172.16.30.2 . 443
    }
}

New connections to the host will have to traverse every rule, so large numbers
of port forwards may have a performance impact. This won't affect established
connections, just the first packet.

### SNAT (Masquerade)
Some packets also need to have the source address rewritten:
* connections from localhost
* Hairpin traffic back to the container.
* Plugins whose traffic does not go through the default net namespace e.g., ipvlan,macvlan,etc. (need `masqAll` option)

Unlike the iptables backend, the nftables backend figures out the
packets that need to be masqueraded without using the packet mark or
an external chain. Continuing the above example:

table ip cni_hostport {
    comment "CNI portmap plugin"; }

    chain masquerading {
        type nat hook postrouting priority srcnat;
        # Hairpin traffic
        ip saddr 127.16.30.2 ip daddr 172.16.30.2  masquerade
        # Localhost hostports
        ip saddr 127.0.0.1 ip daddr 10.0.0.2  masquerade
    }
}

## Known issues

### Efficiency

Each new connection to the host will have to traverse every rule in
the chain, so large numbers of port forwards may have a performance
impact. (This won't affect established connections, just the first
packet.)

In theory, it should be possible to use nftables sets (or ipsets with
iptables) to address this problem, but for complicated technical
reasons, this doesn't quite work.

### Localhost hostports

Because MASQUERADE happens in POSTROUTING, packets with source ip
127.0.0.1 need to first pass a routing boundary before being
masqueraded. By default, that is not allowed in Linux. So, the plugin
needs to enable the sysctl `net.ipv4.conf.IFNAME.route_localnet`,
where IFNAME is the name of the host-side interface that routes
traffic to the container.

There is no equivalent to `route_localnet` for ipv6, so connections to
::1 will not be portmapped for ipv6. If you need port forwarding from
localhost, your container must have an ipv4 address.
