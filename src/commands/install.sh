[ -n "${args['--build-dir']}" ] && export BUILDDIR="${args['--build-dir']}"
[ -n "${args[--installer]}" ] && export INSTALLER="${args[--installer]}"
[ -n "${args[--makeflags]}" ] && export MAKEFLAGS="${args[--makeflags]}"
[ -n "${args[--chroot]}" ] && export CHROOT="${args[--chroot]}"
[ "${args[--noconfirm]}" = 1 ] && export NOCONFIRM=true

# used to convert the space separated packages to an array
eval "PACKAGES=(${args[package]:-})"

install_packages "${PACKAGES[@]}"
