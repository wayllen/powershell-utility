$userName = "dc\administrator"
$password = ConvertTo-SecureString "password" -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $password

# Define function installABS()
function installMSI($srcLocation, $computerName, $productName){

    $destLocation = "\\$computerName\c$"
    Copy-Item $srcLocation $destLocation -Force 
    Write-Host "Copied $productName to Computer $computerName !"
    
    if($productName -eq 'keyword1'){
        $installer = "c:\1.exe"
        $installParameters = '/s /v" /qn VBC_ID=2 VBC_WEB_IP=172.16.61.6"'
        Write-Host "Installing 1......"
    }
    if($productName -eq 'keyword2'){
        $installer = "c:\2.exe"
        $installParameters = '/s /v" /qn CASINO_SIZE=Large"'
        Write-Host "Installing 2......"
    }
    if($productName -eq 'keyword3'){
        $installer = "c:\3.exe"
        $installParameters = '/s /v" /qn ACCOUNTING=AdvantageS2S PATRON=Advantage VOUCHER=S2S COINLESS=Magcard FJP=Serverless JURISDICTION=None S2S_VERSION=1.3.1 CASINO_SIZE=Large ACCT_DB_HOST=192.168.18.11 PT_DB_HOST=192.168.18.11 S2S_DB_HOST=192.168.18.11 HYBRID_TYPE=Hybrid EGSDBCONN_PORT=8989 EGSDBCONN_HOST=192.168.18.11 WEBSERVICE_URL=http://192.168.18.10/s2s/s2s.asmx S2S_VOUCHER=S2S"'
        Write-Host "Installing 3......"
    
    }
    if($productName -eq 'keyword4'){
        $installer = "c:\4.exe"
        $installParameters = '/s /v" /qn "'
        Write-Host "Installing 4......"
    }
    if($productName -eq 'keyword5'){
        $installer = "c:\5.exe"
        $installParameters = '/s /v" /qn CASINO_SIZE=Large JURISDICTION=11 BBPG_SECURITY_LEVEL=3 CASINO_NAME=lab"'
        Write-Host "Installing 5......"
    }
    
   
     Invoke-Command -ComputerName $computerName -ScriptBlock {`
        start-process -FilePath $args[0] -ArgumentList $args[1]  -Wait} -Credential $cred -ArgumentList $installer, $installParameters
    
}


Write-Host `
"#------------------------------------------------
#Uninstall all  products: $(Get-Date -f G)      
#------------------------------------------------" 

& unInstallMSI.ps1



Write-Host `
"#------------------------------------------------
#Install products started: $(Get-Date -f G)      
#------------------------------------------------" 


#Install 1
$productName = "keyword1"
$computerName = "computername"
$srcLocation = "C:\1.exe"
installABS $srcLocation $computerName $productName

#Install 2 
$productName = "keyword2"
$srcLocation = "C:\2.exe"
installABS $srcLocation $computerName $productName

#Install 3
$productName = "keyword3"
$srcLocation = "C:\3.exe"
installABS $srcLocation $computerName $productName

#Install 4
$productName = "keyword4"
$srcLocation = "C:\4.exe"
Invoke-Command -ComputerName $computerName -ScriptBlock {Remove-Item "C:\Program Files (x86)\IGT Systems\ABS" -Recurse -Force -Confirm:$false -ErrorAction silentlyContinue} -Credential $cred
installABS $srcLocation $computerName $productName


#Install 5
$productName = "keyword5"
$srcLocation = "C:\5.exe"
installABS $srcLocation $computerName $productName


Write-Host `
"#------------------------------------------------
#Completed all ABS products installation steps: $(Get-Date -f G)      
#------------------------------------------------" 






