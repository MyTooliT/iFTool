#!/bin/zsh

# -- Function ------------------------------------------------------------------

print_info() {
	printf "⚙️  $@"
}

init() {
	vpn="$1"
	tu_vienna_ip="$2"
	smb_path="$3"

	print_info "Determine external IP\n"
	external_ip="$(curl 2> /dev/null ifconfig.me)"
	print_info "External IP: %s\n" "$external_ip"
	if [ "$external_ip" != "$tu_vienna_ip" ]; then
		print_info 'Connect to VPN “%s”\n' "$vpn"
		networksetup -connectpppoeservice "$vpn"
	fi
	print_info "Mount SMB volume\n"
	osascript -e "mount volume \"$smb_path\"" > /dev/null
}

iftool() {
	iftool_path="$1"

	print_info "Open IFTool\n"
	open -a CrossOver "$iftool_path"

	# Wait until IFTool is ready
	while ! pgrep -lq wine64-preloader; do
		sleep 1
	done

	# Wait until IFTool is closed
	print_info "Wait until IFTool is closed…\n"
	while pgrep -lq wine64-preloader; do
		sleep 1
	done
}

cleanup() {
	vpn="$1"
	iftool_mountpoint="$2"

	diskutil unmount "$iftool_mountpoint" > /dev/null
	networksetup -disconnectpppoeservice "$vpn"
}

main() {
	tu_vienna_ip=128.130.106.43 # Static IP inside TU network
	vpn='TU Vienna'

	iftool_directory_prefix='30_IT'
	iftool_directory='01_IFT_Tool'
	smb_path="smb://data.ift.tuwien.ac.at/$iftool_directory_prefix"
	iftool_mountpoint="/Volumes/$iftool_directory_prefix"
	iftool_path="$iftool_mountpoint/$iftool_directory/IFT_Tool.exe"

	init "$vpn" "$tu_vienna_ip" "$smb_path"
	iftool "$iftool_path"
	cleanup "$vpn" "$iftool_mountpoint"
}

# -- Main ----------------------------------------------------------------------

main
