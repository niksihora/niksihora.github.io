---
title: Kubernetes Node
subtitle:
date: 2024-05-10T12:05:51+05:30
slug: 
draft: false
author:
  name: Niksihora
  link:
  email:
  avatar:
description: 
keywords:
license:
comment: false
weight: 0
tags:
  - kubernetes
categories:
  - kubernetes
hiddenFromHomePage: false
hiddenFromSearch: false
hiddenFromRss: false
hiddenFromRelated: false
summary:
resources:
  - name: featured-image
    src: kubernetes.png
toc: true
math: false
lightgallery: false
password:
message:
repost:
  enable: true
  url:

# See details front matter: https://fixit.lruihao.cn/documentation/content-management/introduction/#front-matter
---
<!--more-->
# Kubernetes Node
- A physical or virtual machine on which Kubernetes is installed
- **Nodes are cluster scoped. They are not scoped within a namespace.**
- When you install Kubernetes on a node, the following components are installed. Some of them are used in worker nodes and the rest are used in master nodes.
    - API Server
    - `etcd` Service
    - Kubelet Service
    - Container Runtime
    - Controller
    - Scheduler
- A **cluster** is a collection of nodes grouped together

## Worker Nodes

![worker-node](/posts/kubernetes-node/worker-node.png)

- These nodes do the actual work so they need to have more resources
- Each worker node has multiple pods running on it
- 3 processes must be installed on every worker node
    - **Container Runtime** (eg. docker)
    - **Kubelet**
        - process of Kubernetes
        - starts pods and runs containers inside them
        - allocates resources from the node to the container
    - **Kubeproxy**
        - process of Kubernetes
        - forwards the requests to pods intelligently
        - Image
            - Kubeproxy forwards requests to the DB pod running on the same node to minimize network overhead.
                
                ![kube-proxy](/posts/kubernetes-node/kube-proxy.png)
                

## Master Nodes

![master-node](/posts/kubernetes-node/master-node.png)

- Control the cluster state & manage worker nodes
- Need less resources as they don't do the actual work
- Multi-master setup is often used for fault tolerance
- 4 processes run on every master node
    - **API Server**
        - User interacts with the cluster via the API server using a client (Kubernetes Dashboard, CLI, or Kubernetes API)
        - Cluster gateway (acts as the entry point into the cluster)
        - Can be used for authentication
        
        ![kube-apiserver](/posts/kubernetes-node/kube-apiserver.png)
        
    - **Scheduler**
        - Decides the node where the new pod should be scheduled and sends a request to the Kubelet to start a pod.
        
        ![kube-scheduler](/posts/kubernetes-node/kube-scheduler.png)
        
    - **Controller**
        - Detects state changes like crashing of pods
        - If a pod dies, it requests scheduler to schedule starting up of a new pod
        
        ![kube-controller](/posts/kubernetes-node/kube-controller.png)
        
    - **etcd**
        - Key-value store of the cluster state (also known as cluster brain)
        - Cluster changes get stored in the etcd
        - In multi-master configuration, etcd is a distributed key-value store
        - Application data is not stored in the etcd