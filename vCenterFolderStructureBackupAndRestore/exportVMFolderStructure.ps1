#import vmware cli
Add-PSSnapin "Vmware.VimAutomation.Core" -ErrorAction SilentlyContinue

#vm vsphere server
$vsphereServer = "IP Address"
$vsphereUser = Get-Content C:\userInfo\username.txt
$vspherePass = Get-Content C:\userInfo\password.txt

#disconnect all exist connection first
Try
{
    Disconnect-VIServer * -Force -Confirm:$False
}
Catch
{
    Write-Host "Nothing to do - no open connections!"
}

#connect to the virtual server the VM's are on
Connect-VIServer -Server $vsphereServer -Protocol https -User $vsphereUser -Password $vspherePass
Write-Host "Connect to vCenter..."


    function Get-ParentName{
        param($object)

        if($object.Folder){
            $blue = Get-ParentName $object.Folder
            $name = $object.Folder.Name
        }
        elseif($object.Parent -and $object.Parent.GetType().Name -like "Folder*"){
            $blue = Get-ParentName $object.Parent
            $name = $object.Parent.Name
        }
        elseif($object.ParentFolder){
            $blue = Get-ParentName $object.ParentFolder
            $name = $object.ParentFolder.Name
        }
        if("vm","Datacenters" -notcontains $name){
            $blue + "/" + $name
        }
        else{
            $blue
        }
    }

#define your datacenter name value
$dcName = "your dc name"

foreach($vm in (Get-VM -Location $dcName) ){

    New-VIProperty -Name 'VMFolderPath' -ObjectType 'VirtualMachine' -Value {
    param($vm)
    (Get-ParentName $vm).Remove(0,1)
    } -Force | Out-Null 
    #Get-VM $vm | select Name, VMFolderPath
    

}



Get-VM -Location $dcName | 
Select Name,VMFolderPath |
Export-Csv "C:\vm-folder.csv" -NoTypeInformation -UseCulture 


