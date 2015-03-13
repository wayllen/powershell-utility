$code = 
{
  if ($_.Length -gt 1MB)
  {'huge'}
  elseif ($_.Length -gt 10KB)
  {'average'}
  else
  {'tiny'}
}

$hash = Get-ChildItem -Path C:\folder |
  Group-Object -Property $code -AsHashTable -AsString
  
  
  
#$hash.Tiny
$hash.Huge

