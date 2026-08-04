$tasks = @( 
    "SystemHealthReport",
    "GitAssistant AutoUpdate"
)

Write-Host "--- ГЛОБАЛЬНАЯ ОЧИСТКА ---" -ForegroundColor Cyan

foreach ($task in $tasks) {
    if (Get-ScheduledTask -TaskName $task -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $task -Confirm:$false
        Write-Host "[+] Задача '$task' удалена." -ForegroundColor Green
    }
}

$currentPid = $PID
$otherPowershells = Get-Process powershell | Where-Object { $_.Id -ne $currentPid }
if ($otherPowershells) {
    $otherPowershells | Stop-Process -Force
    Write-Host "[+] Все фоновые скрипты остановлены." -ForegroundColor Green
}

$folders = @(
    "$env:APPDATA\WindowsHealth",
    "$env:APPDATA\Microsoft\Protect\Health"
)
foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Remove-Item -Path $folder -Recurse -Force
        Write-Host "[+] Папка $folder удалена." -ForegroundColor Green
    }
}

Write-Host "Система полностью очищена." -ForegroundColor Yellow
Pause