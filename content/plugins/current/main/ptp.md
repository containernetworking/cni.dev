---
title: ptp plugin
description: "plugins/main/ptp/README.md"
date: 2020-11-02
toc: true
draft: false
weight: 200
---

## Overview
The ptp plugin creates a point-to-point link between a container and the host by using a veth device.
One end of the veth pair is placed inside a container and the other end resides on the host.
The host-local IPAM plugin can be used to allocate an IP address to the container.
The traffic of the container interface will be routed through the interface of the host.

## Example network configuration

```json
{
	"name": "mynet",
	"type": "ptp",
	"ipam": {
		"type": "host-local",
		"subnet": "10.1.1.0/24"
	},
	"dns": {
		"nameservers": [ "10.1.1.1", "8.8.8.8" ]
	}
}
```

## Network configuration reference

* `name` (string, required): the name of the network
* `type` (string, required): "ptp"
* `ipMasq` (boolean, optional): set up IP Masquerade on the host for traffic originating from ip of this network and destined outside of this network. Defaults to false.
* `ipMasqBackend` (string, optional): IP masquerading implementation to use when `ipMasq` is true. Can be "iptables" or "nftables". Defaults to "iptables", unless only "nftables" is available.
* `mtu` (integer, optional): explicitly set MTU to the specified value. Defaults to value chosen by the kernel.
* `ipam` (dictionary, required): IPAM configuration to be used for this network.
* `dns` (dictionary, optional): DNS information to return as described in the [Result](https://github.com/containernetworking/cni/blob/master/SPEC.md#result).
