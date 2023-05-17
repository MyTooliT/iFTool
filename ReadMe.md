# iFTool

Script to run [IFTool](smb://data.ift.tuwien.ac.at/30_IT/01_IFT_Tool) on macOS using CrossOver

This tool basically automates the following tasks

1. Opens a VPN tunnel to TU Vienna, if your computer does not use an internal IP (`128.130.106.…`) address, i.e. your computer is not connected via Ethernet to the (IFT part) of the university network
2. Mount the SMB volume that contains the IFTool
3. Opens the IFTool using CrossOver
4. Cleans up resources:

   - Closes VPN tunnel
   - Unmounts SMB share
   - Closes CrossOver

   after you closed the IFTool

[CrossOver]: https://www.codeweavers.com/crossover

## Requirements

- [CrossOver](https://www.codeweavers.com/crossover)

## Preparation

### CrossOver

1. Open the CrossOver application
2. Go to “CrossOver” → “Settings…” (<kbd>⌘</kbd> + <kbd>,</kbd>)
3. Disable “Launch Installer Assistant when CrossOver opens a .exe file”

   ![CrossOver Preferences](Pictures/CrossOver%20Preferences.webp)

4. Create a new bottle
   1. Select “Bottle” → “New Bottle…”
   2. Choose a name of your liking e.g. “IFTool”
   3. Choose “Windows 10 64-Bit” as Bottle type
5. Optional: Enable “High Resolution Mode” for your Bottle

### Script

- Replace `TU Vienna` with the name of your [TU Vienna VPN configuration](https://www.it.tuwien.ac.at/en/services/network-infrastructure-and-server-services/tunet/vpn-virtual-private-network) or rename your VPN configuration to “TU Vienna”

## Usage

Please use the following command inside the root of this repository

```sh
zsh iftool.sh
```
