<#! Script: pre-format.ps1 !#>
$OneDriveRoot = "$env:USERPROFILE\OneDrive - Pague Menos Comercio de Produtos Alimenticios Ltda"
$BackupPath = Join-Path $OneDriveRoot "Documentos\Backups"

if (-not (Test-Path $BackupPath)) { 
    New-Item -Path $BackupPath -ItemType Directory -Force | Out-Null 
}

$TargetFolders = @{
    "MobaXterm"   = "AppData\Roaming\MobaXterm"
    "DBeaverData" = "AppData\Roaming\DBeaverData"
    "NotepadPP"   = "AppData\Roaming\Notepad++"  # Pasta raiz para trazer plugins
    "OCI_Config"  = ".oci"
}

Write-Host "--- Iniciando Backup Pré-Formatação ---" -ForegroundColor Cyan

foreach ($AppName in $TargetFolders.Keys) {
    $SourcePath = Join-Path $env:USERPROFILE $TargetFolders[$AppName]
    $ZipFile = Join-Path $BackupPath "$AppName`_Backup.zip"

    if (Test-Path $SourcePath) {
        if (Test-Path $ZipFile) { Remove-Item $ZipFile -Force }
        try {
            Compress-Archive -Path $SourcePath -DestinationPath $ZipFile -ErrorAction Stop
            Write-Host "[OK] $AppName compactado com sucesso." -ForegroundColor Green
        } catch {
            Write-Host "[ERRO] Falha em $AppName." -ForegroundColor Red
        }
    }
}

Write-Host "`nO backup foi salvo na pasta: $BackupPath" -ForegroundColor Cyan
Write-Host "Pressione ENTER para fechar..."
[void][System.Console]::ReadLine()
