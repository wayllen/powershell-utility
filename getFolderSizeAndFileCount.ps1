$folder = "C:\folder\"


Get-ChildItem -Path $folder -Recurse -Force -ErrorAction 0 |
  Measure-Object -Property Length -Sum  |
  ForEach-Object {
    $sum = $_.Sum / 1MB
    $count = $_.Count
    "Your folder count is $count and size = {0:#,##0.0} MB" -f $sum
} 
