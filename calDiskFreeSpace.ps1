
$freedisk = ([WMI]'Win32_LogicalDisk.DeviceID="c:"').FreeSpace /1GB

"The D drive Free Space is {0:n2} GB" -f $freedisk
