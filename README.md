# Ping-Sweep PowerShell Script

## Overview
The `Ping-Sweep` script is a PowerShell function designed to perform a ping sweep on a range of IP addresses. It checks the reachability of hosts within the specified IP address range and provides information about the alive hosts.
- The script uses background jobs to parallelize the ping sweep for improved efficiency.
- The IP address range for the sweep is assumed to be from ".1" to ".254", allowing customization based on common network configurations.

## Usage
1. **Function Name:** Ping-Sweep
2. **Parameters:**
   - `$Target`: The first three octets of the base IP address for the ping sweep.

## Output
- `IPAdress`: The IP Address of the Host.
- `Latency`: The round-trip for the ping request.
- `Status`: The status of the request.

## How to Run
```powershell
Ping-Sweep -Target "192.168.100"
Ping-Sweep -Target "10.10.48"
