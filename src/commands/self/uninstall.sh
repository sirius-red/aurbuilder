echo "Uninstalling $(cyan_bold "$AB_USER_NAME") and all settings permanently..."
if self_uninstall; then
	green "Done!"
	magenta_bold "Bye! :("
	exit
else
	exit_code=$?
	red "Error!"
	exit $exit_code
fi
