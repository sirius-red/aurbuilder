#!/usr/bin/env bash

parse_permissions() {
	set_environment_vars() {
		export AB_USER_NAME="${AB_USER_NAME:-aurbuilder}"
		export AB_USER_ID
		export CHROOT="${CHROOT:-"/"}"

		AB_USER_ID=$(id -u "$AB_USER_NAME" 2>/dev/null)

		while test $# -gt 0; do
			if [ "$1" = "--chroot" ]; then
				CHROOT="$2"
				break
			fi
			shift
		done
	}

	exec_this_as_root() {
		if [ "$UID" -ne 0 ]; then
			if [ "$CHROOT" = "/" ]; then
				exec sudo "$0" "$@"
			else
				exec sudo arch-chroot "$CHROOT" "$0" "$@"
			fi
		fi
	}

	exec_this_as_aurbuilder() {
		if [[ "$UID" -ne "$AB_USER_ID" ]]; then
			if [ "$CHROOT" = "/" ]; then
				exec sudo -u "$AB_USER_NAME" "$0" "$@"
			else
				exec sudo arch-chroot -u "$AB_USER_NAME" "$CHROOT" "$0" "$@"
			fi
		fi
	}

	set_environment_vars "$@"

	if [[ "$1" =~ ^(s|self)$ ]]; then
		exec_this_as_root "$@"
	elif [[ "$1" =~ ^(i|install)$ ]]; then
		exec_this_as_aurbuilder "$@"
	fi
}

parse_permissions "$@"
