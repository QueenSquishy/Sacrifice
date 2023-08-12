$services = "WinDefend", "WdNisSvc", "HealthService", "Sense", "SecurityHealthService"
$mapsSetting = 3  

foreach ($service in $services) {
    $status = Get-Service -Name $service

    if ($status.Status -ne "Running") {
        Write-Host "Service $service is not running. Attempting to start..."
        try {
            Start-Service -Name $service
            Write-Host "Service $service started successfully."
        } catch {
            Write-Host "A service failed to start: $_"
        }
    } else {
        Write-Host "Service $service is running."
    }
}

# Enable Maps
try {
    Set-MpPreference -MAPSReporting 'Advanced'
    Write-Host "MAPS setting updated to level $mapsSetting."
} catch {
    Write-Host "Failed to update MAPS setting: $_"
}

# Enable ASR rule
try {
    Set-MpPreference -AttackSurfaceReductionRules_Ids "75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84"

    Write-Host "ASR rule '$asrRuleId' enabled."
} catch {
    Write-Host "Failed to enable ASR rule: $_"
}
