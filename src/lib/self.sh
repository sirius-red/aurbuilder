create_user() {
	if ! id "$AB_USER_NAME" &>/dev/null; then
		local password=$(tr </dev/urandom -dc 'a-zA-Z0-9' | head -c 16)
		local credentials="${AB_USER_NAME}:${password}"

		sudo useradd --system --user-group --no-create-home --home-dir "$AB_USER_HOME" --shell /usr/bin/nologin "$AB_USER_NAME"

		sudo chpasswd <<<"$credentials"

		if [ ! -f "$AB_USER_SUDOERS" ]; then
			printf '%s\n%s\n' \
				"${AB_USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" \
				"root ALL=(${AB_USER_NAME}) NOPASSWD: ALL" | sudo tee "$AB_USER_SUDOERS" >/dev/null
		fi
	fi
}

remove_user() {
	if id "$AB_USER_NAME" &>/dev/null; then
		sudo userdel "$AB_USER_NAME"
		sudo rm -rf "$AB_USER_HOME"
		sudo rm -f "$AB_USER_SUDOERS"
	fi
}

# TODO: ADD THIS AS A COMMAND IN MAIN SCRIPT
self_uninstall() {
	remove_user 1>/dev/null
	rm -rf "$BIN_PATH" 1>/dev/null
}
