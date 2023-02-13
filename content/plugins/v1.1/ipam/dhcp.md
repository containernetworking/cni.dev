---
title: dhcp plugin
description: "plugins/ipam/dhcp/README.md"
date: 2020-11-02
toc: true
draft: false
weight: 200
---

## Overview

With dhcp plugin the containers can get an IP allocated by a DHCP server already running on your network.
This can be especially useful with plugin types such as [macvlan](/plugins/current/main/macvlan/).
Because a DHCP lease must be periodically renewed for the duration of container lifetime, a separate daemon is required to be running.
The same plugin binary can also be run in the daemon mode.

## Operation
To use the dhcp IPAM plugin, first launch the dhcp daemon:

```
# Make sure the unix socket has been removed
$ rm -f /run/cni/dhcp.sock
$ ./dhcp daemon
```

If given `-pidfile <path>` arguments after 'daemon', the dhcp plugin will write
its PID to the given file.  
If given `-hostprefix <prefix>` arguments after 'daemon', the dhcp plugin will
use this prefix for DHCP socket as `<prefix>/run/cni/dhcp.sock`. You can use
this prefix for references to the host filesystem, e.g. to access netns and the
unix socket.  
If given `-broadcast=true` argument after 'daemon', the dhcp plugin will
enable the broadcast flag on DHCP packets.  
If given `-timeout <duration>` arguments after 'daemon', the dhcp daemon will
time out unanswered dhcp requests after this duration, defaults to `10s`.

Alternatively, you can use systemd socket activation protocol.
Be sure that the .socket file uses /run/cni/dhcp.sock as the socket path.

With the daemon running, containers using the dhcp plugin can be launched.

## DHCP Options

Not all DHCP options are supported when requesting from server. Current supported are:

* `ip-address`, `subnet-mask`
* `static-routes`, `classless-static-routes`, `routers`
* `dhcp-lease-time`, `dhcp-renewal-time`, `dhcp-rebinding-time`

See `man:dhcp-options(5)` for description of these names. Also, you can use option ID instead of names, like `121` for `classless-static-routes`.
## Example configuration

For example, to send hostname to the DHCP server when using Podman runtime, use this config:
```json
{
    "ipam": {
        "type": "dhcp",
        "daemonSocketPath": "/run/cni/dhcp.sock",
        "request": [
            {
                "skipDefault": false
            }
        ],
        "provide": [
            {
                "option": "host-name",
                "fromArg": "K8S_POD_NAME"
            }
        ]
    }
}
```

## Network configuration reference

* `type` (string, required): "dhcp"
* `daemonSocketPath` (string, optional): Path to the socket of daemon. If `-hostprefix` is set for the daemon, this value should be set to `<prefix>/run/cni/dhcp.sock`.
* `request` (dict, optional): Options requesting from DHCP server.
    * `skipDefault` (bool, optional): If the default request list is skipped.
    * `option` (string, optional): String or number representation of the DHCP option.
* `provide` (dict, optional): Options providing to DHCP server when acquire leases.
    * `option` (string, optional): String or number representation of the DHCP option.
    * `value` (string, optional): String representation of the value. Directly sent to server.
    * `fromArg` (string, optional): Get value from `CNI_ARGS` by given argument name.
