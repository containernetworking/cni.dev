---
title: tuning plugin
description: "plugins/meta/tuning/README.md"
date: 2020-11-02
toc: true
draft: false
weight: 200
---

## Overview

This plugin can change some system controls (sysctls) and several
interface attributes (promiscuous mode, all-multicast mode, MTU and MAC
address) in the network namespace.
It does not create any network interfaces and therefore does not bring connectivity by itself.
It is only useful when used in addition to other plugins.

## System Controls Operation
The following network configuration file
```json
{
  "name": "mytuning",
  "type": "tuning",
  "sysctl": {
          "net.core.somaxconn": "500",
          "net.ipv4.conf.IFNAME.arp_filter": "1"
  }
}
```
will set /proc/sys/net/core/somaxconn to 500 and /proc/sys/net/ipv4/conf/IFNAME/arp_filter to 1,
while `IFNAME` in the path will be substituted with an interface name passed to this plugin.
That substitution is allowing to set sysctls specific to a particular network interface.
Other sysctls can be modified as long as they belong to the network namespace (`/proc/sys/net/*`).

A successful result would simply be:
```json
{ }
```

### Network sysctls documentation

Some network sysctls are documented in the Linux sources:

- [Documentation/sysctl/net.txt](https://www.kernel.org/doc/Documentation/sysctl/net.txt)
- [Documentation/networking/ip-sysctl.txt](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)
- [Documentation/networking/](https://www.kernel.org/doc/Documentation/networking/)

## Interface Attribute Operation
The following configuration example will change all the supported attributes on the interface
determined by [CNI_IFNAME](https://github.com/containernetworking/cni/blob/master/SPEC.md#parameters):

```json
{
  "name": "mytuning",
  "type": "tuning",
  "mac": "c2:b0:57:49:47:f1",
  "mtu": 1454,
  "promisc": true,
  "allmulti": true
}
```

### Interface attribute configuration reference

* `mac` (string, optional): MAC address (i.e. hardware address) of interface
* `mtu` (integer, optional): MTU of interface
* `promisc` (bool, optional): Change the promiscuous mode of interface
* `allmulti` (bool, optional): Change the all-multicast mode of interface. If enabled, all multicast packets on the network will be received by the interface.

## Supported arguments
The following [CNI_ARGS](https://github.com/containernetworking/cni/blob/master/SPEC.md#parameters) are supported:

* `MAC`: request a specific MAC address for the interface

    (example: CNI_ARGS="IgnoreUnknown=true;MAC=c2:11:22:33:44:55")

Note: You may add `IgnoreUnknown=true` to allow loose CNI argument verification (see CNI's issue[#560](https://github.com/containernetworking/cni/issues/560)).

The plugin also support following [capability argument](https://github.com/containernetworking/cni/blob/master/CONVENTIONS.md).

* `mac`: Pass MAC addresses for CNI interface

The following [args conventions](https://github.com/containernetworking/cni/blob/master/CONVENTIONS.md#args-in-network-config) are supported:

* `mac` (string, optional): MAC address (i.e. hardware address) of interface
* `mtu` (integer, optional): MTU of interface
* `promisc` (bool, optional): Change the promiscuous mode of interface
* `allmulti` (bool, optional): Change the all-multicast mode of interface
* `sysctl` (object, optional): Change system controls
