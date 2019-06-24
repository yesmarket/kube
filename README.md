# Kube

This repo has scripts to set up a local Kubernetes cluster as well as an Ansible controller to deploy workloads into the cluster.

## Prerequisites

* git
* PowerShell
* Vagrant
* VirtualBox
* Docker
* Docker Compose

## Running the K8s cluster

```bash
cd /path/to/kube
./init.ps1
Add-HostOnlyNetwork
vagrant up
```

## Running Ansible controller

```bash
cd /path/to/kube
docker build
docker-compose up
```
