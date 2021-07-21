---
title: Plugins Overview
description: "plugins/README.md"
date: 2020-11-02
toc: true
draft: false
weight: 200
cascade:
  version: v0.9
---

These are general-purpose CNI network plugins maintained by the containernetworking team. For more information, see the individual plugin pages.

## Reference plugins:

### Main: interface-creating

* [`bridge`](main/bridge): Creates a bridge, adds the host and the container to it
* [`ipvlan`](main/ipvlan): Adds an [ipvlan](https://www.kernel.org/doc/Documentation/networking/ipvlan.txt) interface in the container
* [`macvlan`](main/macvlan): Creates a new MAC address, forwards all traffic to that to the container
* [`ptp`](main/ptp): Creates a veth pair
* [`host-device`](main/host-device): Moves an already-existing device into a container

#### Windows: windows specific

* [`win-bridge`](main/win-bridge): Creates a bridge, adds the host and the container to it
* [`win-overlay`](main/win-overlay): Creates an overlay interface to the container

### IPAM: IP address allocation
* [`dhcp`](ipam/dhcp): Runs a daemon on the host to make DHCP requests on behalf of a container
* [`host-local`](ipam/host-local): Maintains a local database of allocated IPs
* [`static`](ipam/static): Allocates static IPv4/IPv6 addresses to containers

### Meta: other plugins

* [`flannel`](meta/flannel): Generates an interface corresponding to a flannel config file
* [`tuning`](meta/tuning): Changes sysctl parameters of an existing interface
* [`portmap`](meta/portmap): An iptables-based portmapping plugin. Maps ports from the host's address space to the container
* [`bandwidth`](meta/bandwidth): Allows bandwidth-limiting through use of traffic control tbf (ingress/egress)
* [`sbr`](meta/sbr): A plugin that configures source based routing for an interface (from which it is chained)
* [`firewall`](meta/firewall): A firewall plugin which uses iptables or firewalld to add rules to allow traffic to/from the container

## Contact

For any questions about CNI, please reach out via:
- Email: [cni-dev](https://groups.google.com/forum/#!forum/cni-dev)
- Slack: #cni on the [CNCF slack](https://slack.cncf.io/).

If you have a _security_ issue to report, please do so privately to the email addresses listed in the [OWNERS](OWNERS.md) file.

