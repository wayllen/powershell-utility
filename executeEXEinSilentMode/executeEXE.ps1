#Method-1
$installParameters = $('/s', '/v"/qn"')
Start-Process -FilePath "path to the exe file" -ArgumentList $installParameters

#Method-2
$app = "path to the exe file"
$arg1 = "/s"
$arg2 = '/v" /qn"'
& $app $arg1 $arg2
