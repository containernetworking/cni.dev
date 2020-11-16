---
title: "Main"
date: 2019-08-13
toc: false
draft: false
weight: 100
---

## Main: interface-creating

* [`bridge`](bridge): Creates a bridge, adds the host and the container to it.
* [`ipvlan`](ipvlan): Adds an [ipvlan](https://www.kernel.org/doc/Documentation/networking/ipvlan.txt) interface in the container
* `loopback`: Creates a loopback interface
* [`macvlan`](macvlan): Creates a new MAC address, forwards all traffic to that to the container
* [`ptp`](ptp): Creates a veth pair.
* `vlan`: Allocates a vlan device.

