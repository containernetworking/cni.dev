---
title: bridge plugin
description: "plugins/main/bridge/README.md"
date: 2020-11-02
toc: true
draft: false
weight: 200
---

## Overview

With bridge plugin, all containers (on the same host) are plugged into a bridge (virtual switch) that resides in the host network namespace.
The containers receive one end of the veth pair with the other end connected to the bridge.
An IP address is only assigned to one end of the veth pair -- one residing in the container.
The bridge itself can also be assigned an IP address, turning it into a gateway for the containers.
Alternatively, the bridge can function purely in L2 mode and would need to be bridged to the host network interface (if other than container-to-container communication on the same host is desired).

The network configuration specifies the name of the bridge to be used.
If the bridge is missing, the plugin will create one on first use and, if gateway mode is used, assign it an IP that was returned by IPAM plugin via the gateway field.

## Example configuration
```json
{
    "cniVersion": "0.3.1",
    "name": "mynet",
    "type": "bridge",
    "bridge": "mynet0",
    "isDefaultGateway": true,
    "forceAddress": false,
    "ipMasq": true,
    "hairpinMode": true,
    "ipam": {
        "type": "host-local",
        "subnet": "10.10.0.0/16"
    }
}
```

## Example L2-only configuration
```json
{
    "cniVersion": "0.3.1",
    "name": "mynet",
    "type": "bridge",
    "bridge": "mynet0",
    "ipam": {}
}
```

## Example L2-only, disabled interface configuration
```json
{
    "cniVersion": "0.3.1",
    "name": "mynet",
    "type": "bridge",
    "bridge": "mynet0",
    "disableContainerInterface": "true",
}
```

## Network configuration reference

* `name` (string, required): the name of the network.
* `type` (string, required): "bridge".
* `bridge` (string, optional): name of the bridge to use/create. Defaults to "cni0".
* `isGateway` (boolean, optional): assign an IP address to the bridge. Defaults to false.
* `isDefaultGateway` (boolean, optional): Sets isGateway to true and makes the assigned IP the default route. Defaults to false.
* `forceAddress` (boolean, optional): Indicates if a new IP address should be set if the previous value has been changed. Defaults to false.
* `ipMasq` (boolean, optional): set up IP Masquerade on the host for traffic originating from this network and destined outside of it. Defaults to false.
* `mtu` (integer, optional): explicitly set MTU to the specified value. Defaults to the value chosen by the kernel.
* `hairpinMode` (boolean, optional): set hairpin mode for interfaces on the bridge. Defaults to false.
* `ipam` (dictionary, required): IPAM configuration to be used for this network. For L2-only network, create empty dictionary.
* `promiscMode` (boolean, optional): set promiscuous mode on the bridge. Defaults to false.
* `vlan` (int, optional): assign VLAN tag. Defaults to none.
* `preserveDefaultVlan` (boolean, optional): indicates whether the default vlan must be preserved on the veth end connected to the bridge. Defaults to true.
* `vlanTrunk` (list, optional): assign VLAN trunk tag. Defaults to none.
* `enabledad` (boolean, optional): enables duplicate address detection for the container side veth. Defaults to false.
* `macspoofchk` (boolean, optional): Enables mac spoof check, limiting the traffic originating from the container to the mac address of the interface. Defaults to false.
* `disableContainerInterface` (boolean, optional): Set the container interface (veth peer inside the container netns) state down. When enabled, IPAM cannot be used.

## VLAN capabilities

The `vlan` and `vlanTrunk` parameters are mutually exclusive.

The `vlan` parameter configures the VLAN tag on the host end of the veth and also enables the vlan_filtering feature on the bridge interface. The VLAN_DEFAULT_PVID of the bridge (when set), is added by default on the port as a VID untagged on egress. This is in most cases not desirable. Use the `preserveDefaultVlan` parameter to remove it.

The `vlanTrunk` parameter allows to add a single VID or a range of VIDs (see example below). The native vlan of the trunk is the VLAN_DEFAULT_PVID of the bridge. This VID is added by default on the port with PVID and UNTAGGED options enabled. There are two known limitations due to this. First, all trunk ports on the bridge have the same native vlan. Second, the default PVID of the bridge is currently not configurable.

To configure uplink for L2 network you need to allow the vlan on the uplink interface by using the following command ``` bridge vlan add vid VLAN_ID dev DEV```.


### Example L2-only vlan configuration
```json
{
    "cniVersion": "0.3.1",
    "name": "mynet",
    "type": "bridge",
    "bridge": "mynet0",
    "vlan": 100,
    "preserveDefaultVlan": false,
    "ipam": {}
}
```

### Example L2-only vlan trunk configuration
```json
{
    "cniVersion": "0.3.1",
    "name": "mynet",
    "type": "bridge",
    "bridge": "mynet0",
    "vlanTrunk": [
      { "id": 101 },
      { "minID": 200, "maxID": 299 }],
    "ipam": {}
}
```


## Interface configuration arguments reference

The following [CNI_ARGS](https://github.com/containernetworking/cni/blob/master/SPEC.md#parameters) are supported:

* `MAC`: request a specific MAC address for the interface

    (example: CNI_ARGS="MAC=c2:11:22:33:44:55")

Note: You may add `IgnoreUnknown=true` to allow loose CNI argument verification (see CNI's issue[#560](https://github.com/containernetworking/cni/issues/560)).

The plugin also support following [capability argument](https://github.com/containernetworking/cni/blob/master/CONVENTIONS.md).

* `mac`: Pass MAC addresses for CNI interface

The following [args conventions](https://github.com/containernetworking/cni/blob/master/CONVENTIONS.md#args-in-network-config) are supported:

* `mac` (string, optional): MAC address (i.e. hardware address) of interface
