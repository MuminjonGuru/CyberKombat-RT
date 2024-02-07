# ProcessInfo.ps1
Get-Process | Select-Object Id, ProcessName, CPU, WS | Export-Csv -Path "process_info.csv" -NoTypeInformation

# This script retrieves all running processes and selects the process ID, name, CPU time, 
# and working set (memory usage), then exports the data to a CSV file. You can schedule this PowerShell script 
# to run at regular intervals using Windows Task Scheduler or trigger it within your application.