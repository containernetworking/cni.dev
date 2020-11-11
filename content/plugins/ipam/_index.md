---
title: "IPAM"
date: 2020-11-11
toc: false
draft: false
weight: 100
---

## IPAM: IP address allocation
* [`dhcp`](dhcp): Runs a daemon on the host to make DHCP requests on behalf of the container
* [`host-local`](host-local): Maintains a local database of allocated IPs
* [`static`](static):  Allocate a static IPv4/IPv6 addresses to container and it's useful in debugging purpose.

