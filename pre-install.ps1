<#! Script: pre-format.ps1 !#>

# --- Step 1: Detect the REAL Documents Folder Path ---
# Using COM object to find the official 'My Documents' path (handles OneDrive & Language)
try {
    $ShellApp = New-Object -ComObject Shell.Application
    # 0x05 is the constant for 'My Documents'
    $DocumentsPath = $ShellApp.NameSpace(0x05).Self.Path
} catch {
    $DocumentsPath = Join-Path $env:USERPROFILE "Documents"
}

$BackupPath = Join-Path $DocumentsPath "Backups"

# --- Step 2: Prepare Backup Environment ---
if (-not (Test-Path $BackupPath)) { 
    New-Item -Path $BackupPath -ItemType Directory -Force | Out-Null 
}

# Folders to zip
$TargetFolders = @{
    "MobaXterm"   = "AppData\Roaming\MobaXterm"
    "DBeaverData" = "AppData\Roaming\DBeaverData"
    "NotepadPP"   = "AppData\Roaming\Notepad++"
    "OCI_Config"  = ".oci"
}

Write-Host "--- Starting Pre-Formatting Backup ---" -ForegroundColor Cyan
Write-Host "Target: $BackupPath" -ForegroundColor Gray
Write-Host "--------------------------------------"

# --- Step 3: Backup WinSCP (Registry Export) ---
Write-Host "Backing up WinSCP (Registry)..." -NoNewline
$WinSCPRegistryKey = "HKCU\Software\Martin Prikryl\WinSCP 2"
$WinSCPBackupFile = Join-Path $BackupPath "WinSCP_Backup.reg"

if (Test-Path "HKCU:\Software\Martin Prikryl\WinSCP 2") {
    try {
        # Exporting registry key using reg.exe
        & reg.exe export $WinSCPRegistryKey $WinSCPBackupFile /y | Out-Null
        Write-Host " [OK]" -ForegroundColor Green
    } catch {
        Write-Host " [ERROR] Failed to export WinSCP registry." -ForegroundColor Red
    }
} else {
    Write-Host " [SKIP] WinSCP registry key not found." -ForegroundColor Yellow
}

# --- Step 4: Backup Folders (Compression) ---
foreach ($AppName in $TargetFolders.Keys) {
    $SourcePath = Join-Path $env:USERPROFILE $TargetFolders[$AppName]
    $ZipFile = Join-Path $BackupPath "$AppName`_Backup.zip"

    if (Test-Path $SourcePath) {
        if (Test-Path $ZipFile) { Remove-Item $ZipFile -Force }
        try {
            Write-Host "Backing up $AppName..." -NoNewline
            Compress-Archive -Path $SourcePath -DestinationPath $ZipFile -ErrorAction Stop
            Write-Host " [OK]" -ForegroundColor Green
        } catch {
            Write-Host " [ERROR] Failed to compress $AppName." -ForegroundColor Red
        }
    } else {
        Write-Host "[SKIP] $AppName path not found." -ForegroundColor Yellow
    }
}

Write-Host "`nBackup process completed!" -ForegroundColor Cyan
Write-Host "Files saved in: $BackupPath" -ForegroundColor White
Write-Host "Note: To restore WinSCP, just double-click 'WinSCP_Backup.reg' on your new system." -ForegroundColor Gray
Write-Host "Press ENTER to close..."
[void][System.Console]::ReadLine()
