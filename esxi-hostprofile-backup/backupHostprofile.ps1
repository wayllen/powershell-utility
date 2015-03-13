#import vmware cli
Add-PSSnapin "Vmware.VimAutomation.Core" -ErrorAction SilentlyContinue

#vm vsphere server
$vsphereServer = "IP"
$vsphereUser = "xx"
$vspherePass = 'xx'

#connect to the virtual server the VM's are on
Connect-VIServer -Server $vsphereServer -Protocol https -User $vsphereUser -Password $vspherePass
Write-Host "Connect to vCenter..."

#Backup the host profile
$dcName = "xx"
foreach($vmHost in (Get-VMHost -Location $dcName)){

    Get-VMHostFirmware -VMHost $vmHost -BackupConfiguration -DestinationPath C:\VMHOST\

}



#Restore the host profile
Set-VMHost -VMHost ESXi_host_IP_address -State 'Maintenance'

Set-VMHostFirmware -VMHost ESXi_host_IP_address -Restore -SourcePath backup_file -HostUser username -HostPassword password -Force
