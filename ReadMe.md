# iFTool

Script to run IFTool on macOS using CrossOver

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

1. Replace `128.130.106.43` in [`iftool.sh`](iftool.sh) with your static IP address
2. Replace `TU Vienna` with the name of your [TU Vienna VPN configuration](https://www.it.tuwien.ac.at/en/services/network-infrastructure-and-server-services/tunet/vpn-virtual-private-network)

## Usage

Please use the following command inside the root of this repository

```sh
zsh iftool.sh
```
