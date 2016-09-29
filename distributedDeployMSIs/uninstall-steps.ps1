#disable all keyword releated services and stop them
$Services = Get-Service | Where-Object {$_.DisplayName -like "keyword*"}
if ($Services) {
    foreach ($service in $Services) {
        $servicename = $service.Name
        $servicestatus = $service.Status
        Set-Service -Name $servicename -StartupType Disabled
        $Processes = Get-Process | Where-Object {$_.Name -like 'keyword' -or $_.Name -like 'keyword'}
        if ($Processes) {
            foreach($process in $Processes){
                Stop-Process $process.id -Force
            }
        }
        Stop-Service $servicename -Force -ErrorAction SilentlyContinue
    }
}
$products = Get-WmiObject -Class Win32_Product | Where-Object {
$_.Vendor -like "keyword*" -or $_.Vendor -like "keyword"
}
if($products){
	foreach ($product in $products) {
		$product.Uninstall()
	}
}
$Services = Get-Service | Where-Object {$_.DisplayName -like 'keyword*'}
if ($Services) {
    foreach ($service in $Services) {
        $servicename = $service.Name
        C:\WINDOWS\system32\sc.exe delete $servicename
    }
}



