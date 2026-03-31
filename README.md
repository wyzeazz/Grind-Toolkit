[![Download on itch.io](https://img.shields.io/badge/itch.io-download-orange)](https://wyzeazz.itch.io/grind-toolkit)

# The Grind Toolkit https://wyzeazz.itch.io/

**12 Years in the Making – A PowerShell Toolkit for People Who Actually Use Their Computers**

I've been building this toolkit for over a decade—through network admin jobs, late‑night troubleshooting, and the chaos of raising a family. Every function, every alias, every batch file with its hand‑drawn ASCII art was made to save time, reduce frustration, and make the terminal feel like home.

## What's Inside

- **PowerShell Profile** – custom prompt, persistent history, 20% evil pro‑tip engine
- **Network Tools** – IP config, DNS flush, continuous ping, traceroute, public IP lookup, Wi‑Fi profile manager, ARP table, routing table, and more
- **Network Control** – set static IP, revert to DHCP, disable/enable/restart network adapter
- **System Tools** – disk usage, drive info, GPU stats, CPU temp, uptime, top processes, process killer, folder size
- **Gaming Tools** – Steam Big Picture launcher, restart Explorer (fixes UI glitches)
- **iperf3 Suite** – server and client batch files with full‑screen ASCII art, bandwidth limiting, reverse tests, timestamped logs, and jitter/loss summary (UDP)
- **Curated History** – 100+ starter commands pre‑loaded in your history file (just press Up Arrow)

## Installation

1. Download the Grind Toolkit zip file
2. Extract to a folder
3. Double‑click installps.bat
4. Restart PowerShell

The installer copies the profile to your PowerShell folder, installs the iperf tools, sets your execution policy, and adds the example history file.

## Usage

After installation, open PowerShell. You'll see:

- A green prompt (`user@computer path>`)
- A random tip (80% helpful, 20% evil)
- A toolbox listing all available commands

Type `reload` to reload the profile after making changes.

## Examples

```powershell
# Network diagnostics
ipconfig-all
ping-t google.com
traceroute microsoft.com
myip
wifi-profiles
wifi-password "MyWiFi"

# IP configuration
set-ip 192.168.1.100 -gateway 192.168.1.1
set-dhcp

# Network adapter control
net-off
net-on
net-restart

# System info
USED
DRIVES
gpu
temp
uptime
topcpu
topmem

# iperf3 (ASCII art batch files)
iperfs          # start server (shows your IPs)
iperfct         # TCP client test
iperfcu         # UDP client test with jitter/loss

# History
history
findhistory update

## Third‑Party Components

This toolkit includes `iperf3.exe`, which is developed by ESnet / Lawrence Berkeley 
National Laboratory and is distributed under the three‑clause BSD license. A copy of 
the license is included in the `tools/iperf3/` folder.
