---
weight: 1
title: Kubernetes Replicaset
date: 2024-10-18T20:38:04+05:30
type: posts
author:
  name: Nikhil Sihora
  link: https://www.linkedin.com/in/nik-sihora/
description:
resources:
  - name: featured-image
    src: kubernetes.png
tags:
  - kubernetes
categories:
  - kubernetes
lightgallery: true
reward: false
toc:
  auto: false
---
![kubernetes-replicaset](/posts/deployment/kubernetes-deployment.png)
- ReplicaSet monitors and maintains the number of replicas of a given pod. It will automatically spawn a new pod if the pod goes down.
- It is needed even if we only have a single pod, because if that pod dies, replica set will spawn a new pod.
- It spans the entire cluster to spawn pods on any node.

{{< admonition type=tip title="" open=true >}}
⛔ Newer and better way to manage replicated pods in Kubernetes than Replication Controllers
{{< /admonition >}}

# Simple Config for a Replicaset

```yml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: httpd-frontend
  labels:
    name: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      name: frontend
  template:
    metadata:
      labels:
        name: frontend
    spec:
      containers:
      - name: httpd
        image: httpd:2.4-alpine
```

- `template` → `metadata` and `spec` from the config file for the pod (required to spawn new pods if any of them goes down)
- `replicas` → how many replicas to maintain
- It has an additional required field `selector` which allows the replica set to select pods that match specific labels. This way **the replicaset can manage pods that were not created by it.**

## Scaling the number of replicas

- **Recommended**: edit the config file and re-apply - `k apply -f config.yaml`
    - Scaling changes can be easily tracked using Git
- **Not recommended**: using `kubectl` - `k scale replicaset my-replicaset --replicas=2`
    - This will not update the config file, so changes are hard to track