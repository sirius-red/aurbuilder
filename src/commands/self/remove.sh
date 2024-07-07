echo "Removing $(cyan_bold "$AB_USER_NAME") user and settings..."

if remove_user; then
	green "Done!"
	exit
else
	exit_code=$?
	red "Error!"
	exit $exit_code
fi
