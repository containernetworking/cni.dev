---
title: tap plugin
description: "plugins/main/tap/README.md"
date: 2022-02-13
toc: true
draft: false
weight: 200
---

## Overview
The tap plugin creates a tap device inside the container namespace.

*Note:* Due to a fault in the golang's netlink library which does not allow to create ownerless/groupless tap devices, 
the plugin will use the 'ip' tool to create the tap device when owner/group is not specified. 

## Example network configuration

```json
{
	"name": "mynet",
	"cniVersion": "0.3.1",
	"type": "tap",
	"mac": "00:11:22:33:44:55",
	"mtu": 1500,
	"selinuxcontext": "system_u:system_r:container_t:s0",
	"multiQueue": true,
	"owner": 0,
	"group": 0
}
```

## Network configuration reference

* `name` (string, required): the name of the network
* `type` (string, required): "tap"
* `mac` (string, optional): request a specific MAC address for the interface
* `mtu` (integer, optional): explicitly set MTU to the specified value. Defaults to value chosen by the kernel.
* `selinuxcontext` (string, optional): for systems with the selinux security module enabled, the context under which to creat the tap device 
* `multiQueue` (boolean, optional): enable multiqueue
* `owner` (integer, optional): user owning the tap device
* `group` (integer, optional): group owning the tap device
