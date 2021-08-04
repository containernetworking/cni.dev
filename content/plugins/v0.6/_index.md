---
title: Plugins Overview
description: "plugins/README.md"
date: 2019-08-13
toc: true
draft: false
weight: 200
cascade:
  version: v0.6
---

These are general-purpose CNI network plugins maintained by the containernetworking team. For more information, see the individual plugin pages.

## Reference plugins:

### Main: interface-creating

* [`bridge`](main/bridge): Creates a bridge, adds the host and the container to it.
* [`ipvlan`](main/ipvlan): Adds an [ipvlan](https://www.kernel.org/doc/Documentation/networking/ipvlan.txt) interface in the container
* `loopback`: Creates a loopback interface
* [`macvlan`](main/macvlan): Creates a new MAC address, forwards all traffic to that to the container
* [`ptp`](main/ptp): Creates a veth pair.
* `vlan`: Allocates a vlan device.

### IPAM: IP address allocation

* [`dhcp`](ipam/dhcp): Runs a daemon on the host to make DHCP requests on behalf of the container
* [`host-local`](ipam/host-local): maintains a local database of allocated IPs

### Meta: other plugins

* [`flannel`](meta/flannel): generates an interface corresponding to a flannel config file
* [`tuning`](meta/tuning): Tweaks sysctl parameters of an existing interface
* [`portmap`](meta/portmap): An iptables-based portmapping plugin. Maps ports from the host's address space to the container.

### Sample

The sample plugin provides an example for building your own plugin.

