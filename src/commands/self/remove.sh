echo
echo "Removing $AB_TITLE user and settings..."

if remove_user; then
	success "AUR Builder user removed successfuly!"
	exit_code=0
else
	error "Error removing AUR Builder user!"
	exit_code=$?
fi

echo
exit $exit_code
