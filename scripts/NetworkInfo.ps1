#            Muminjon Abduraimov
#       De Montfort University (Leicester)
# This script relies on the NetworkInfo.ps1 script

# Define the path for the CyberKombatData folder in the user's Documents directory
$folderPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "CyberKombatData")

# Check if the folder exists; if not, create it
if (-not (Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

# Define the file path for the CSV file within the CyberKombatData folder
$filePath = [System.IO.Path]::Combine($folderPath, "network_info.csv")

try {
    # Get active TCP connections excluding local loopback connections
    $connections = Get-NetTCPConnection | Where-Object { $_.LocalAddress -ne "127.0.0.1" -and $_.RemoteAddress -ne "127.0.0.1" }

    # Fetch detailed process information
    $processes = Get-Process | Where-Object { $_.Id -in $connections.OwningProcess } | Select-Object Id, ProcessName

    # Join connections with process information
    $detailedConnections = $connections | ForEach-Object {
        $connection = $_
        $process = $processes | Where-Object { $_.Id -eq $connection.OwningProcess }
        [PSCustomObject]@{
            ProcessName    = $process.ProcessName
            OwningProcess  = $connection.OwningProcess
            LocalAddress   = $connection.LocalAddress
            LocalPort      = $connection.LocalPort
            RemoteAddress  = $connection.RemoteAddress
            RemotePort     = $connection.RemotePort
            State          = $connection.State
        }
    }

    # Export detailed connections to CSV
    $detailedConnections | Export-Csv -Path $filePath -NoTypeInformation
} catch {
    Write-Error "Failed to gather or export network information. Error: $_"
}
