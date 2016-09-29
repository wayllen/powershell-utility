#import vmware cli
Add-PSSnapin "Vmware.VimAutomation.Core" -ErrorAction SilentlyContinue


#vm vsphere server
$vsphereServer = "server ip"
$vsphereUser = "username"
$vspherePass = 'password'

#connect to the virtual server the VM's are on
Connect-VIServer -Server $vsphereServer -Protocol https -User $vsphereUser -Password $vspherePass

$VMs = Get-VMHost -Name 'hostname' | get-vm
$Data = @()

foreach ($VM in $VMs){
    #$VMGuest = Get-View $VM.Id    
    $NICs = $VM.NetworkAdapters
    foreach ($NIC in $NICs) {
        $into = New-Object PSObject
        Add-Member -InputObject $into -MemberType NoteProperty -Name VMname $VM.Name
        #Add-Member -InputObject $into -MemberType NoteProperty -Name VMfqdn $VM.Guest.HostName
        #Add-Member -InputObject $into -MemberType NoteProperty -Name NICtype $NIC.Type
        Add-Member -InputObject $into -MemberType NoteProperty -Name MacAddress $NIC.MacAddress
        #Add-Member -InputObject $into -MemberType NoteProperty -Name AddresType $NIC.ExtensionData.AddressType
        $Data += $into   
    }
}
$Data | Export-Csv -Path C:\VM-MacAddress.csv -NoTypeInformation
