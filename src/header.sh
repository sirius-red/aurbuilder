#!/usr/bin/env bash


INSTALLER_URL="{{INSTALLER_URL}}"
TAG="{{TAG}}"

INSTALLER_COMMAND=$(cat <<EOF
if ! command -v aurbuilder &>/dev/null; then
	curl -L "${INSTALLER_URL}" | sh -s -- -t "${TAG}"
fi
EOF
)

parse_permissions() {
	set_environment_vars() {
		export AB_USER_NAME AB_USER_ID CHROOT
		local new_args=()

		AB_USER_NAME="${AB_USER_NAME:-aurbuilder}"
		AB_USER_ID=$(id -u "$AB_USER_NAME" 2>/dev/null)
		CHROOT="${CHROOT:-"/"}"

		while test $# -gt 0; do
			if [ "$1" = "--chroot" ]; then
				CHROOT="$2"
				shift
			else
				new_args+=("$1")
			fi
			shift
		done

		set -- "${new_args[@]}"
	}

	install_aurbuilder_on_chroot() {
		sudo arch-chroot "$CHROOT" /usr/bin/bash -c "$INSTALLER_COMMAND"
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
		if [ "$CHROOT" = "/" ]; then
			if [[ "$UID" -ne "$AB_USER_ID" ]]; then
				exec sudo -u "$AB_USER_NAME" "$0" "$@"
			fi
		else
			arch_chroot as_aurbuilder "$0" "$@"
		fi
	}

	set_environment_vars "$@"

	while test $# -gt 0; do
		if [[ "$1" =~ ^(s|self)$ ]]; then
			exec_as_root "$@"
			break
		elif [[ "$1" =~ ^(i|install)$ ]]; then
			exec_as_aurbuilder "$@"
			break
		fi
		shift
	done
}

parse_permissions "$@"
