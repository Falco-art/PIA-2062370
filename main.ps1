$log = "logs/main.log"
New-Item -ItemType Directory -Path logs -Force | Out-Null
New-Item -ItemType Directory -Path results -Force | Out-Null
Add-Content $log "$(Get-Date -Format o) | orchestrator | INFO | Starting pipeline"

# 1) Recon (call bash if available via WSL)
if (Get-Command bash -ErrorAction SilentlyContinue) {
    $recon = bash -c "bash/recon.sh example.com"
    Add-Content $log "$(Get-Date -Format o) | orchestrator | INFO | Recon output: $recon"
}

# 2) PowerShell system audit
try {
    $sys = .\powershell\system_audit.ps1 -FullScan
    Add-Content $log "$(Get-Date -Format o) | orchestrator | INFO | System audit output: $sys"
} catch {
    Add-Content $log "$(Get-Date -Format o) | orchestrator | WARN | System audit failed: $_"
}

# 3) Aggregate and analyze (call python)
python python/analyser.py --input results/collected_placeholder.json --output results/analysis.json
python python/reportes.py --input results/analysis.json --html results/report.html --json results/report.json

Add-Content $log "$(Get-Date -Format o) | orchestrator | INFO | Pipeline complete"
