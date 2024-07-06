yesno() {
	while true; do
		read -r -p "$* [$(color -B -g Y)/$(color -B -r n)]: " yn
		case $yn in
		[Yy]*)
			echo
			return 0
			;;
		[Nn]*)
			echo
			return 1
			;;
		esac
	done
}
