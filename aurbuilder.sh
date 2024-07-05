#!/usr/bin/env bash

#############################################################################
##                                                                         ##
##                               AUR Builder                               ##
##                                                                         ##
##-------------------------------------------------------------------------##
## Author   : Sirius (https://github.com/sirius-red)                       ##
##                                                                         ##
## Project  : https://github.com/sirius-red/aurbuilder                     ##
##                                                                         ##
## Version  : 0.0.1                                                        ##
##                                                                         ##
## License  : GPL-v3                                                       ##
##                                                                         ##
## Reference: https://github.com/sirius-red/aurbuilder/blob/main/LICENSE)  ##
##            https://www.gnu.org/licenses/gpl-3.0.html)                   ##
##                                                                         ##
#############################################################################

# AUR builder settings
VERSION="0.0.1"
USER_NAME="aurbuilder"
USER_HOME="/tmp/${USER_NAME}"
USER_SUDOERS="/etc/sudoers.d/${USER_NAME}"

# Install settings
BIN_NAME="$USER_NAME"
BIN_PATH="/usr/bin/${BIN_NAME}"
CLEAN_INSTALL=false

# Build settings
export MAKEFLAGS="--jobs=$(nproc)"
export BUILDDIR="$USER_HOME/build-$$"
export AURDEST="$BUILDDIR"

# Colors
C_PRIMARY="purple"
C_SECONDARY="cyan"
C_TERTIARY="yellow"

exec_this_as_root() {
	if [ "$UID" -ne 0 ]; then
		exec sudo -E "$0" "$@"
	fi
}

exec_this_as_aurbuilder() {
	if [[ "$SUDO_USER" != "$USER_NAME" ]]; then
		exec sudo -E -u "$USER_NAME" "$0" "$@"
	fi
}

is_integer() {
	[[ "$1" =~ ^[0-9]+$ ]]
}

func_exists() {
	local function_name=$1
	declare -F "$function_name" &>/dev/null
}

color() {
	local color=$1
	shift
	local text=$*

	red() {
		echo -e "\033[1;31m${text}\033[0m"
	}

	green() {
		echo -e "\033[1;32m${text}\033[0m"
	}

	yellow() {
		echo -e "\033[1;33m${text}\033[0m"
	}

	blue() {
		echo -e "\033[1;34m${text}\033[0m"
	}

	purple() {
		echo -e "\033[1;35m${text}\033[0m"
	}

	cyan() {
		echo -e "\033[1;36m${text}\033[0m"
	}

	if func_exists "$color"; then
		"$color"
	elif is_integer "$color"; then
		echo -e "\033[1;${color}m${text}\033[0m"
	else
		text="Invalid color name/code: ${color}"
		red
		echo -e "Usage: $(
			text="color"
			cyan
		) $(
			text="purple something cool"
			yellow
		)"
		echo -e "       $(
			text="color"
			cyan
		) $(
			text="35 something cool"
			yellow
		)"
		exit 1
	fi
}

is_installed() {
	command -v "$1" &>/dev/null || pacman -Qi "$1" &>/dev/null
}

list_packages() {
	local message=$1
	shift 1
	local packages=("$@")

	printf "%s: " "$message"
	for pkg in "$@"; do
		printf "%s" "$(color $C_TERTIARY "$pkg")"
		[[ "$pkg" != "${packages[-1]}" ]] && printf ", "
	done
	echo
}

check_dependencies() {
	local dependencies=("git" "mold" "base-devel")
	local to_install=()

	for dep in "${dependencies[@]}"; do
		is_installed "$dep" || to_install+=("$dep")
	done

	if [ -n "${to_install[*]}" ]; then
		list_packages "Installing missing dependencies" "${to_install[@]}"
		pacman -S --needed --noconfirm --asdeps "${to_install[@]}"
	fi
}

create_user() {
	if ! id $USER_NAME &>/dev/null; then
		local password=$(tr </dev/urandom -dc 'a-zA-Z0-9' | head -c 16)
		local credentials="${USER_NAME}:${password}"

		useradd --system --user-group --no-create-home --home-dir $USER_HOME --shell /usr/bin/nologin $USER_NAME

		chpasswd <<<"$credentials"

		if [ ! -f "$USER_SUDOERS" ]; then
			printf '%s\n%s\n' \
				"${USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" \
				"root ALL=(${USER_NAME}) NOPASSWD: ALL" | tee $USER_SUDOERS >/dev/null
		fi
	fi
}

remove_user() {
	if id $USER_NAME &>/dev/null; then
		userdel $USER_NAME
		rm -rf $USER_HOME
		rm -f $USER_SUDOERS
	fi
}

install_with_makepkg() {
	for pkg in "$@"; do
		git clone "https://aur.archlinux.org/${pkg}.git" --depth 1 "$BUILDDIR/$pkg"
		cd "$BUILDDIR/$pkg" || continue
		mold -run makepkg \
			--needed \
			--noconfirm \
			--syncdeps \
			--rmdeps \
			--install
		sudo -E sh -c "cd - >/dev/null"
	done
}

install_with_yay() {
	mold -run yay \
		--needed \
		--noconfirm \
		--answerclean N \
		--answerdiff N \
		--answeredit N \
		--answerupgrade N \
		--removemake \
		--batchinstall \
		-S "$@"
}

self_install() {
	echo "Checking dependencies..."
	check_dependencies 1>/dev/null
	echo "Creating user $USER_NAME..."
	create_user 1>/dev/null
	echo "Installing ${BIN_NAME} binary..."
	[ -f "$BIN_PATH" ] || cp -f "$0" "$BIN_PATH" 1>/dev/null
	[[ "$CLEAN_INSTALL" == true ]] && rm -rf "$0" 1>/dev/null
	color "green" "Done! ;)"
}

self_uninstall() {
	echo "Uninstalling ${BIN_NAME}..."
	remove_user 1>/dev/null
	rm -rf "$BIN_PATH" 1>/dev/null
	color "purple" "Bye! :("
}

install_packages() {
	local packages=("$@")

	mkdir -p "$BUILDDIR"
	chown -R $USER_NAME:$USER_NAME "$BUILDDIR"
	trap 'rm -rf "$BUILDDIR"' EXIT

	if is_installed yay; then
		list_packages "Installing packages with $(color $C_PRIMARY yay)" "${packages[@]}"
		install_with_yay "${packages[@]}"
		color green "Done!"
	else
		list_packages "Installing packages with $(color $C_PRIMARY makepkg)" "${packages[@]}"
		install_with_makepkg "${packages[@]}"
		color green "Done!"
	fi
}

show_version() {
	color "green" "AUR Builder version $VERSION"
}

show_help() {
	color $C_PRIMARY "AUR Builder v${VERSION}"
	echo
	echo "Usage:"
	echo "    ${BIN_NAME} <operation> [options]"
	echo "    ${BIN_NAME} <package(s)>"
	echo
	echo "Operations:"
	echo "    $(color $C_SECONDARY "-i"), $(color $C_SECONDARY "--self-install")       installs and makes the initial configuration"
	echo "                             of ${BIN_NAME} if it hasn't already been done."
	echo "    $(color $C_SECONDARY "-u"), $(color $C_SECONDARY "--self-uninstall")     Uninstall $BIN_NAME and undo the settings made"
	echo "                             by --self-install operation."
	echo "    $(color $C_SECONDARY "-v"), $(color $C_SECONDARY "--version")            Shows the current version of ${BIN_NAME}."
	echo "    $(color $C_SECONDARY "-h"), $(color $C_SECONDARY "--help")               Shows this help message."
	echo
	echo "Options:"
	echo "    $(color $C_SECONDARY "-c"), $(color $C_SECONDARY "--clean")              Clean the installer files after installation"
	echo "                             (only with --self-install)."
	echo
	echo "Examples:"
	echo "    Install ${BIN_NAME}:"
	echo "        $(color $C_PRIMARY $BIN_NAME) $(color $C_SECONDARY "-i")"
	echo "    Install ${BIN_NAME} and clean installer file:"
	echo "        $(color $C_PRIMARY $BIN_NAME) $(color $C_SECONDARY "-i -c")"
	echo "    Uninstall ${BIN_NAME}:"
	echo "        $(color $C_PRIMARY $BIN_NAME) $(color $C_SECONDARY "-u")"
	echo "    Install specific package(s):"
	echo "        $(color $C_PRIMARY $BIN_NAME) $(color $C_TERTIARY "package1 package2")"
	echo
}

parse_params() {
	case $1 in
	-i | --self-install)
		exec_this_as_root "$@"
		shift 1
		[[ "$*" = *--clean* ]] && CLEAN_INSTALL=true
		self_install
		;;
	-u | --self-uninstall)
		exec_this_as_root "$@"
		self_uninstall
		;;
	-v | --version)
		show_version
		;;
	-h | --help)
		show_help
		;;
	*)
		exec_this_as_aurbuilder "$@"
		install_packages "$@"
		;;
	esac
}

parse_params "$@"
