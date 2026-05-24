param(
    [string]$ManualMapPath = "C:\Users\ccsgo\Downloads\ManualMap.exe",
    [string]$InjectDllPath = "C:\Users\ccsgo\Downloads\Inject.dll",      # ← Ruta del Inject.dll
    [string]$TargetDllPath = "C:\Users\ccsgo\Downloads\shakira.dll",     # ← DLL que quieres inyectar
    [string]$ProcessName   = "notepad.exe"
)

# Validaciones
if (-not (Test-Path $ManualMapPath)) {
    Write-Host "[!] ManualMap.exe no encontrado" -ForegroundColor Red
    pause
    exit 1
}
if (-not (Test-Path $InjectDllPath)) {
    Write-Host "[!] Inject.dll no encontrado" -ForegroundColor Red
    pause
    exit 1
}
if (-not (Test-Path $TargetDllPath)) {
    Write-Host "[!] shakira.dll no encontrado" -ForegroundColor Red
    pause
    exit 1
}

try {
    Write-Host "[+] Cargando ManualMap en memoria..." -ForegroundColor Cyan
    
    $bytes = [System.IO.File]::ReadAllBytes($ManualMapPath)
    $asm = [System.Reflection.Assembly]::Load($bytes)

    $arguments = [string[]]@(
        $InjectDllPath,      # ← Ruta completa de Inject.dll (esto era el error)
        $ProcessName,
        $TargetDllPath
    )

    Write-Host "[+] Inyectando $TargetDllPath → $ProcessName" -ForegroundColor Cyan
    
    $result = $asm.EntryPoint.Invoke($null, (, $arguments))

    Write-Host "[+] Proceso terminado. Código: $result" -ForegroundColor Green
}
catch {
    Write-Host "[!] ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.InnerException) {
        Write-Host "[!] Inner: $($_.Exception.InnerException.Message)" -ForegroundColor Red
    }
}

Write-Host "`nPresiona cualquier tecla para cerrar..." -ForegroundColor Yellow
pause