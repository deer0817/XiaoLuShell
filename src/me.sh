#!/bin/bash
## Author: deer0817
## Modified: 2025-05-11
## Github: https://github.com/deer0817
## Description: Customizable about me

AUTHOR="deer0817"
AUTHOR_GITHUB="https://github.com/deer0817"
DESCRIPTION="About me"
MODIFIED_DATE="2025-05-12"

RED='\033[31m'
GREEN='\033[32m'
ORANGE='\033[38;5;208m'
CYAN='\033[38;5;36m'
SKYBLUE='\033[38;5;75m'
YELLOW='\033[33m'
BLUE='\033[34m'
PURPLE='\033[35m'
AZURE='\033[36m'
PLAIN='\033[0m'
BOLD='\033[1m'
PINK='\033[1;35m'
SUCCESS="\033[1;32m✔${PLAIN}"
COMPLETE="\033[1;32m✔${PLAIN}"
WARN="\033[1;43m 警告 ${PLAIN}"
ERROR="\033[1;31m✘${PLAIN}"
FAIL="\033[1;31m✘${PLAIN}"
TIP="\033[1;44m 提示 ${PLAIN}"
WORKING="\033[1;36m◉${PLAIN}"
DOT="◉"

level_print() {
  local color=$1
  case $color in
    red) color=$RED ;;
    green) color=$GREEN ;;
    orange) color=$ORANGE ;;
    cyan) color=$CYAN ;;
    skyblue) color=$SKYBLUE ;;
    yellow) color=$YELLOW ;;
    blue) color=$BLUE ;;
    purple) color=$PURPLE ;;
    azure) color=$AZURE ;;
    plain) color=$PLAIN ;;
    bold) color=$BOLD ;;
    pink) color=$PINK ;;
    success) color=$SUCCESS ;;
    complete) color=$COMPLETE ;;
    warn) color=$WARN ;;
    error) color=$ERROR ;;
    fail) color=$FAIL ;;
    tip) color=$TIP ;;
    working) color=$WORKING ;;
    dot) color=$DOT ;;
    *) color=$PLAIN ;;
  esac
  local message=$2
  echo -e "${color}${message}${PLAIN}"
}

get_param() {
  local param=$1
  local default_value=$2
  local input="${@:3}"
  echo "$input" | awk -v param="$param" -v default="$default_value" '
  {
    for (i = 1; i <= NF; i++) {
      if ($i == param) {
        print $(i + 1)
        exit
      }
    }
    print default
  }'
}

ASCII_API_CDN="https://static.zloved.me/shell/draw_char.sh"
ASCII_COLOR=$(get_param "--ascii-color" "skyblue" "$@")
ASCII_STR=$(get_param "--ascii-str" "XIAOLU" "$@")
ASCII_FONT=$(get_param "--ascii-font" "miniwi" "$@")
AUTHOR_NAME=$(get_param "--name" "$AUTHOR" "$@")
AUTHOR_GITHUB=$(get_param "--github" "$AUTHOR_GITHUB" "$@")
DESCRIPTION=$(get_param "--desc" "$DESCRIPTION" "$@")
MODIFIED_DATE=$(get_param "--date" "$MODIFIED_DATE" "$@")

# Print the information
print_me() {
  local name=$1
  local author_github=$2
  local description=$3
  local modified_date=$4
  level_print "success" " Name : $name"
  level_print "success" " Github : $author_github"
  level_print "success" " Description : $description"
  level_print "success" " Date : $modified_date"
}

print_ascii() {
  local char_to_print=$1
  local ascii_font=$ASCII_FONT
  ascii_str=$(bash <(curl -sSL "$ASCII_API_CDN") --str "$char_to_print" --font "$ascii_font" --color "$ASCII_COLOR")
  # Use level_print to print each line of the ASCII art
  while IFS= read -r line; do
    echo -e "${line}"
  done <<< "$ascii_str"
  echo -e "${PLAIN}"
}

do_print_me() {
  # if --help is included, print help message
  if [[ "$@" == *"--help"* ]]; then
    level_print "success" " Author : $AUTHOR"
    level_print "success" " Github : $AUTHOR_GITHUB"
    level_print "success" " Description : $DESCRIPTION"
    level_print "working" " Modified Date : $MODIFIED_DATE"
    level_print "plain" ""
    level_print "plain" "Usage: me.sh [OPTIONS]"
    level_print "plain" "Options:"
    level_print "plain" "  --name <name>           Specify the name (default: $AUTHOR)"
    level_print "plain" "  --github <github>       Specify the GitHub link (default: $AUTHOR_GITHUB)"
    level_print "plain" "  --desc <description>    Specify the description (default: $DESCRIPTION)"
    level_print "plain" "  --date <date>           Specify the modified date (default: $MODIFIED_DATE)"
    level_print "plain" "  --ascii-color <color>   Specify the ASCII color (default: $ASCII_COLOR)"
    level_print "plain" "  --ascii-str <string>    Specify the ASCII string (default: $ASCII_STR)"
    level_print "plain" "  --ascii-font <font>     Specify the ASCII font (default: $ASCII_FONT)"
    level_print "plain" "  --list-font             List available fonts"
    level_print "plain" "  --list-color            List available ascii colors"
    level_print "plain" "  --help                  Show this help message"
    level_print "plain" "  --version               Show version information"
    exit 0
  elif [[ "$*" == *"--version"* ]]; then
    level_print "success" " Description : $DESCRIPTION"
    level_print "success" " Version : 1.0.0"
    level_print "success" " Author : $AUTHOR"
    level_print "success" " Github : $AUTHOR_GITHUB"
    level_print "working" " Modified Date : $MODIFIED_DATE"
    level_print "plain" ""
    exit 0
  elif [[ "$*" == *"--list-font"* ]]; then
    bash <(curl -sSL "$ASCII_API_CDN") --list-font
    exit 0
  elif [[ "$*" == *"--list-color"* ]]; then
    bash <(curl -sSL "$ASCII_API_CDN") --list-color
    exit 0
  else
    print_me "$AUTHOR_NAME" "$AUTHOR_GITHUB" "$DESCRIPTION" "$MODIFIED_DATE"
    print_ascii "$ASCII_STR"
  fi
}
do_print_me "$@"