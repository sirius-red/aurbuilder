is_installed() {
	command -v "$1" &>/dev/null || pacman -Qi "$1" &>/dev/null
}

missing_dependencie() {
	echo "Install with $(green_bold pacman) $(blue -S) $(magenta "$1")"
}

install_with_makepkg() {
	local options

	options=(
		--needed
		--syncdeps
		--rmdeps
		--install
	)

	[ "$NOCONFIRM" = true ] && options+=("--noconfirm")

	for pkg in "$@"; do
		local workdir="${BUILDDIR}/${pkg}"
		git clone "https://aur.archlinux.org/${pkg}.git" --depth 1 "$workdir"
		cd "$workdir" || continue
		mold -run makepkg "${options[@]}"
		cd /
	done
}

install_with_yay() {
	local options

	options=(
		--needed
		--removemake
		--batchinstall
	)

	[ "$NOCONFIRM" = true ] && {
		options+=(
			--noconfirm
			"--answerclean" "N"
			"--answerdiff" "N"
			"--answeredit" "N"
			"--answerupgrade" "N"
		)
	}

	mold -run yay "${options[@]}" -S "$@"
}

install_packages() {
	local packages install

	packages=("$@")
	install="install_with_yay"

	mkdir -p "$BUILDDIR"
	chown -R "${AB_USER_NAME}:${AB_USER_NAME}" "$BUILDDIR"
	trap 'rm -rf "$BUILDDIR"' EXIT

	if [ "$INSTALLER" = "yay" ]; then
		is_installed yay || {
			INSTALLER="makepkg"
			install="install_with_makepkg"
		}
	else
		INSTALLER="makepkg"
		install="install_with_makepkg"
	fi

	$install "${packages[@]}"
}
