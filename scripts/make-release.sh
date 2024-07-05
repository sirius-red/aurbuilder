#!/usr/bin/env bash

SOURCE_FILE="src/aurbuilder.sh"
FILE_CONTENT=$(sed <$SOURCE_FILE 's/"//g')
OUT_DIR="./build"
DRY_RUN=false

get_value() {
	echo "$FILE_CONTENT" | grep "${1}=" | cut -d '=' -f2
}

build() {
	local version=$(get_value "VERSION")
	local bin_name=$(get_value "USER_NAME")
	local file_name="${bin_name}-${version}.zip"
	local output_file="${OUT_DIR}/${file_name}"

	echo "Building $bin_name release for version ${version}..."
	echo "Source file: $SOURCE_FILE"
	echo "Output file: $output_file"

	if [[ "$DRY_RUN" == false ]]; then
		mkdir -p "$OUT_DIR"
		zip -9 -q -r "$output_file" "$SOURCE_FILE"
	fi
}

show_help() {
	echo "Usage: $0 [-d | --dry-run]"
	echo
	echo "Options:"
	echo "  -d, --dry-run  Dry run without actually building the release"
	echo "  -h, --help     Show this help message and exit"
	echo
}

while test $# -gt 0; do
	case $1 in
	-d | --dry-run)
		DRY_RUN=true
		;;
	-h | --help)
		show_help
		exit
		;;
	*)
		echo "Invalid flag: $1"
		show_help
		exit 1
		;;
	esac
	shift
done

build
