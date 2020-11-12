---
title: "Conventions"
weight: 200
---

# Extension conventions                                                        
There are three ways of passing information to plugins using the Container Network Interface (CNI), none of which require the [spec](/docs/spec/) to be updated. These are 
- plugin specific fields in the JSON config
- `args` field in the JSON config
- `CNI_ARGS` environment variable 

The Conventions document aims to provide guidance on which method should be used and to provide a convention for how common information should be passed.
Establishing these conventions allows plugins to work across multiple runtimes. This helps both plugins and the runtimes.

## Released versions
Released versions of the spec and conventions are available as Git tags.

| tag                                                                                  | conventions permalink                                                                        | notes                      |
| ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------- | --------------------------------- |
| [`spec-v0.4.0`](https://github.com/containernetworking/cni/releases/tag/spec-v0.4.0) | [conventions at v0.4.0](https://github.com/containernetworking/cni/blob/spec-v0.4.0/CONVENTIONS.md) | |
| [`spec-v0.3.1`](https://github.com/containernetworking/cni/releases/tag/spec-v0.3.1) | [conventions at v0.3.1](https://github.com/containernetworking/cni/blob/spec-v0.3.1/CONVENTIONS.md) | |
| [`spec-v0.3.0`](https://github.com/containernetworking/cni/releases/tag/spec-v0.3.0) | [conventions at v0.3.0](https://github.com/containernetworking/cni/blob/spec-v0.3.0/CONVENTIONS.md) | |
| [`spec-v0.2.0`](https://github.com/containernetworking/cni/releases/tag/spec-v0.2.0) | | No CONVENTIONS file for this version |
| [`spec-v0.1.0`](https://github.com/containernetworking/cni/releases/tag/spec-v0.1.0) | | No CONVENTIONS file for this version |

{{< warning >}}
Do not rely on these tags being stable.  In the future, we may change our mind about which particular commit is the right marker for a given historical spec version.
{{< /warning >}}
