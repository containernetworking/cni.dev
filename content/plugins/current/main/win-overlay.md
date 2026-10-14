---
title: win-overlay plugin
description: "plugins/main/windows/win-overlay/README.md"
date: 2020-11-02
toc: true
draft: false
weight: 200
---

## Overview

With win-overlay plugin, all containers (on the same host) are plugged into an Overlay network based on VXLAN encapsulation. 

## Example configuration
```json
{
	"name": "mynet",
	"type": "win-overlay",
	"apiVersion": 2,
	"ipMasq": true,
	"endpointMacPrefix": "0E-2A",
	"ipam": {
		"type": "host-local",
		"subnet": "10.10.0.0/16"
	},
    "loopbackDSR": true,
    "capabilities": {
        "dns": true
    }
}

## Network configuration reference

* `apiVersion` (int, optional): the HNS API version to use, 1 or 2. Defaults to 1 (HNS), used with dockershim. Set to 2 to use HCN, used with containerd.
* `name` (string, required): the name of the network.
* `type` (string, required): "win-overlay".
* `ipMasq` (bool, optional): the inverse of `$FLANNEL_IPMASQ`, setup NAT for the hnsNetwork subnet.
* `dns` (dictionary, optional): dns config to be used.
 * `Nameservers` (list, optional): list of strings to be used for dns nameservers.
 * `Search` (list, optional): list of stings to be used for dns search.
* `endpointMacPrefix` (string, optional): set to the MAC prefix configured for Flannel.
* `ApiVersion` (integer, optional): HNS API version. Defaults to `1` (legacy HNS APIs, historically used with dockershim). Set to `2` to use HCN APIs. With containerd (and typically cri-dockerd), **`ApiVersion: 2` is required**; without it, endpoint creation can fail with errors about a missing HNS endpoint that the plugin is supposed to create.
* `Policies` (list, optional): List of hns policies to be used (only used when `ApiVersion` is less than `2`).
* `HcnPolicyArgs` (list, optional): List of hcn policies to be used (only used when `ApiVersion` is `2`).
* `ipam` (dictionary, required): IPAM configuration to be used for this network.
* `loopbackDSR` (bool, optional): If true, will add a policy to allow the interface to support loopback direct server return.
* `capabilities` (dictionary, optional): runtime capabilities to be parsed and injected by runtime.
 * `dns` (boolean, optional): If true, will take the dns config supplied by the runtime and override other settings.
