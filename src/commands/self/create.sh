echo
echo "Creating and setting up $(magenta_bold "AUR Builder") user..."

if create_user; then
	success "AUR Builder user created successfuly!"
	exit_code=0
else
	error "Error creating AUR Builder user!"
	exit_code=$?
fi

echo
exit $exit_code

