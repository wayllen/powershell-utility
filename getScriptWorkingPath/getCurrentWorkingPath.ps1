#Get the current script work directory full path.
$fullPathIncFileName = $MyInvocation.MyCommand.Definition
Write-Host $fullPathIncFileName

#Get current script name.
$currentScriptName = $MyInvocation.MyCommand.Name
Write-Host $currentScriptName

#Get the current script working path in way 1.
$currentExecutingPath = $fullPathIncFileName.Replace($currentScriptName, "")
Write-Host $currentExecutingPath

#Get the current script working path in way 2.
Split-Path $MyInvocation.InvocationName
