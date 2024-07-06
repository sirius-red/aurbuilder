#!/usr/bin/env bash

exec_this_as_aurbuilder() {
	export AB_USER_NAME="${AB_USER_NAME:-aurbuilder}"

	if [[ "$SUDO_USER" != "$AB_USER_NAME" ]]; then
		exec sudo -u "$AB_USER_NAME" "$0" "$@"
	fi
}

if [[ "$1" =~ ^(i|install)$ ]]; then
	exec_this_as_aurbuilder "$@"
fi
