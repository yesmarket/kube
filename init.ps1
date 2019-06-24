$module_path = $env:PSModulePath.split(';')[0] + "/Kube-Module"
if (Get-Module -Name package-scripts) {
   echo "removing existing powerShell module..."
   Remove-Module package-scripts
   rmdir $module_path -Force -Recurse
}
echo "creating powerShell module..."
New-Item -ItemType Directory -Force -Path $module_path > $null
cp ./package-scripts.psm1 $module_path/Kube-Module.psm1
New-ModuleManifest -Path $module_path/Kube-Module.psd1 -RootModule Kube-Module.psm1 -Author 'Ryan Bartsch' -Description 'A few helper functions to run local Kubernetes cluster' -PowerShellVersion '5.0'
echo "importing module for current session..."
Import-Module ./package-scripts -Global -DisableNameChecking
