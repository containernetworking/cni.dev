---
title: "Main"
date: 2020-11-11
toc: false
draft: false
weight: 100
---

## Main: interface-creating
* [`bridge`](bridge): Creates a bridge, adds the host and the container to it
* [`ipvlan`](ipvlan): Adds an [ipvlan](https://www.kernel.org/doc/Documentation/networking/ipvlan.txt) interface in the container
* [`macvlan`](macvlan): Creates a new MAC address, forwards all traffic to that to the container
* [`ptp`](ptp): Creates a veth pair
* [`host-device`](host-device): Moves an already-existing device into a container

### Windows: windows specific
* [`win-bridge`](win-bridge): Creates a bridge, adds the host and the container to it
* [`win-overlay`](win-overlay): Creates an overlay interface to the container

