#!/bin/bash
## Author: deer0817
## Modified: 2025-05-12
## Github: https://github.com/deer0817
## Description: Customizable ASCII art

AUTHOR="deer0817"
AUTHOR_GITHUB="https://github.com/deer0817"
DESCRIPTION="Draw characters using ASCII art fonts"
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
AVALIABLE_COLORS=(
  "red"
  "green"
  "orange"
  "cyan"
  "skyblue"
  "yellow"
  "blue"
  "purple"
  "azure"
  "plain"
  "bold"
  "pink"
)
AVAILABLE_FONTS=(
  "ANSI_Regular"
  "ANSI_Shadow"
  "Block"
  "BlurVision"
  "Cybermedium"
  "Doom"
  "DrPepper"
  "Electronic"
  "Epic"
  "Lean"
  "miniwi"
  "RubiFont"
  "Slant"
  "Small"
  "StarWars"
)

get_color() {
  local color_name=$1
  local color_value
  case $color_name in
    red) color_value=$RED ;;
    green) color_value=$GREEN ;;
    orange) color_value=$ORANGE ;;
    cyan) color_value=$CYAN ;;
    skyblue) color_value=$SKYBLUE ;;
    yellow) color_value=$YELLOW ;;
    blue) color_value=$BLUE ;;
    purple) color_value=$PURPLE ;;
    azure) color_value=$AZURE ;;
    plain) color_value=$PLAIN ;;
    bold) color_value=$BOLD ;;
    pink) color_value=$PINK ;;
    success) color_value=$SUCCESS ;;
    complete) color_value=$COMPLETE ;;
    warn) color_value=$WARN ;;
    error) color_value=$ERROR ;;
    fail) color_value=$FAIL ;;
    tip) color_value=$TIP ;;
    working) color_value=$WORKING ;;
    dot) color_value=$DOT ;;
    *) color_value="" ;;
  esac
  echo "$color_value"
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

font_name=$(get_param "--font" "miniwi" "$@")
# get local or remote font file
get_font_data() {
  local font_file="$1"
  # if font_file is empty, use cdn font
  if [[ -z "$font_file" ]]; then
    font_file="$font_cdn/$font_name.flf"
  fi
  # if it is a local file, check if it exists
  if [[ $font_file && "$font_file" != http* && ! -f "$font_file" ]]; then
    echo "Font file not found: $font_file"
    exit 1
  fi
  if [[ "$font_file" == http* ]]; then
    curl -s "$font_file"
  else
    cat "$font_file"
  fi
}

font_cdn="https://static.zloved.me/shell/fonts"
current_dir=$(cd "$(dirname "$0")" && pwd)
font_file=$(get_param "--font-file" "" "$@")
origin_str=$(get_param "--str" "XIAOLU" "$@")
ascii_color=$(get_param "--color" "plain" "$@")
to_bash=$(get_param "--to-bash" "false" "$@")

FONT_DATA=$(get_font_data "$font_file")

draw_char() {
  # check if the font data is valid
  if [[ ! "$FONT_DATA" =~ ^flf2a ]]; then
    echo "Invalid font file format."
    exit 1
  fi

  local str="$1"
  local font="$2"
  local font_data="$FONT_DATA"
  local header=$(echo "$font_data" | head -n 1)
  local hard_blank=${header:5:1}
  local height=$(echo "$header" | awk '{print $2}')
  local comment_lines=$(echo "$header" | awk '{print $6}')

  font_data=$(echo "$font_data" | tail -n +$((comment_lines + 2)))

  local result=()
  for ((i = 0; i < height; i++)); do
    result[i]=""
  done

  for ((i = 0; i < ${#str}; i++)); do
    local char=${str:i:1}
    local ascii=$(printf "%d" "'$char")
    local offset=$((ascii - 32))
    local char_data=$(echo "$font_data" | awk -v height="$height" -v offset="$offset" '
      NR > offset * height && NR <= (offset + 1) * height
    ')

    local line=0
    while IFS= read -r char_line; do
      char_line=${char_line//"$hard_blank"/" "}
      char_line=${char_line//@/ }
      result[line]+="$char_line"
      ((line++))
    done <<< "$char_data"
  done

  # output the result
  echo ""
  for line in "${result[@]}"; do
    if [[ -n "${line// }" ]]; then
      if [[ "$to_bash" == "true" ]]; then
        color_value=$(get_color "$ascii_color")
        echo "echo -e \"${color_value}${line}${PLAIN}\""
      else
        level_print "$ascii_color" "$line"
      fi
    fi
  done
  echo ""
}

do_draw_file() {
  if [[ "$*" == *"--help"* ]]; then
    level_print "success" " Author : $AUTHOR"
    level_print "success" " Github : $AUTHOR_GITHUB"
    level_print "success" " Description : $DESCRIPTION"
    level_print "working" " Modified Date : $MODIFIED_DATE"
    level_print "plain" ""
    level_print "plain" "Usage: draw_char.sh [OPTIONS]"
    level_print "plain" "Options:"
    level_print "plain" "  --font <font_name>       Specify the font name (default: miniwi)"
    level_print "plain" "  --font-file <file_path>  Specify the font file path (local or remote)"
    level_print "plain" "  --str <string>           Specify the string to draw (default: XIAOLU)"
    level_print "plain" "  --color <color_name>     Specify the color (default: plain)"
    level_print "plain" "  --to-bash <true|false>   Convert output to bash commands (default: false)"
    level_print "plain" "  --list-font              List available fonts"
    level_print "plain" "  --list-color             List available colors"
    level_print "plain" "  --help                   Show this help message"
    level_print "plain" "  --version                Show version information"
    exit 0
  elif [[ "$*" == *"--list-font"* ]]; then
    level_print "bold" "Available fonts:"
    for font in "${AVAILABLE_FONTS[@]}"; do
      level_print "working" "  $font"
    done
    exit 0
  elif [[ "$*" == *"--list-color"* ]]; then
    level_print "bold" "Available colors:"
    for color in "${AVALIABLE_COLORS[@]}"; do
      dot_str=$(level_print "dot" "  ${color}")
      level_print "$color" " $dot_str"
    done
    exit 0
  elif [[ "$*" == *"--version"* ]]; then
    level_print "success" " Description : $DESCRIPTION"
    level_print "success" " Version : 1.0.0"
    level_print "success" " Author : $AUTHOR"
    level_print "success" " Github : $AUTHOR_GITHUB"
    level_print "working" " Modified Date : $MODIFIED_DATE"
    level_print "plain" ""
    exit 0
  else
    draw_char "$origin_str" "$font_file"
  fi
}

do_draw_file "$@"