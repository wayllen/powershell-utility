function GetConnectionString()
{
  return "Server=serverName;Database=DBName;Integrated Security=False;User ID=user;Password=password"
}

#Define function with multiple parameters.
function InvokeSQL-SP($userID, $siteID, $playerID, $xRefID, $action, $cardIssued, $cardType) 
{
    Write-Host "userID=$userID"
    Write-Host "siteID=$siteID"
    Write-Host "playerID=$playerID"
    Write-Host "xRefID=$xRefID"
    Write-Host "action=$action"
    Write-Host "cardIssued=$cardIssued"
    Write-Host "cardType=$cardType"

    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $SqlConnection.ConnectionString = GetConnectionString

    $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
    $SqlCmd.CommandText = "dbo.Proc_PlayerCardDetailUpdate"  ## this is the stored proc name 
    $SqlCmd.Connection = $SqlConnection  
    $SqlCmd.CommandType = [System.Data.CommandType]::StoredProcedure  ## enum that specifies we are calling a SPROC 

      #set each of the 7 parameters 

      $param1=$SqlCmd.Parameters.Add("@@nUserID" , [System.Data.SqlDbType]::INT)
      $param1.Value = $userID 

      $param2=$SqlCmd.Parameters.Add("@@sSiteID" , [System.Data.SqlDbType]::SMALLINT)
      $param2.Value = $siteID 

      $param3=$SqlCmd.Parameters.Add("@@nPlayerID" , [System.Data.SqlDbType]::INT)
      $param3.Value = $playerID 

      $param4=$SqlCmd.Parameters.Add("@@szXRefID" , [System.Data.SqlDbType]::VARCHAR)
      $param4.Value = $xRefID 
      
      $param5=$SqlCmd.Parameters.Add("@@nAction" , [System.Data.SqlDbType]::INT)
      $param5.Value = $action 

      $param6=$SqlCmd.Parameters.Add("@@nCardIssued" , [System.Data.SqlDbType]::INT)
      $param6.Value = $cardIssued 

      $param7=$SqlCmd.Parameters.Add("@@tPhysicalCardType" , [System.Data.SqlDbType]::TINYINT)
      $param7.Value = $cardType 

    $SqlConnection.Open()
    $result = $SqlCmd.ExecuteNonQuery() 
    Write "result=$result" 
    $SqlConnection.Close()
}



CLS 



# Call Stored Procedure with the following parameters.

$userID = "1"
$siteID = "1"
#$playerID = "7"
#$xRefID = "10009" 
$action = "19"
$cardIssued = "1"
$cardType = "3"

# There're two parameters need to be passed from file.
$content = Get-Content C:\file.txt -ReadCount 0
foreach($line in $content)
{
  $array = $line -split "`t"  # Split the line with 'tab'.
  InvokeSQL-SP $userID $siteID $array[0] $array[1] $action $cardIssued $cardType
  #Write-Host $array[0]
  #Write-Host $array[1]
 
}

