---
title: host-device
description: "plugins/main/host-device/README.md"
date: 2020-11-02
toc: true
draft: false
weight: 200
---

Move an already-existing device into a container.

## Overview

This simple plugin will move the requested device from the host's network namespace
to the container's. IPAM configuration can be used for this plugin.
This plugin can also be used for a device bound to dpdk driver via `pciBusID` or
runtimeConfig `deviceID` parameter then IPAM configuration will be ignored.

## Network configuration reference

The device can be specified with any one of five properties:
* `device`: The device name, e.g. `eth0`, `can0`
* `hwaddr`: A MAC address
* `kernelpath`: The kernel device kobj, e.g. `/sys/devices/pci0000:00/0000:00:1f.6`
* `pciBusID`: A PCI address of network device, e.g `0000:00:1f.6`
* `useInterfaceNetwork` (boolean, default `false`): When set to `true`, the plugin captures the host interface's IP addresses and routes before moving the device into the container namespace, and then applies them inside the container. This is useful in cloud and virtual environments (e.g. AWS, GCP, IBM Cloud) where L3 configuration (IP addresses, routes) is provisioned directly on the host network device by the cloud provider and there is no traditional IPAM source. IPv4 addresses, including DHCP leases, are copied as permanent addresses (nothing renews them inside the container). IPv6 addresses without the `IFA_F_PERMANENT` flag (SLAAC and DHCPv6) are not copied; the kernel will install fresh SLAAC addresses and RA routes in the container if `accept_ra` is enabled. RA-learned routes are also excluded. Can be combined with IPAM to add extra addresses or routes on top of the host-provided ones. Not supported for DPDK-bound devices.

For this plugin, `CNI_IFNAME` will be ignored. Upon DEL, the device will be moved back.

**Note:** When using `useInterfaceNetwork`, the interface configuration on the host node must be persistent. When the device is moved back to the host (via DEL), the system's network management service (e.g. NetworkManager, systemd-networkd, cloud-init, or cloud-specific agents) is expected to re-apply the IP addresses and routes. The plugin does not re-configure the host interface on DEL.

The plugin also supports the following [capability argument](https://github.com/containernetworking/cni/blob/master/CONVENTIONS.md):
* `deviceID`: A PCI address of the network device, e.g `0000:00:1f.6`

## Example configuration

A sample configuration with `device` property looks like:

```json
{
	"cniVersion": "0.3.1",
	"type": "host-device",
	"device": "enp0s1"
}
```

A sample configuration with `pciBusID` property looks like:

```json
{
	"cniVersion": "0.3.1",
	"type": "host-device",
	"pciBusID": "0000:3d:00.1"
}
```

A sample configuration utilizing `deviceID` runtime configuration looks like:

1. From operator perspective:
     ```json
    {
    	"cniVersion": "0.3.1",
    	"type": "host-device",
    	"capabilities": {
    		"deviceID":  true
    	}
    }
    ```
2. From plugin perspective:
    ```json
    {
    	"cniVersion": "0.3.1",
    	"type": "host-device",
    	"runtimeConfig": {
    		"deviceID":  "0000:3d:00.1"
    	}
    }
    ```

A sample configuration using `useInterfaceNetwork` to carry the host interface's
L3 configuration into the container:

```json
{
	"cniVersion": "1.0.0",
	"type": "host-device",
	"device": "enp0s1",
	"useInterfaceNetwork": true
}
```

A sample configuration combining `useInterfaceNetwork` with IPAM to add
additional addresses on top of the cloud-provisioned ones:

```json
{
	"cniVersion": "1.0.0",
	"type": "host-device",
	"device": "enp0s1",
	"useInterfaceNetwork": true,
	"ipam": {
		"type": "static",
		"addresses": [
			{ "address": "10.10.0.100/24" }
		]
	}
}
```
