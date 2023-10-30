#!/bin/zsh

# -- Functions -----------------------------------------------------------------

print_info() {
	printf "⚙️  $@"
}

exit_error() {
	printf >&2 "😱 \033[31;1;4m$@\033[0m"
	exit 1
}

init() {
	vpn="$1"
	smb_path="$2"
	internal_ip_regex="^128\.130\.106"

	print_info "Determine external IP\n"
	external_ips="$(ifconfig -l | xargs -n1 ipconfig getifaddr)"
	print_info "External IPs:\n%s\n" "$external_ips"
	if ! printf '%s' "$external_ips" | grep -Eq "$internal_ip_regex"; then
		print_info 'Connect to VPN “%s”\n' "$vpn"
		networksetup -connectpppoeservice "$vpn"
		timeout=10
		time_left="$timeout"
		while ! scutil --nc list | grep "$vpn" | grep -q Connected; do
			if [ "$time_left" -lt 1 ]; then
				exit_error "Unable to connect to VPN “$vpn” in $timeout seconds"
			fi
			sleep 1
			time_left=$((time_left - 1))
		done
	fi
	print_info "Mount SMB volume\n"
	message="$(osascript -e "mount volume \"$smb_path\"" 2>&1 > /dev/null)"
	if [ "$?" -ne 0 ]; then
		error_message="Unable to mount SMB volume: $message\n"
		exit_error "$error_message"
	fi

}

iftool() {
	iftool_path="$1"

	print_info "Open IFTool\n"
	open -jga CrossOver "$iftool_path"

	# Wait until IFTool is ready
	while ! pgrep -lq IFT_Tool.exe; do
		sleep 1
	done

	# Wait until IFTool is closed
	print_info "Wait until IFTool is closed…\n"
	while pgrep -lq IFT_Tool.exe; do
		sleep 1
	done
}

cleanup() {
	vpn="$1"
	iftool_mountpoint="$2"

	diskutil unmount "$iftool_mountpoint" > /dev/null
	networksetup -disconnectpppoeservice "$vpn"

	killall CrossOver
}

main() {
	vpn='TU Vienna'

	iftool_directory_prefix='30_IT'
	iftool_directory='01_IFT_Tool'
	smb_path="smb://data.ift.tuwien.ac.at/$iftool_directory_prefix"
	iftool_mountpoint="/Volumes/$iftool_directory_prefix"
	iftool_path="$iftool_mountpoint/$iftool_directory/IFT_Tool.exe"

	init "$vpn" "$smb_path"
	iftool "$iftool_path"
	cleanup "$vpn" "$iftool_mountpoint"
}

# -- Main ----------------------------------------------------------------------

main
