$userName = "dc\username"
$password = ConvertTo-SecureString "password" -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password

$sourceFileLocation = "C:\test.exe"


$computerList = Get-Content "C:\computerList.txt"
$IPList = Get-Content "C:\IPList.txt"
$id = 2
for($i=0; $i -lt $computerList.Length; $i++){

  $destFileLocation = "\\$($computerList[$i])\c$"
  Copy-Item $sourceFileLocation $destFileLocation

  #Define installShiled parameters passing. Format the parameter string with local variables.
  #Silence installation.
  $paras = ('/s /v" /qn VBC_ID={0} VBC_WEB_IP={1}"' -f $id,$($IPList[$i]))
  #Passing local variables into script block with -ArgumentList switch.
  Invoke-Command -ComputerName $($computerList[$i]) -ScriptBlock {`
      start-process -FilePath "c:\test.exe" -ArgumentList $args[0]  -Wait} -Credential $cred -ArgumentList $paras

   Write-Host "ID value = $id"
   Write-Host "IP = $($IPList[$i])"
   Write-Host "ComputerName = $($computerList[$i])"
   $id++

}
