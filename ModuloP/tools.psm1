function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO",
        [string]$LogFile = "logs/ps_utils.log"
    )
    $timestamp = (Get-Date).ToString("o")
    $entry = "$timestamp | ps_utils | $Level | $Message"
    $entry | Out-File -FilePath $LogFile -Append -Encoding utf8
}

function Get-FileSha256 {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        Write-Log "File not found: $Path" "ERROR"
        throw "File not found: $Path"
    }
    $sha = Get-FileHash -Path $Path -Algorithm SHA256
    return $sha.Hash
}

Export-ModuleMember -Function Write-Log, Get-FileSha256
