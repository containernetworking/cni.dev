---
title: vrf plugin
description: "plugins/meta/vrf/README.md"
date: 2020-11-02
toc: true
draft: false
weight: 200
---

## Overview

This plugin creates a [VRF](https://www.kernel.org/doc/Documentation/networking/vrf.txt) in the network namespace and assigns it the interface passed in the arguments. If the VRF is already present in the namespace, it only adds the interface to it.

The table id is mandatory for VRF but optional in the CNI configuration. If not specified, the plugin generates a new one for each different VRF that is added to the namespace.

It does not create any network interfaces and therefore does not bring connectivity by itself.
It is only useful when used in addition to other plugins.

## Operation

The following network configuration file

```json
{
    "cniVersion": "0.3.1",
    "name": "macvlan-vrf",
    "plugins": [
      {
        "type": "macvlan",
        "master": "eth0",
        "ipam": {
            "type": "dhcp"
        }
      },
      {
        "type": "vrf",
        "vrfname": "blue",
      }
    ]
}
```

will create a VRF named blue inside the target namespace (if not existing), and set it as master of the interface created by the previous plugin.

## Configuration

The only configuration is the name of the VRF, as per the following example:

```json
{
    "type": "vrf",
    "vrfname": "blue"
}
```

## Supported arguments

The following [args conventions](https://github.com/containernetworking/cni/blob/master/CONVENTIONS.md#args-in-network-config) are supported:

* `vrfname` (string): The name of the VRF to be created and to be set as master of the interface
* `table` (int, optional): The route table to be associated to the created VRF.

