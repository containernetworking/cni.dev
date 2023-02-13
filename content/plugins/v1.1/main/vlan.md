---
title: vlan plugin
description: "plugins/main/vlan/README.md"
date: 2021-10-17
toc: true
draft: false
weight: 200
---

## Overview
The vlan plugin creates a vlan subinterface off an enslaved interface in the host network namespace and the container using a veth device. One end of the veth pair is placed inside a container and the other end is a subinterface off the master in the host network namespace. The host-local IPAM plugin can be used to allocate an IP address to the container. The traffic of the container interface will be routed through the interface of the host.

## Example network configuration

```json
{
	"name": "mynet",
	"cniVersion": "0.3.1",
	"type": "vlan",
	"master": "eth0",
	"mtu": 1500,
	"vlanId": 5,
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
* `type` (string, required): "vlan"
* `master` (string, required): name of the host interface to enslave. Defaults to default route interface.
* `vlanId` (integer, required): id of the vlan
* `mtu` (integer, optional): explicitly set MTU to the specified value. Defaults to value chosen by the kernel.
* `ipam` (dictionary, required): IPAM configuration to be used for this network.
* `dns` (dictionary, optional): DNS information to return as described in the [Result](https://github.com/containernetworking/cni/blob/master/SPEC.md#result).
