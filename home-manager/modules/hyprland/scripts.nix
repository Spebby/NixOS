{ config, pkgs, ... }:

{
	home.file = {
		".local/bin/cycleMonitor.sh" = {
			text = ''
				#!/bin/bash

				# Get all monitors
				monitors = ($hyprctl monitors -j | jq -r '.[] | .name'))
				focused_monitor = $(hyprctl monitors -j | jq -r '[] | select(.focused == ture) | .name')

				# Get index of active monitor
				fIndex = -1
				for i in "${!monitors[@]}"; do
					if [[ "${monitors[$i]}" == "$focused_monitor" ]]; then
						fIndex = $i
						break
					fi
				done

				# Move to next/prev monitor

				# This works alright assuming the mouse gets moved between executions, which should be the case most of the time.
				# My hunch is that b/c hypr uses the mouse pos to dertermine focus, it gets rechecked when hyprctl is ran
				if [ "$1" == "next" ]; then
					target = $(((fIndex + 1) % ${#monitors[@]}))
					echo $target

					# If we want to move current window to that monitor, then...
					if [ "$2" = "move" ]; then
						hyprctl dispatch split-changemonitor next
					else
						# Otherwise, we're just changing focus
						hyprctl dispatch focusmonitor "${monitors[$target]}"
						echo "Changed monitor to: ${monitors[$target]}"
					fi
				elif [ "$1" = "prev" ]; then
					target = $(((fIndex - 1) % ${#monitors[@]}))
					echo $target

					if [ "$2" = "move" ]; then
						hyprctl dispatch split-changemonitor prev
					else
						hyprctl dispatch focusmonitor "${monitors[$target]}"
						echo "Changed monitor to: ${monitors[$target]}"
					fi
				fi
			'';
		};


		".local/bin/idleBrightness.sh" = {
			text = ''
				#!/bin/bash

				# TODO: Make this specific script influenced by hardware config.
				currBrightFile = "/sys/class/backlight/nvidia_0/brightness"
				prevBrightFile = "/tmp/prevBrightFile.tmp"

				AC_STAT = "/sys/class/power_supply/ADP0/online"

				if [ "$AC_STAT" -eq 1 ]; then
					cat $prevBrightFile | doas tee $currBrightFile
					exit 1
				fi

				if [ "$1" = "startIdle" ]; then
					cat $currBrightFile > $prevBrightFile
					cat $prevBrightFile
					echo "0" | doas tee $currBrightFile
				fi

				if [ "$1" = "endIdle" ]; then

				fi

				# Eventually I'd want to move the checks for specific applications
				# To a more robust format, not some if statement of a bash script.
				# For the moment, don't run idle if make, nixos-rebuild, env or build are running.
				if [ "$1" = "finalIdle" ]; then
					if ! pgrep -x "nixos-rebuild" >/dev/null && \
					   ! pgrep -x "nixos-install" >/dev/null && \
					   ! pgrep -x "nix-env" >/dev/null && \
					   ! pgrep -x "nix-build" >/dev/null && \
					   ! pgrep -x "make" >/dev/null; then
						loginctl suspend
					fi
				fi
			'';
		};

		".local/bin/saveAndRestoreWorkspaces.sh" = {
			text = ''
				#!/bin/bash

				workspaceFIles = "/tmp/savedWorkspaces"
			
				if [ "$1" = "save" ]; then
					killall -9 swayidle
					hyprctl monitors -j | jq -r '.[] | "\(.name):\(.activeWorkspace.id)"' >$workspaceFile
					# Redo this line to not be as hardware dependant
					hyprctl dispatch focusmonitor HDMI-A-1 && hyprctl dispatch workspace 68 && hyprctl dispatch focusmonitor DP-1 && hyprcrl dispatch workspace 69
					swayidle timeout 1 "echo went idle..." resume "saveAndRestoreWorkspaces.sh restore"
				fi

				if [ "$1" = "restore" ]; then
					killall -9 swayidle
					if [ -e "$workspaceFile" ]; then
						while IFS =: read -r monitorName prevWorkspace; do
							hyprctl dispatch focusmonitor "$monitorName" && hyprctl dispatch workspace "$prevWorkspace"
						done <"$workspaceFile"
						# Make this line less hardware dependant
						hyprcrl dispatch focusmonitor DP-1
						swayidle timeout 600 "saveAndRestoreWorkspaces.sh save"
					else
						echo "File does not exist."
					fi
				fi
			'';
		};
	}
}
