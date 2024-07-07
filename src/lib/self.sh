create_user() {
	if ! id "$AB_USER_NAME" &>/dev/null; then
		local password credentials

		password=$(tr </dev/urandom -dc 'a-zA-Z0-9' | head -c 16)
		credentials="${AB_USER_NAME}:${password}"

		useradd --system --user-group --no-create-home --home-dir "$AB_USER_HOME" --shell /usr/bin/nologin "$AB_USER_NAME"

		chpasswd <<<"$credentials"

		if [ ! -f "$AB_USER_SUDOERS" ]; then
			printf '%s\n%s\n' \
				"${AB_USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" \
				"root ALL=(${AB_USER_NAME}) NOPASSWD: ALL" | tee "$AB_USER_SUDOERS" >/dev/null
		fi
	fi
}

remove_user() {
	if id "$AB_USER_NAME" &>/dev/null; then
		userdel "$AB_USER_NAME"
		rm -rf "$AB_USER_HOME"
		rm -f "$AB_USER_SUDOERS"
	fi
}

self_uninstall() {
	local path

	path=$(which "$AB_USER_NAME")

	remove_user 1>/dev/null
	rm -rf "$path" 1>/dev/null
}
