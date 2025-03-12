---
title: firewall plugin
description: "plugins/meta/firewall/README.md"
date: 2020-11-02
toc: true
draft: false
weight: 200
---

## Overview

This plugin creates firewall rules to allow traffic to/from container IP address via the host network.
It does not create any network interfaces and therefore does not set up connectivity by itself.
It is intended to be used as a chained plugins.

## Operation
The following network configuration file

```json
{
    "cniVersion": "0.3.1",
    "name": "bridge-firewalld",
    "plugins": [
        {
            "type": "bridge",
            "bridge": "cni0",
            "isGateway": true,
            "ipMasq": true,
            "ipam": {
                "type": "host-local",
                "subnet": "10.88.0.0/16",
                "routes": [
                    { "dst": "0.0.0.0/0" }
                ]
            }
        },
        {
            "type": "firewall"
        }
    ]
}
```

will allow any IP addresses configured by earlier plugins to send/receive traffic via the host.

A successful result would simply be an empty result, unless a previous plugin passed a previous result, in which case this plugin will return that previous result.

## Backends

This plugin supports multiple firewall backends that implement the desired functionality.
Available backends include `iptables` and `firewalld` and may be selected with the `backend` key.
If no `backend` key is given, the plugin will use firewalld if the service exists on the D-Bus system bus.
If no firewalld service is found, it will fall back to iptables.

## firewalld backend rule structure
When the `firewalld` backend is used, this example will place the IPAM allocated address for the container (e.g. 10.88.0.2) into firewalld's `trusted` zone, allowing it to send/receive traffic.


A sample standalone config list (with the file extension .conflist) using firewalld backend might
look like:

```json
{
    "cniVersion": "0.3.1",
    "name": "bridge-firewalld",
    "plugins": [
        {
            "type": "bridge",
            "bridge": "cni0",
            "isGateway": true,
            "ipMasq": true,
            "ipam": {
                "type": "host-local",
                "subnet": "10.88.0.0/16",
                "routes": [
                    { "dst": "0.0.0.0/0" }
                ]
            }
        },
        {
            "type": "firewall",
            "backend": "firewalld"
        }
    ]
}
```


`FORWARD_IN_ZONES_SOURCE` chain:
- `-d 10.88.0.2 -j FWDI_trusted`

`CNI_FORWARD_OUT_ZONES_SOURCE` chain:
- `-s 10.88.0.2 -j FWDO_trusted`


## iptables backend rule structure

A sample standalone config list (with the file extension .conflist) using iptables backend might
look like:

```json
{
    "cniVersion": "0.3.1",
    "name": "bridge-firewalld",
    "plugins": [
        {
            "type": "bridge",
            "bridge": "cni0",
            "isGateway": true,
            "ipMasq": true,
            "ipam": {
                "type": "host-local",
                "subnet": "10.88.0.0/16",
                "routes": [
                    { "dst": "0.0.0.0/0" }
                ]
            }
        },
        {
            "type": "firewall",
            "backend": "iptables"
        }
    ]
}
```

When the `iptables` backend is used, the above example will create two new iptables chains in the `filter` table and add rules that allow the given interface to send/receive traffic.

### FORWARD
A new chain, CNI-FORWARD is added to the FORWARD chain.  CNI-FORWARD is the chain where rules will be added
when containers are created and from where rules will be removed when containers terminate.

`FORWARD` chain:
- `-j CNI-FORWARD`

CNI-FORWARD will have a pair of rules added, one for each direction, using the IPAM assigned IP address
of the container as shown:

`CNI-FORWARD` chain:
- `-d 10.88.0.2 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT`
- `-s 10.88.0.2 -j ACCEPT`

The `CNI-FORWARD` chain first sends all traffic to `CNI-ADMIN` chain, which is intended as an user-controlled chain for custom rules that run prior to rules managed by the `firewall` plugin. The `firewall` plugin does not add, delete or modify rules in the `CNI-ADMIN` chain.

`CNI-FORWARD` chain:
- `-j CNI-ADMIN`

The chain name `CNI-ADMIN` can be overridden by specifying `iptablesAdminChainName` in the plugin configuration

```json
{
    "type": "firewall",
    "backend": "iptables",
    "iptablesAdminChainName": "SOME-OTHER-CHAIN-NAME",
}
```

## Ingress Policy

Starting with v1.1.0, the `firewall` plugin supports `ingressPolicy` for isolating bridges.
```json
{
    "type": "firewall",
    "ingressPolicy": "same-bridge"
}
```

The supported values are `open` and `same-bridge` and (starting with v1.7) `isolated`.

- `open` is the default and does NOP.

- `same-bridge` creates "CNI-ISOLATION-STAGE-1" and "CNI-ISOLATION-STAGE-2"
that are similar to Docker libnetwork's "DOCKER-ISOLATION-STAGE-1" and
"DOCKER-ISOLATION-STAGE-2" rules.

    e.g., when `ns1` and `ns2` are connected to bridge `cni1`, and `ns3` is
    connected to bridge `cni2`, the `same-bridge` ingress policy disallows
    communications between `ns1` and `ns3`, while allowing communications
    between `ns1` and `ns2`.

    ```bash
    iptables -N CNI-ISOLATION-STAGE-1
    iptables -N CNI-ISOLATION-STAGE-2
    iptables -I FORWARD -j CNI-ISOLATION-STAGE-1
    iptables -A CNI-ISOLATION-STAGE-1 -i cni1 ! -o cni1 -j CNI-ISOLATION-STAGE-2
    iptables -A CNI-ISOLATION-STAGE-1 -i cni2 ! -o cni2 -j CNI-ISOLATION-STAGE-2
    iptables -A CNI-ISOLATION-STAGE-1 -j RETURN
    iptables -A CNI-ISOLATION-STAGE-2 -o cni1 -j DROP
    iptables -A CNI-ISOLATION-STAGE-2 -o cni2 -j DROP
    iptables -A CNI-ISOLATION-STAGE-2 -j RETURN
    ```

    The number of commands is O(N) where N is the number of the bridges (not the number of the containers).

    Run `sudo iptables-save -t filter` to confirm the added rules.

- `isolated` behaves similar to ingress policy `same-bridge` with the exception
that connections from the same bridge are also blocked.  This is meant to be
functionally equivalent to Docker network option "enable_icc" when set to false.

    e.g., when `ns1` and `ns2` are two containers connected to the same bridge `cni1`,
    the `isolated` ingress policy disallows communications between `ns1` and `ns2`.

    ```bash
    iptables -N CNI-ISOLATION-STAGE-1
    iptables -N CNI-ISOLATION-STAGE-2
    iptables -I FORWARD -j CNI-ISOLATION-STAGE-1
    iptables -A CNI-ISOLATION-STAGE-1 -i cni1 ! -o cni1 -j CNI-ISOLATION-STAGE-2
    iptables -A CNI-ISOLATION-STAGE-1 -i cni1 -o cni1 -j DROP
    iptables -A CNI-ISOLATION-STAGE-1 -j RETURN
    iptables -A CNI-ISOLATION-STAGE-2 -o cni1 -j DROP
    iptables -A CNI-ISOLATION-STAGE-2 -j RETURN
    ```

 The `same-bridge` and `isolated` ingress policies are expected to be used in conjunction
with `bridge` plugin. May not work as expected with other "main" plugins.

It should be also noted that these ingress policies execute
raw `iptables` commands directly, even when the `backend` is set to `firewalld`.
