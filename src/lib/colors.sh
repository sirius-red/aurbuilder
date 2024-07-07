color() {
	local style color text

	style=0
	color=37
	separator=" "

	while test $# -gt 0; do
		case $1 in
		-L | --light)
			style=2
			;;
		-B | --bold)
			style=1
			;;
		-U | --underlined)
			style=4
			;;
		-S | --separator)
			separator="$2"
			shift
			;;
		-r | --red)
			color=31
			;;
		-g | --green)
			color=32
			;;
		-y | --yellow)
			color=33
			;;
		-b | --blue)
			color=34
			;;
		-m | --magenta)
			color=35
			;;
		-c | --cyan)
			color=36
			;;
		*)
			text+=("$1")
			;;
		esac
		shift
	done

	if [[ "$color" =~ ^[0-9]+$ ]]; then
		for word in "${text[@]}"; do
			printf "\033[${style};${color}m%s\033[0m" "$word"

			if [[ "$word" != "${text[-1]}" ]]; then
				printf "%s" "$separator"
			else
				printf "\n"
			fi
		done
	else
		color --bold --red "Invalid color code: $color"
	fi
}

red() { color --red "$@"; }
green() { color --green "$@"; }
yellow() { color --yellow "$@"; }
blue() { color --blue "$@"; }
magenta() { color --magenta "$@"; }
cyan() { color --cyan "$@"; }
light() { color --light "$@"; }
bold() { color --bold "$@"; }
underlined() { color --underlined "$@"; }
red_light() { color --red --light "$@"; }
green_light() { color --green --light "$@"; }
yellow_light() { color --yellow --light "$@"; }
blue_light() { color --blue --light "$@"; }
magenta_light() { color --magenta --light "$@"; }
cyan_light() { color --cyan --light "$@"; }
red_bold() { color --red --bold "$@"; }
green_bold() { color --green --bold "$@"; }
yellow_bold() { color --yellow --bold "$@"; }
blue_bold() { color --blue --bold "$@"; }
magenta_bold() { color --magenta --bold "$@"; }
cyan_bold() { color --cyan --bold "$@"; }
red_underlined() { color --red --underlined "$@"; }
green_underlined() { color --green --underlined "$@"; }
yellow_underlined() { color --yellow --underlined "$@"; }
blue_underlined() { color --blue --underlined "$@"; }
magenta_underlined() { color --magenta --underlined "$@"; }
cyan_underlined() { color --cyan --underlined "$@"; }
