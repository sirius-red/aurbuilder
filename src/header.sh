#!/usr/bin/env bash


parse_permissions() {
	set_environment_vars() {
		export TAG AB_USER_NAME AB_USER_ID CHROOT

		TAG="{{TAG}}"
		AB_USER_NAME="${AB_USER_NAME:-aurbuilder}"
		AB_USER_ID=$(id -u "$AB_USER_NAME" 2>/dev/null)
		CHROOT="${CHROOT:-"/"}"

		while test $# -gt 0; do
			if [ "$1" = "--chroot" ]; then
				CHROOT="$2"
				break
			fi
			shift
		done
	}

	install_aurbuilder_on_chroot() {
		sudo arch-chroot "$CHROOT" /usr/bin/bash -c "command -v aurbuilder &>/dev/null || curl -L https://sirius-red.github.io/aurbuilder/install | sh -s -- -t ${TAG}"
	}

	arch_chroot() {
		local command

		if [ "$1" = "as_aurbuilder" ]; then
			shift 1
			command="$(printf "%q " "$@")"
			install_aurbuilder_on_chroot
			exec sudo arch-chroot -u "$AB_USER_NAME" "$CHROOT" /usr/bin/bash -c "$command"
		else
			command="$(printf "%q " "$@")"
			exec sudo arch-chroot "$CHROOT" /usr/bin/bash -c "$command"
		fi
	}

	exec_as_root() {
		if [ "$UID" -ne 0 ]; then
			exec sudo "$0" "$@"
		fi
		if [ "$CHROOT" != "/" ]; then
			arch_chroot "$0" "$@"
		fi
	}

	exec_as_aurbuilder() {
		if [[ "$UID" -ne "$AB_USER_ID" ]]; then
			if [ "$CHROOT" = "/" ]; then
				exec sudo -u "$AB_USER_NAME" "$0" "$@"
			else
				arch_chroot as_aurbuilder "$0" "$@"
			fi
		fi
	}

	set_environment_vars "$@"

	if [[ "$1" =~ ^(s|self)$ ]]; then
		exec_as_root "$@"
	elif [[ "$1" =~ ^(i|install)$ ]]; then
		exec_as_aurbuilder "$@"
	fi
}

parse_permissions "$@"
