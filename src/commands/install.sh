[ -n "${args['--build-dir']}" ] && export BUILDDIR="${args['--build-dir']}"
[ -n "${args[--installer]}" ] && export INSTALLER="${args[--installer]}"
[ -n "${args[--makeflags]}" ] && export MAKEFLAGS="${args[--makeflags]}"
[ -n "${args[--chroot]}" ] && export CHROOT="${args[--chroot]}"
[ "${args[--noconfirm]}" = 1 ] && export NOCONFIRM=true

# used to convert the space separated packages to an array
eval "PACKAGES=(${args[package]:-})"

echo
echo "$AB_TITLE installer"
echo
echo "$(cyan_bold INSTALLER)=$(yellow_bold "$INSTALLER")"
echo "$(cyan_bold MAKEFLAGS)=$(yellow_bold "$MAKEFLAGS")"
echo "$(cyan_bold BUILDDIR)=$(yellow_bold "$BUILDDIR")"
echo "$(cyan_bold PACKAGES)=$(yellow_bold -S ", " "${PACKAGES[@]}")"
echo

if install_packages "${PACKAGES[@]}"; then
    success "Packages installed successfully!"
	exit_code=0
else
	error "Error installing packages!"
    exit_code=$?
fi

echo
exit $exit_code
