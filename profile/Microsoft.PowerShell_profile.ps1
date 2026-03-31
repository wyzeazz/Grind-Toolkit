# ==================================================
# THE GRIND TOOLKIT – 12 Years of PowerShell
# ==================================================

# --- Colors & Look ---
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Green"

# ========== PERSISTENT HISTORY ==========
$historyFolder = "$env:USERPROFILE\Documents\PowerShell"
if (-not (Test-Path $historyFolder)) {
    New-Item -ItemType Directory -Path $historyFolder -Force | Out-Null
}
$HistoryFile = "$historyFolder\.ps_history"
$HistoryCount = 1000

# Load history at startup
if (Test-Path $HistoryFile) {
    Import-Clixml $HistoryFile | Add-History
}

# Save history after every command
function prompt {
    Get-History -Count $HistoryCount | Export-Clixml $HistoryFile -Force
    Write-Host "$env:USERNAME@$env:COMPUTERNAME $(Get-Location)> " -NoNewline -ForegroundColor Green
    return " "
}

# ==================================================
# ALIASES (Simple commands)
# ==================================================
Set-Alias update 'winget upgrade --all'
Set-Alias please 'Start-Process -Verb RunAs (Get-History)[-1].CommandLine'
Set-Alias cd.. 'Set-Location ..'
Set-Alias open 'Start-Process'

function reload {
    . $PROFILE
}

# ==================================================
# NETWORK TOOLS
# ==================================================
function ipconfig-all {
    ipconfig /all
}
function flushdns {
    ipconfig /flushdns
}
function ping-t {
    param($target)
    & C:\Windows\System32\ping.exe $target -t
}
function traceroute {
    tracert $args[0]
}
function netstat-an {
    netstat -an
}
function myip {
    (Invoke-WebRequest -Uri "https://ifconfig.me/ip" -UseBasicParsing).Content.Trim()
}
function wifi-profiles {
    netsh wlan show profiles
}
function wifi-password {
    param($ssid)
    netsh wlan show profile name="$ssid" key=clear | Select-String "Key Content"
}
function route-print {
    & C:\Windows\System32\route.exe print
}
function arp-table {
    & C:\Windows\System32\arp.exe -a
}
function netstat-active {
    netstat -an | findstr ESTABLISHED
}
function set-ip {
    param(
        [string]$ip,
        [string]$mask = "255.255.255.0",
        [string]$gateway,
        [string]$adapter = "Ethernet"
    )
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"& { . `$PROFILE; set-ip -ip '$ip' -mask '$mask' -gateway '$gateway' -adapter '$adapter' }`"" -Verb RunAs
        return
    }
    netsh interface ip set address "$adapter" dhcp
    $result = netsh interface ip set address "$adapter" static $ip $mask $gateway 1 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "IP set to $ip / $mask (gateway: $gateway)" -ForegroundColor Green
    } else {
        Write-Host "Failed to set IP: $result" -ForegroundColor Red
    }
}
function set-dhcp {
    param([string]$adapter = "Ethernet")
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"& { . `$PROFILE; set-dhcp -adapter '$adapter' }`"" -Verb RunAs
        return
    }
    netsh interface ip set address "$adapter" dhcp
    Write-Host "Adapter '$adapter' set to DHCP" -ForegroundColor Green
}
function net-off {
    param([string]$adapter = "Ethernet")
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"& { . `$PROFILE; net-off -adapter '$adapter' }`"" -Verb RunAs
        return
    }
    netsh interface set interface "$adapter" disable
    Write-Host "Adapter '$adapter' disabled." -ForegroundColor Yellow
}
function net-on {
    param([string]$adapter = "Ethernet")
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"& { . `$PROFILE; net-on -adapter '$adapter' }`"" -Verb RunAs
        return
    }
    netsh interface set interface "$adapter" enable
    Write-Host "Adapter '$adapter' enabled." -ForegroundColor Green
}
function net-restart {
    param([string]$adapter = "Ethernet")
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"& { . `$PROFILE; net-restart -adapter '$adapter' }`"" -Verb RunAs
        return
    }
    Write-Host "Restarting adapter '$adapter'..." -ForegroundColor Yellow
    netsh interface set interface "$adapter" disable
    Start-Sleep -Seconds 3
    netsh interface set interface "$adapter" enable
    Write-Host "Adapter '$adapter' restarted." -ForegroundColor Green
}
function findhistory {
    param([string]$search)
    if ($search) {
        Get-History | Where-Object {$_.CommandLine -like "*$search*"} | Select-Object -Last 10 | Format-Table -AutoSize
    } else {
        Get-History | Select-Object -Last 20 | Format-Table -AutoSize
    }
}
function history {
    param([int]$count = 20)
    Get-History | Select-Object -Last $count | Format-Table -AutoSize
}

# ==================================================
# SYSTEM & GAMING TOOLS
# ==================================================
function temp {
    (Get-CimInstance Win32_Processor).LoadPercentage
}
function USED {
    Get-ChildItem -Directory | ForEach-Object {
        $_ | Select-Object Name, @{
            Name="SizeGB"
            Expression={
                [math]::Round((Get-ChildItem $_.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1GB, 2)
            }
        }
    } | Sort-Object SizeGB -Descending | Select-Object -First 10 | Format-Table
}
function DRIVES {
    Get-PhysicalDisk | Select-Object DeviceID, MediaType, Size, Model
}
function gpu {
    nvidia-smi
}
function uptime {
    (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
}
function topcpu {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 | Format-Table Name, CPU, WorkingSet -AutoSize
}
function topmem {
    Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 | Format-Table Name, CPU, WorkingSet -AutoSize
}
function killit {
    param($name)
    Stop-Process -Name $name -Force
}
function folder-size {
    Get-ChildItem -Recurse -File | Measure-Object -Property Length -Sum | Select-Object @{Name="SizeGB";Expression={[math]::Round($_.Sum / 1GB, 2)}}
}
function bigpicture {
    start steam://open/bigpicture
}
function restart-explorer {
    Stop-Process -Name explorer -Force
    Start-Process explorer
}

# ==================================================
# IPERF TOOLS (with 12-year-old batch files)
# ==================================================
$iperfPath = "C:\Grind-Toolkit\tools\iperf3\iperf3.exe"

function iperfs {
    if (-NOT (Test-Path $iperfPath)) {
        Write-Host "iperf3 not found at $iperfPath" -ForegroundColor Red
        Write-Host "Make sure the Grind Toolkit is installed correctly." -ForegroundColor Yellow
        return
    }
    & "C:\Grind-Toolkit\tools\iperf3\IPERF Server.bat"
}

function iperfct {
    if (-NOT (Test-Path $iperfPath)) {
        Write-Host "iperf3 not found at $iperfPath" -ForegroundColor Red
        return
    }
    & "C:\Grind-Toolkit\tools\iperf3\IPERF Client TCP.bat"
}

function iperfcu {
    if (-NOT (Test-Path $iperfPath)) {
        Write-Host "iperf3 not found at $iperfPath" -ForegroundColor Red
        return
    }
    & "C:\Grind-Toolkit\tools\iperf3\IPERF Client UDP.bat"
}

# ==================================================
# PRO-TIP ENGINE (20% evil)
# ==================================================

$niceTips = @(
    "ipconfig-all - shows full network config.",
    "flushdns - clears DNS cache.",
    "ping-t google.com - continuous ping.",
    "traceroute google.com - trace route.",
    "netstat-an - shows active connections.",
    "myip - shows your public IP.",
    "wifi-profiles - lists saved Wi-Fi networks.",
    "wifi-password SSID - shows Wi-Fi password.",
    "route-print - shows routing table.",
    "arp-table - shows ARP table.",
    "update - upgrades all winget packages.",
    "temp - shows CPU load.",
    "USED - shows largest folders.",
    "DRIVES - lists physical disks.",
    "gpu - shows NVIDIA GPU info.",
    "topcpu - top 10 processes by CPU.",
    "topmem - top 10 processes by memory.",
    "killit notepad - kills a process by name.",
    "restart-explorer - fixes taskbar issues.",
    "folder-size - shows size of current folder.",
    "bigpicture - launches Steam Big Picture Mode.",
    "set-ip <IP> -gateway <GW> - sets static IP.",
    "set-dhcp - returns to DHCP.",
    "net-off / net-on / net-restart - network adapter control.",
    "findhistory <keyword> - search command history.",
    "history - shows recent commands."
)

$evilTips = @(
    "You are cursed.",
    "The CPU is a lie.",
    "Very Nice, Very Evil.",
    "Only your Monies can save you now.",
    "Spite level: over 9000.",
    "Even your wallpaper judges you now.",
    "Your RAM belongs to me now.",
    "I am watching you type, $env:USERNAME. Don't mess up.",
    "Type please to run last command as admin. I dare you.",
    "Your packets belong to me now.",
    "The DNS is watching you, $env:USERNAME.",
    "Your ping will be answered... eventually.",
    "One packet will be lost. Just one.",
    "Someone else is on this network.",
    "The firewall is not your friend."
)

$isEvil = (Get-Random -Maximum 5) -eq 0
$tipList = if ($isEvil) { $evilTips } else { $niceTips }
$tip = $tipList | Get-Random
Write-Host "`n$tip`n" -ForegroundColor $(if ($isEvil) { 'Red' } else { 'Green' })

# ==================================================
# TOOLBOX DISPLAY
# ==================================================

Write-Host ""
Write-Host ">>> THE GRIND TOOLKIT <<<" -ForegroundColor Cyan
Write-Host ""
Write-Host "  DIAGNOSTICS: ipconfig-all, flushdns, ping-t, traceroute, netstat-an, myip" -ForegroundColor Green
Write-Host "  WIFI: wifi-profiles, wifi-password" -ForegroundColor Green
Write-Host "  ROUTING: route-print, arp-table" -ForegroundColor Green
Write-Host "  NETWORK CONTROL: set-ip, set-dhcp, net-off, net-on, net-restart" -ForegroundColor Green
Write-Host "  SYSTEM: update, temp, USED, DRIVES, gpu, uptime, folder-size" -ForegroundColor Green
Write-Host "  PROCESSES: topcpu, topmem, killit, restart-explorer" -ForegroundColor Green
Write-Host "  GAMING: bigpicture, please" -ForegroundColor Green
Write-Host "  HISTORY: history, findhistory <keyword>" -ForegroundColor Green
Write-Host "  IPERF: iperfs (server), iperfct (client TCP), iperfcu (client UDP)" -ForegroundColor Green
Write-Host "  UTILITIES: reload, open, cls" -ForegroundColor Green
Write-Host ""
Write-Host "  Type any command to run it." -ForegroundColor DarkGray
Write-Host ""