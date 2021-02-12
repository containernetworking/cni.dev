---
title: host-device
description: "plugins/main/host-device/README.md"
date: 2019-08-13
toc: true
draft: false
weight: 200
---


Move an already-existing device in to a container.

This simple plugin will move the requested device from the host's network namespace
to the container's. Nothing else will be done - no IPAM, no addresses.

The device can be specified with any one of three properties:
* `device`: The device name, e.g. `eth0`, `can0`
* `hwaddr`: A MAC address
* `kernelpath`: The kernel device kobj, e.g. `/sys/devices/pci0000:00/0000:00:1f.6`

For this plugin, `CNI_IFNAME` will be ignored. Upon DEL, the device will be moved back.

A sample configuration might look like:

```json
{
	"cniVersion": "0.3.1",
	"device": "enp0s1"
}
```

