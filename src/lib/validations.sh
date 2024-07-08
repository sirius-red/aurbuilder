## [@bashly-upgrade validations]
validate_dir_exists() {
	[[ -d "$1" ]] || echo "must be an existing directory"
}

## [@bashly-upgrade validations]
validate_file_exists() {
	[[ -f "$1" ]] || echo "must be an existing file"
}

## [@bashly-upgrade validations]
validate_integer() {
	[[ "$1" =~ ^[0-9]+$ ]] || echo "must be an integer"
}

## [@bashly-upgrade validations]
validate_not_empty() {
	[[ -z "$1" ]] && echo "must not be empty"
}

validate_package_exists() {
    local url
	
    url="https://aur.archlinux.org/packages/${1}"
	
    if ! curl -fs -o /dev/null "$url"; then
		error "The package $(magenta_bold ${1}) does not exist."
	fi
}
