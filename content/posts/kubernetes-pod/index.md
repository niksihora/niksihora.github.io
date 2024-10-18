---
weight: 1
title: Kubernetes Pod
date: 2024-06-14T16:27:15+05:30
type: posts
author:
  name: Nikhil Sihora
  link: https://www.linkedin.com/in/nik-sihora/
description:
resources:
  - name: 
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

- Kubernetes doesn’t run containers directly on the nodes. Every container is encapsulated by a pod.
- Smallest unit of computing Kubernetes.
- A pod is a single instance of an application. If another instance of the application needs to be deployed, another pod is deployed with the containerized application running inside pod.
- Pods are epheremeral resources, meaning that Pods can be terminated at any point and then restarted on another node within our Kubernetes cluster.
- Creates a running environment over the container so that we only interact with the Kubernetes layer. This allows us to replace the container technology like Docker.
- **Each pod gets an internal IP address** for communicating with each other (virtual network created by K8).
- If a pod is restarted (maybe after the application running on it crashed), its IP address may change.

![kubernetes-pod](/posts/kubernetes-pod/kubernetes-pod.svg)

{{< admonition type=tip title="" open=true >}}

⛔ Sometimes we need to have a helper container for the application container. In that case, we can run both containers inside the same pod. This way both containers share the same storage and network and can reference each other as `localhost`.

Without using Pods, making a setup like this would be difficult as we need to manage attaching the helper containers to the application containers and kill them if the application container goes down.

Although, most use cases of pods revolve around single containers, it provides flexibility to add a helper container in the future as the application evolves.
![kubernetes-pod-multi-container](/posts/kubernetes-pod/kubernetes-pod-multi-contntainer.svg)

{{< /admonition >}}

# Simple Config for a Pod

```yml
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: webserver
spec:
  containers:
	  - name: httpd
	    image: httpd:latest
```

- `apiVersion` Which version of the Kubernetes API we're using to create this object. You can read more about API versioning in Kubernetes [here](https://kubernetes.io/docs/reference/using-api/#api-versioning).

- `kind` This defines what kind of Kubernetes object we want to create.

- `metadata` This is data that helps us uniquely identify the object that we want to create. Here we can provide a name for our app, as well as apply labels to our object.

- `spec` This defines the state that we want or our object. The format that we use for spec. For our Pod file, we have provided information about the containers that we want to host on our Pod.

To see what else we can define in our Pod YAML file, this [documentation from Kubernetes](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec) will help you.

- With kubectl, we can create a Pod using our YAML definition using below command:

```bash
kubectl apply -f pod_defination.yaml
```

We can list all of our Pods using below command:

```bash
kubectl get pods
```

#### Restart Policy

The default behavior of K8s is to restart a pod if it terminates. This is desirable for long running containers like web applications or databases. But, this is not desirable for short-lived containers such as a container to process an image or run analytics.

`restartPolicy` allows us to specify when K8s should restart the pod.

- `Always` - restart the pod if it goes down (default)
- `Never` - never restart the pod
- `OnFailure` - restart the pod only if the container inside failed (returned non zero exit code after execution)

# Config of `restartPolicy` usage

```yml
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: process
spec:
  containers:
	  - name: analytics
	    image: analytics
	restartPolicy: Never
```