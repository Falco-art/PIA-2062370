<#
.SYNOPSIS
  Recolecta información del sistema y la exporta a JSON.
.PARAMETER FullScan
  Ejecuta un escaneo completo.
#>
param(
    [switch]$FullScan
)

Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\modules\ps_utils.psm1"

$log = "logs/system_audit.log"
Write-Log "Starting system audit. FullScan=$FullScan" "INFO" $log

try {
    $sys = @{
        Hostname = $env:COMPUTERNAME
        OS = (Get-CimInstance Win32_OperatingSystem).Caption
        Users = (Get-LocalUser | Select-Object Name,Enabled)
        Processes = (Get-Process | Select-Object Id,ProcessName,CPU)
        Services = (Get-Service | Select-Object Name,Status)
        OpenPorts = @()
    }

    # Get listening TCP ports (requires admin)
    try {
        $netstat = netstat -ano | Select-String "LISTENING"
        $ports = $netstat -replace '.*:(\d+)\s+.*','$1' | Sort-Object -Unique
        $sys.OpenPorts = $ports
    } catch {
        Write-Log "Failed to enumerate ports: $_" "WARN" $log
    }

    $out = "results/system_audit_$(Get-Date -Format yyyyMMddHHmmss).json"
    $sys | ConvertTo-Json -Depth 5 | Out-File -FilePath $out -Encoding utf8
    Write-Log "System audit saved to $out" "INFO" $log
    Write-Output $out
} catch {
    Write-Log "Audit failed: $_" "ERROR" $log
    exit 1
}
