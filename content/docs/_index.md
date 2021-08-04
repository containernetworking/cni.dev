---
title: "CNI"
description: "The Container Networking Interface Specification"
date: 2020-10-31
draft: false
toc: true
---

## Why develop CNI?

Application containers on Linux are a rapidly evolving area, and within this area networking is not well addressed as it is highly environment-specific.
We believe that many container runtimes and orchestrators will seek to solve the same problem of making the network layer pluggable.

To avoid duplication, we think it is prudent to define a common interface between the network plugins and container execution: hence we put forward this specification, along with libraries for Go and a set of plugins.

## Who is using CNI?

### Container runtimes
- [Kubernetes](https://kubernetes.io/docs/admin/network-plugins/) - a system to simplify container operations
- [Containerd](https://containerd.io/) - A CRI-compliant container runtime
- [cri-o](https://cri-o.io/) - A lightweight container runtime
- [OpenShift](https://github.com/openshift/origin/blob/master/docs/openshift_networking_requirements.md) - Kubernetes with additional enterprise features
- [Cloud Foundry](https://github.com/cloudfoundry-incubator/cf-networking-release) - a platform for cloud applications
- [Apache Mesos](https://github.com/apache/mesos/blob/master/docs/cni.md) - a distributed systems kernel
- [Amazon ECS](https://aws.amazon.com/ecs/) - a highly scalable, high performance container management service
- [Singularity](https://github.com/sylabs/singularity) - a container platform optimized for HPC, EPC, and AI
- [OpenSVC](https://docs.opensvc.com/latest/fr/agent.configure.cni.html) - an orchestrator for legacy and containerized application stacks

### 3rd party plugins
- [Project Calico](https://github.com/projectcalico/calico-cni) - a layer 3 virtual network
- [Weave](https://github.com/weaveworks/weave) - a multi-host Docker network
- [Contiv Networking](https://github.com/contiv/netplugin) - policy networking for various use cases
- [SR-IOV](https://github.com/hustcat/sriov-cni)
- [Cilium](https://github.com/cilium/cilium) - BPF & XDP for containers
- [Infoblox](https://github.com/infobloxopen/cni-infoblox) - enterprise IP address management for containers
- [Multus](https://github.com/Intel-Corp/multus-cni) - a Multi plugin
- [Romana](https://github.com/romana/kube) - Layer 3 CNI plugin supporting network policy for Kubernetes
- [CNI-Genie](https://github.com/Huawei-PaaS/CNI-Genie) - generic CNI network plugin
- [Nuage CNI](https://github.com/nuagenetworks/nuage-cni) - Nuage Networks SDN plugin for network policy kubernetes support 
- [Silk](https://github.com/cloudfoundry-incubator/silk) - a CNI plugin designed for Cloud Foundry
- [Linen](https://github.com/John-Lin/linen-cni) - a CNI plugin designed for overlay networks with Open vSwitch and fit in SDN/OpenFlow network environment
- [Vhostuser](https://github.com/intel/vhost-user-net-plugin) - a Dataplane network plugin - Supports OVS-DPDK & VPP
- [Amazon ECS CNI Plugins](https://github.com/aws/amazon-ecs-cni-plugins) - a collection of CNI Plugins to configure containers with Amazon EC2 elastic network interfaces (ENIs)
- [Bonding CNI](https://github.com/Intel-Corp/bond-cni) - a Link aggregating plugin to address failover and high availability network
- [ovn-kubernetes](https://github.com/openvswitch/ovn-kubernetes) - a container network plugin built on Open vSwitch (OVS) and Open Virtual Networking (OVN) with support for both Linux and Windows
- [Juniper Contrail](https://www.juniper.net/cloud) / [TungstenFabric](https://tungstenfabric.io) - provides an overlay SDN solution, delivering multicloud networking, hybrid cloud networking, simultaneous overlay-underlay support, network policy enforcement, network isolation, and service chaining and flexible load balancing
- [Knitter](https://github.com/ZTE/Knitter) - a CNI plugin supporting multiple networking for Kubernetes
- [DANM](https://github.com/nokia/danm) - a CNI-compliant networking solution for TelCo workloads running on Kubernetes
- [VMware NSX](https://docs.vmware.com/en/VMware-NSX-T/2.2/com.vmware.nsxt.ncp_kubernetes.doc/GUID-6AFA724E-BB62-4693-B95C-321E8DDEA7E1.html) – a CNI plugin that enables automated NSX L2/L3 networking and L4/L7 Load Balancing; network isolation at the pod, node, and cluster level; and zero-trust security policy for your Kubernetes cluster.
- [cni-route-override](https://github.com/redhat-nfvpe/cni-route-override) - a meta CNI plugin that override route information
- [Terway](https://github.com/AliyunContainerService/terway) - a collection of CNI Plugins based on alibaba cloud VPC/ECS network product
- [Cisco ACI CNI](https://github.com/noironetworks/aci-containers) - on-premise and cloud container networking with a consistent policy and security model
- [Kube-OVN](https://github.com/alauda/kube-ovn) - a CNI plugin that bases on OVN/OVS and provides advanced features like subnet, static ip, ACL, QoS, etc.
- [Project Antrea](https://github.com/vmware-tanzu/antrea) - an Open vSwitch Kubernetes CNI
- [OVN4NFV-K8S-Plugin](https://github.com/opnfv/ovn4nfv-k8s-plugin) - a OVN based CNI controller plugin to provide cloud native based Service function chaining (SFC), Multiple OVN overlay networking

The CNI team also maintains some [core plugins in a separate repository](https://github.com/containernetworking/plugins).

## Contributing to CNI

We welcome contributions, including [bug reports](https://github.com/containernetworking/cni/issues), code, and documentation improvements.
If you intend to contribute to code or documentation, please read the [CONTRIBUTING](/docs/contributing/) page and see the [contact section](#contact) of this page.

## How do I use CNI?

### Requirements

The CNI spec is language agnostic. To use the Go language libraries in this repository, you'll need a recent version of Go.

### Reference Plugins

The CNI project maintains a set of [reference plugins](https://github.com/containernetworking/plugins) that implement the CNI specification.

## What might CNI do in the future?

CNI currently covers a wide range of needs for network configuration due to its simple model and API.
However, in the future CNI might want to branch out into other directions:

- Dynamic updates to existing network configuration
- Dynamic policies for network bandwidth and firewall rules

If these topics are of interest, please contact the team via the mailing list or IRC and find some like-minded people in the community to put a proposal together.

## Where are the binaries?

The plugins have been moved to a separate repo:
[https://github.com/containernetworking/plugins](https://github.com/containernetworking/plugins), and the releases there include binaries and checksums.

Prior to release 0.7.0 the `cni` release also included a `cnitool` binary; as this is a developer tool we suggest you build it yourself.

## Contact

For any questions about CNI, please reach out via:
- Email: [cni-dev](https://groups.google.com/forum/#!forum/cni-dev)
- IRC: #[containernetworking](irc://irc.freenode.net:6667/#containernetworking) channel on [freenode.net](https://freenode.net/)
- Slack: #cni on the [CNCF slack](https://slack.cncf.io/).  NOTE: the previous CNI Slack (containernetworking.slack.com) has been sunsetted.

If you have a _security_ issue to report, please do so privately to the email addresses listed in the [MAINTAINERS](https://github.com/containernetworking/cni/blob/master/MAINTAINERS) file.

