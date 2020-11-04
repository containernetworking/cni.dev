---
title: "Specification"
weight: 100
---

The Specification document proposes a generic plugin-based networking solution for application containers on Linux, the _Container Networking Interface_, or _CNI_.
It is derived from the rkt Networking Proposal, which aimed to satisfy many of the design considerations for networking in [rkt][rkt-github].

[rkt-github]: https://github.com/coreos/rkt

## Version
The latest CNI **spec** version **0.4.0**.

Note that this is **independent from the version of the CNI library and plugins** in this repository (e.g. the versions of [releases](https://github.com/containernetworking/cni/releases)).

### Released versions
Released versions of the spec are available as Git tags.

| tag                                                                                  | spec permalink                                                                        | major changes                     |
| ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------- | --------------------------------- |
| [`spec-v0.4.0`](https://github.com/containernetworking/cni/releases/tag/spec-v0.4.0) | [spec at v0.4.0](https://github.com/containernetworking/cni/blob/spec-v0.4.0/SPEC.md) | Introduce the CHECK command and passing prevResult on DEL |
| [`spec-v0.3.1`](https://github.com/containernetworking/cni/releases/tag/spec-v0.3.1) | [spec at v0.3.1](https://github.com/containernetworking/cni/blob/spec-v0.3.1/SPEC.md) | none (typo fix only)              |
| [`spec-v0.3.0`](https://github.com/containernetworking/cni/releases/tag/spec-v0.3.0) | [spec at v0.3.0](https://github.com/containernetworking/cni/blob/spec-v0.3.0/SPEC.md) | rich result type, plugin chaining |
| [`spec-v0.2.0`](https://github.com/containernetworking/cni/releases/tag/spec-v0.2.0) | [spec at v0.2.0](https://github.com/containernetworking/cni/blob/spec-v0.2.0/SPEC.md) | VERSION command                   |
| [`spec-v0.1.0`](https://github.com/containernetworking/cni/releases/tag/spec-v0.1.0) | [spec at v0.1.0](https://github.com/containernetworking/cni/blob/spec-v0.1.0/SPEC.md) | initial version                   |

{{< warning >}}
Do not rely on these tags being stable.  In the future, we may change our mind about which particular commit is the right marker for a given historical spec version.
{{< /warning >}}

