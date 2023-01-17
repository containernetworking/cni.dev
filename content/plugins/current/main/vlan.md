---
title: vlan plugin
description: "plugins/main/vlan/README.md"
date: 2021-10-17
toc: true
draft: false
weight: 200
---

## Overview
The vlan plugin creates a vlan subinterface off an master interface in the host network namespace and place the vlan subinterface inside the container namespace. Each container must use different `master` and `vlanId` pair.

The host-local IPAM plugin can be used to allocate an IP address to the container. The traffic of the container interface will be bridged through the master interface.

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
