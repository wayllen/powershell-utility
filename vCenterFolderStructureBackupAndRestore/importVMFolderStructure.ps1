
#import vmware cli
Add-PSSnapin "Vmware.VimAutomation.Core" -ErrorAction SilentlyContinue

Try
{
    Disconnect-VIServer * -Force -Confirm:$False
}
Catch
{
    Write-Host "Nothing to do - no open connections!"
}

#vm vsphere server
$vsphereServer = "IP Address"
$vsphereUser = Get-Content C:\userInfo\username.txt
$vspherePass = Get-Content C:\userInfo\password.txt


#Set-PowerCLIConfiguration  -DefaultVIServerMode Single -Confirm:$false
#connect to the virtual server the VM's are on
Connect-VIServer -Server $vsphereServer -Protocol https -User $vsphereUser -Password $vspherePass 
Write-Host "Connect to vCenter..."

#$newDatacenter = "new dc name" 


Import-Csv "C:\vm-folder.csv" -UseCulture | %{
    $location = Get-Folder -Name vm -Location $newDatacenter
   
    $_.BlueFolderPath.TrimStart('/').Split('/') | %{
        $tgtFolder = Get-Folder -Name $_ -Location $location -ErrorAction SilentlyContinue
        if(!$tgtFolder){
            $location = New-Folder -Name $_ -Location $location
            Write-Host "New Folder $_"
        }
        else{
            $location = $tgtFolder
            Write-Host "The folder $_ already exist."
        }
    }
    
    
    Write-Host "The VM name is $vm."
        $vm = Get-VM -Name $_.Name -ErrorAction SilentlyContinue
        if($vm){
            Move-VM -VM $vm -Destination $location -Confirm:$false 
            Write-Host "Moved vm $vm to folder $location !"
        }


}

