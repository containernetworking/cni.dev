---
title: "Home"
date: 2020-11-02
---

CNI (_Container Network Interface_), a [Cloud Native Computing Foundation](https://cncf.io) project, consists of a specification and libraries for writing plugins to configure network interfaces in Linux and Windows containers, along with a number of supported plugins.
CNI concerns itself only with network connectivity of containers and removing allocated resources when the container is deleted.
Because of this focus, CNI has a wide range of support and the specification is simple to implement.

As well as the [specification](/docs/spec/), the [CNI repository](https://github.com/containernetworking/cni) contains the Go source code of a [library for integrating CNI into applications](https://github.com/containernetworking/cni/tree/master/libcni) and an [example command-line tool](/docs/cnitool/) for executing CNI plugins.  A [separate repository contains reference plugins](https://github.com/containernetworking/plugins) and a template for making new plugins.

The template code makes it straight-forward to create a CNI plugin for an existing container networking project.
CNI also makes a good framework for creating a new container networking project from scratch.

Here are the recordings of two sessions that the CNI maintainers hosted at KubeCon/CloudNativeCon 2019:

- [Introduction to CNI](https://youtu.be/YjjrQiJOyME)
- [CNI deep dive](https://youtu.be/zChkx-AB5Xc)

