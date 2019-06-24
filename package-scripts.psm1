# Kube-Module.psm1
Write-Host "Loading Kube-Module"

function Add-HostOnlyNetwork {
   <#
   .SYNOPSIS
      Creates a new Host-only Network in VirtualBox.
   .DESCRIPTION
      Creates a new Host-only Network in VirtualBox.
   .PARAMETER ip
      The ip address of the newtork adapter
   .Example
      Add-Network
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
