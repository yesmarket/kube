# Kube

## Objective

This repo has scripts to setup a multi node Kubernetes cluster for development purposes as well as a containerised Ansible controller to deploy workloads into the K8s cluster.

## Prerequisites

* git
* PowerShell
* Vagrant
* VirtualBox
* Docker
* Docker Compose

## Configuring the cluster nodes

Modify the `nodes.json` file as required to configure the nodes in the cluster e.g. configure node *name*, *ip*, *box*, *memory*, *cpus*, etc.

## Running the K8s cluster

```bash
cd /path/to/kube
./init.ps1
Add-HostOnlyNetwork
vagrant up
```

The `Add-HostOnlyNetwork` command will create a virtual adapter for connections between the host and VMs created in VirtualBox on the host.

The `vagrant up` command creates and configures guest machines according to the Vagrantfile. This particular Vagrantfile uses the [ansible_local](https://www.vagrantup.com/docs/provisioning/ansible_local.html) provisioner to setup a multi node Kubernetes cluster for development purposes. The ansible scripts are slight modifications to the ones outlined in [Kubernetes Setup Using Ansible and Vagrantfile](https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/).

## Running Ansible controller

```bash
cd /path/to/kube
docker build
docker-compose up
```
