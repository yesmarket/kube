# Kube-Module.psm1
Write-Host "Loading Kube-Module"

function Add-Network {
   <#
   .SYNOPSIS
      Creates a new Host-only Network in VirtualBox.
   .DESCRIPTION
      Creates a new Host-only Network in VirtualBox.
   .PARAMETER service_name
      The name of the microservice
   .Example
      Add-Network
   #>
   Param(
      [int]$id=1,
      [string]$ip='192.168.101.1',
      [string]$netmask='255.255.255.0'
   )
   if (!(Get-Command vboxmanage -errorAction SilentlyContinue))
   {
      echo 'virtual box required'
      return
   }
   VBoxManage hostonlyif create
   VBoxManage hostonlyif ipconfig "VirtualBox Host-Only Ethernet Adapter #$id" --ip $ip --netmask $netmask
}
