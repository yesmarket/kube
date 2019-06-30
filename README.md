# Kube

## Objective

This repo has scripts to setup a multi node Kubernetes cluster for development purposes as well as a containerised AWX controller to deploy workloads into the K8s cluster using Ansible.

## Prerequisites

* git
* PowerShell
* node/npm
* Vagrant
* VirtualBox
* Docker (or Docker Machine)
* Docker Compose

## Initialise

```bash
cd /path/to/kube
./init.ps1
```

## Configure

Modify the `nodes.json` file as required to configure the nodes in the cluster e.g. configure node *name*, *ip*, *box*, *memory*, *cpus*, etc.

## Running the K8s cluster

```bash
cd /path/to/kube
npm run kube-cluster
```

This will do the following;
<ol type="a">
  <li>Creates a virtual adapter for connections between the host and VMs created in VirtualBox.</li>
  <li>Creates and configures guest machines according to the Vagrantfile. The Vagrantfile in this repo uses the <a href="https://www.vagrantup.com/docs/provisioning/ansible_local.html">ansible_local</a> provisioner to setup a multi node Kubernetes cluster for development purposes. Note: using the <i>ansible_local</i> provisioner as this approach will work for both Linux and Windows hosts. The ansible scripts are slight modifications to the ones outlined in <a href="https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/">Kubernetes Setup Using Ansible and Vagrantfile</a>.</li>
  <li>Configures <i>kubectl</i> on the host to work with the newly created kube cluster.</li>
</ol>

## Running AWX

```bash
cd /path/to/kube
npm run awx-in-docker
```
