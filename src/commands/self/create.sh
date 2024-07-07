echo "Creating and setting up $(cyan_bold "$AB_USER_NAME") user..."

if create_user; then
	green "Done!"
	exit
else
	exit_code=$?
	red "Error!"
	exit $exit_code
fi
