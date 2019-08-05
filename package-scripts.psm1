# Kube-Module.psm1
Write-Host "Loading Kube-Module"

function New-VirtualNetworkAdapter {
   <#
   .SYNOPSIS
      Creates a new Host-only Network in VirtualBox.
   .DESCRIPTION
      Creates a new Host-only Network in VirtualBox.
   .PARAMETER ip
      The IP address of the newtork adapter
   .Example
      New-VirtualNetworkAdapter
   #>
   Param(
      [string]$ip='192.168.101.1'
   )
   if (!(Get-Command vboxmanage -errorAction SilentlyContinue))
   {
      echo 'virtual box required'
      return
   }
   $message = VBoxManage hostonlyif create
   $id = $message | Select-String -Pattern ".*'(.*)'.*" | foreach {$_.Matches.Groups[1].Value}
   VBoxManage hostonlyif ipconfig "$id" --ip $ip --netmask 255.255.255.0
   echo "Host-only Network '$id' created with IP Address $ip"
}

function Set-KubeConfig {
   <#
   .SYNOPSIS
      Sets the KUBECONFIG environment variable for kubectl to use the local kube cluster.
   .DESCRIPTION
      Sets the KUBECONFIG environment variable for kubectl to use the local kube cluster.
   .Example
      Set-KubeConfig
   #>
   $Env:KUBECONFIG="$PSScriptRoot\config"
}

function New-KubeCluster {
   Param(
      [string]$virtual_network_adapter_ip='192.168.101.1'
   )
   New-VirtualNetworkAdapter -ip $virtual_network_adapter_ip
   if (!(Get-Command vagrant -errorAction SilentlyContinue))
   {
      echo 'vagrant required'
      return
   }
   vagrant up
   Set-KubeConfig
}

function Set-DockerMachine {
   <#
   .SYNOPSIS
      Configure VirtualBox port binding for people using docker-machine.
   .DESCRIPTION
      Configure VirtualBox port binding for people using docker-machine.
   .PARAMETER machine
      The name of the docker-machine.
   .Example
      Set-DockerMachine -name test
   #>
   Param(
      [string]$name='default'
   )
   if (!(Get-Command vboxmanage -errorAction SilentlyContinue) -or !(Get-Command docker-machine -errorAction SilentlyContinue))
   {
      echo 'virtual box and docker-machine required'
      return
   }
   if (!(vboxmanage list vms | ? { $_ -like "*`"$name`"*" })) {
      echo "virtual machine '$name' does not exist"
      return
   }
   if ((docker-machine status $name) -eq "Stopped") {
      docker-machine start $name
   }
   vboxmanage controlvm $name natpf1 delete awx_web
   vboxmanage controlvm $name natpf1 "awx_web,tcp,,8052,,8052"
   $ip = iex "docker-machine ip $name"
   $Env:DOCKER_HOST = "tcp://${ip}:2376"
}

function Reset-Docker {
   <#
   .SYNOPSIS
      Helper function to remove docker containers, volumes, networks, and images.
   .DESCRIPTION
      Helper function to remove docker containers, volumes, networks, and images.
   .PARAMETER containers
      Specifies, whether or not, docker containers will be removed.
   .PARAMETER volumes
      Specifies, whether or not, docker volumes will be removed.
   .PARAMETER networks
      Specifies, whether or not, docker networks will be removed.
   .PARAMETER images
      Specifies, whether or not, docker images will be removed.
   .Example
      Reset-Docker -containers $true -volumes $true -networks $true
   #>
   Param(
      [bool]$containers=$true,
      [bool]$volumes=$true,
      [bool]$networks=$true,
      [bool]$images=$false
   )
   if (!(Get-Command docker))
   {
      echo 'docker required'
      return
   }
   if ($containers) {
      if (docker ps -q) {
         echo "stopping running containers..."
         docker stop $(docker ps -q) > $null
      }
      if (docker ps -a -q) {
         echo "removing containers..."
         docker rm $(docker ps -a -q) > $null
      }
   }
   if ($volumes -And (docker volume ls -q)) {
      echo "removing volumes..."
      docker volume rm $(docker volume ls -q) > $null
   }
   if ($networks -And (docker network ls -q)) {
      echo "removing networks..."
      docker network rm $(docker network ls -q) > $null
   }
   if ($images -And (docker ps -a -q)) {
      echo "removing images..."
      docker rmi $(docker ps -a -q) > $null
   }
}

function New-Awx {
   <#
   .SYNOPSIS
      Helper function to remove docker containers, volumes, networks, and images.
   .DESCRIPTION
      Helper function to remove docker containers, volumes, networks, and images.
   .PARAMETER docker_machine_name
      Docker machine name to configure
   .PARAMETER reset_containers
      Specifies, whether or not, existing docker containers will be removed.
   .PARAMETER reset_containers
      Specifies, whether or not, existing docker volumes will be removed.
   .PARAMETER reset_networks
      Specifies, whether or not, existing docker networks will be removed.
   .PARAMETER reset_images
      Specifies, whether or not, existing docker images will be removed.
   .Example
      Reset-Docker -containers $true -volumes $true -networks $true
   #>
   Param(
      [string]$docker_machine_name=$null,
      [bool]$reset_containers=$false,
      [bool]$reset_volumes=$false,
      [bool]$reset_networks=$false,
      [bool]$reset_images=$false
   )
   if ($docker_machine_name) { Set-DockerMachine -name $docker_machine_name }
   if ($reset_containers -or $reset_volumes -or $reset_networks -or $reset_images) { Reset-Docker -containers $reset_containers -volumes $reset_volumes -networks $reset_networks -images $reset_images }
   if (!(Get-Command docker-compose -errorAction SilentlyContinue))
   {
      echo 'docker-compose required'
      return
   }
   docker-compose -f ./awx.yml up
}
