# Define helper functions for script operations

function Initialize-Folder {
    param (
        [string]$FolderPath
    )
    if (-not (Test-Path -Path $FolderPath)) {
        New-Item -ItemType Directory -Path $FolderPath -Force | Out-Null
        Write-Host "Created folder: $FolderPath"
    }
}

function Check-ExecutableExists {
    param (
        [string]$ExecutablePath
    )
    if (-not (Test-Path -Path $ExecutablePath)) {
        throw "ProcMon executable not found at path: $ExecutablePath"
    }
}

function Check-ConfigFileExists {
    param (
        [string]$ConfigPath
    )
    if (-not (Test-Path -Path $ConfigPath)) {
        Write-Host "Configuration file not found at path: $ConfigPath. Nothing happened."
        return $false
    } else {
        return $true
    }
}

function Start-ProcMonCapture {
    param (
        [string]$ExecutablePath,
        [string]$LogFilePath,
        [string]$ConfigPath
    )
    # Check if configuration file exists before starting ProcMon
    $configExists = Check-ConfigFileExists -ConfigPath $ConfigPath
    if (-not $configExists) {
        return # Exit the function early if config file does not exist
    }

    & $ExecutablePath /Minimized /Quiet /BackingFile $LogFilePath /LoadConfig $ConfigPath
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to start ProcMon capturing."
    }
    Write-Host "ProcMon capturing has started. Log file will be saved to: $LogFilePath"
}

function Stop-ProcMonCapture {
    param (
        [string]$ExecutablePath
    )
    & $ExecutablePath /Terminate
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to stop ProcMon capturing."
    }
    Write-Host "ProcMon capturing has completed."
}

# Main script logic starts here

try {
    # Automatically determine the script's directory
    $scriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

    # Define the path for the CyberKombatData folder in the user's Documents directory
    $folderPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "CyberKombatData")
    Initialize-Folder -FolderPath $folderPath

    # Define the file path for the ProcMon log file within the CyberKombatData folder
    $logFilePath = [System.IO.Path]::Combine($folderPath, "ProcMonLog.pml")

    # Set the ProcMon executable path to be in the same directory as this script
    $procMonExecutablePath = [System.IO.Path]::Combine($scriptPath, "procmon.exe")
    Check-ExecutableExists -ExecutablePath $procMonExecutablePath

    # Start ProcMon with command-line arguments to begin capturing
    Start-ProcMonCapture -ExecutablePath $procMonExecutablePath -LogFilePath $logFilePath -ConfigPath "$scriptPath\Config1.pmc"

    # Wait for a specific duration for capturing (e.g., 10 seconds)
    Start-Sleep -Seconds 10

    # Stop ProcMon capturing
    Stop-ProcMonCapture -ExecutablePath $procMonExecutablePath

    # Add automation for post-capture processing if applicable

} catch {
    Write-Error "An error occurred: $_"
    exit
}
