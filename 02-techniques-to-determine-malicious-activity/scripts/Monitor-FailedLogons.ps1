Get-WinEvent -ComputerName corp-dc-001 -MaxEvents 100 -FilterHashtable @{
LogName = "Security"
ID = (4625)
StartTime=((Get-Date).AddDays(-1))} |
Out-GridView
