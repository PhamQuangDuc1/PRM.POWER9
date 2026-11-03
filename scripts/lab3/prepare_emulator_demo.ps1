param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^emulator-\d+$')]
    [string]$DeviceId,
    [string]$FlutterCommand = 'flutter',
    [string]$AdbPath = "$env:LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"
)
$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
Push-Location $repoRoot
try {
    if (-not (Test-Path -LiteralPath $AdbPath)) { throw 'ADB not found; provide -AdbPath.' }
    $state = & $AdbPath -s $DeviceId get-state 2>$null
    if ($LASTEXITCODE -ne 0 -or $state.Trim() -ne 'device') { throw 'Start and unlock the selected emulator first.' }
    $abi = (& $AdbPath -s $DeviceId shell getprop ro.product.cpu.abi).Trim()
    if ($LASTEXITCODE -ne 0 -or $abi -ne 'x86_64') { throw 'This helper requires an x86_64 Android emulator.' }
    & $FlutterCommand build apk --debug --target-platform android-x64 --dart-define=POWER9_E2E_BUILD=p9_emulator_demo_20261104
    if ($LASTEXITCODE -ne 0) { throw 'Emulator APK build failed; no APK installed.' }
    $apkPath = Join-Path $repoRoot 'build/app/outputs/flutter-apk/app-debug.apk'
    $demoApkPath = Join-Path $repoRoot 'output/lab3/Power9-Lab3-emulator-x64-debug.apk'
    Copy-Item -LiteralPath $apkPath -Destination $demoApkPath -Force
    & $AdbPath -s $DeviceId install -r $demoApkPath
    if ($LASTEXITCODE -ne 0) { throw 'APK installation failed.' }
    & $AdbPath -s $DeviceId shell am start -n vn.power9.power9_office_routine/.MainActivity
    if ($LASTEXITCODE -ne 0) { throw 'App launch failed.' }
    Write-Output 'Power9 opened on the selected emulator. Sign in manually and rehearse the demo.'
} finally {
    Pop-Location
}
