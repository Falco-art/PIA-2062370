param([string]$Target)

$log = "logs/network_info.log"
Write-Log "Starting network info for $Target" "INFO" $log

try {
    if (-not $Target) { Write-Log "No target provided" "ERROR" $log; exit 2 }
    $dns = Resolve-DnsName -Name $Target -ErrorAction SilentlyContinue
    $out = @{
        Target = $Target
        DNS = $dns
    }
    $file = "results/network_info_$(Get-Date -Format yyyyMMddHHmmss).json"
    $out | ConvertTo-Json -Depth 5 | Out-File $file -Encoding utf8
    Write-Log "Network info saved to $file" "INFO" $log
    Write-Output $file
} catch {
    Write-Log "Network info failed: $_" "ERROR" $log
    exit 1
}
