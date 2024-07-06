exec_this_as_root() {
	if [ "$UID" -ne 0 ]; then
		exec sudo -E "$0" "$@"
	fi
}

exec_this_as_aurbuilder() {
	if [[ "$SUDO_USER" != "$AB_USER_NAME" ]]; then
		exec sudo -E -u "$AB_USER_NAME" "$0" "$@"
	fi
}
