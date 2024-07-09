echo
echo "Uninstalling $(magenta_bold "AUR Builder") and all settings permanently..."

if self_uninstall; then
	success "AUR Builder uninstalled successfuly!"
	magenta_bold "Bye! :("
	exit_code=0
else
	error "Error uninstalling AUR Builder!"
	exit_code=$?
fi

echo
exit $exit_code