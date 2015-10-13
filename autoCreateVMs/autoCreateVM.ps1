param($vmTemplateName, $vmHostName, $vmDSName, $dcFlag, $vmIP, $vmName)


#import vmware cli
Add-PSSnapin "Vmware.VimAutomation.Core" -ErrorAction SilentlyContinue


#vm vsphere server
$vsphereServer = "vCenter IP"
$vsphereUser = "username"
$vspherePass = 'password'

#connect to the virtual server the VM's are on
Connect-VIServer -Server $vsphereServer -Protocol https -User $vsphereUser -Password $vspherePass

$vmSubnetMask = 'define your subnet'
$vmDefaultGateway = 'gateway'
$vmDNS = 'DNS'


# delete the temp OSCustSpec
Get-OSCustomizationSpec -Name ADV-WinCustFile-copy  | Remove-OSCustomizationSpec -Confirm:$False
## get a customization spec manager View object
$csmSpecMgr = Get-View 'CustomizationSpecManager'
## duplicate the given customization spec to another of the given new name
if($dcFlag)
  {  
    $csmSpecMgr.DuplicateCustomizationSpec("DomainRequestVM", "ADV-WinCustFile-copy")
  }
else
  {
    $csmSpecMgr.DuplicateCustomizationSpec("nonDomainRequestVM", "ADV-WinCustFile-copy")
  }

## retrieve the cloned spec
$oscCopy = Get-OSCustomizationSpec -Name "ADV-WinCustFile-copy"


$oscCopy | Get-OSCustomizationNicMapping | `
 Set-OSCustomizationNicMapping -IpMode UseStaticIP `
                               -IpAddress $vmIP `
                               -SubnetMask $vmSubnetMask `
                               -DefaultGateway $vmDefaultGateway `
                               -Dns $vmDNS


New-VM -Name $vmName -Template $vmTemplateName `
       -VMHost $vmHostName `
       -Datastore $vmDSName `
       -OSCustomizationSpec $oscCopy `
       -Confirm:$False `
       -RunAsync     

#}
       
#Get-Job | Wait-Job

#Start-VM $vmName   
       
       
Disconnect-VIServer -Server $vsphereServer -Confirm:$False
