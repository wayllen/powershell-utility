#import vmware cli
Add-PSSnapin "Vmware.VimAutomation.Core" -ErrorAction SilentlyContinue


#vm vsphere server
$vsphereServer = "IP"
$vsphereUser = "username"
$vspherePass = 'password'
$vmlist = get-content "C:\backup-vm\backupVMList.txt"

#connect to the virtual server the VM's are on
Connect-VIServer -Server $vsphereServer -Protocol https -User $vsphereUser -Password $vspherePass

##################
# VM name check.
##################

foreach ($vm in $vmlist)
{
    if($vm -ne "")
    {
        $checkedVM = Get-VM -Name $vm -ErrorAction SilentlyContinue -ErrorVariable errorVar
        if($errorVar)
        {
            Write-Host "The VM $vm doesn't exist!" -ForegroundColor "red"
        }
        else
        {
            Write-Host "The VM name = $vm" -ForegroundColor "green"
        }
    }

}

##################
# VM backup.
##################
Get-Job | Remove-Job -Force

$pw = "password"
$ovfTool = "C:\Program Files\VMware\VMware OVF Tool\ovftool.exe"


$backupFolder = "G:\vm\$(get-date -format MM-dd-yyyy)"

if(Test-Path $backupFolder)
{
    Write-Host "path is exist!"
}
else
{
    New-Item -type directory -Path $backupFolder
}


$backupCMD = {
param($ovfTool, $vm, $pw, $backupFolder)
& $ovfTool --powerOffSource --noSSLVerify "vi://username:$pw@$vCenterAdress/$dcName/host/$clusterName/Resources/$vm"  "$backupFolder\$vm.ova"
}



foreach ($vm in $vmlist)
{
    
    if($vm -ne "")
    {
        Write-Host "Starting export $vm to local folder."
        Start-Job -ScriptBlock $backupCMD -ArgumentList $ovfTool, $vm, $pw, $backupFolder
    }
    

}


Get-Job | Wait-Job

##################
# Power on all VMs
##################
foreach ($vm in $vmlist)
{
    if($vm -ne "")
    {
        $powerState = Get-VM -Name $vm -ErrorAction SilentlyContinue -ErrorVariable errorVar
        if($errorVar)
        {
            Write-Host "The VM $vm doesn't exist!" -ForegroundColor "red"
        }
        else
        {
            if($powerState.PowerState -eq "PoweredOff")
            {
                Write-Host "The VM $vm Currently in power off state, powering on now!" -ForegroundColor "green"
                Start-VM -VM $vm -Confirm:$false -RunAsync
            }
            
        }
    }

}


Disconnect-VIServer -Server $vsphereServer -Confirm:$False
