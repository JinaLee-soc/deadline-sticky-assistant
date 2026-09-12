#!/bin/zsh
set -euo pipefail
cd -- "${0:A:h}"
choice=$(osascript -e 'choose from list {"English", "한국어"} with title "Research Desk" with prompt "Choose your language / 언어를 선택하세요" default items {"English"}')
[[ "$choice" == "false" ]] && exit 0
language=en
[[ "$choice" == "한국어" ]] && language=ko
zsh build.sh
destination="$HOME/Applications/Research Desk.app"
if [[ -e "$destination" ]]; then
  printf 'An installation already exists. Quit it and rename it before installing this build. No files were replaced.\n'
  exit 1
fi
mkdir -p "$HOME/Applications"
ditto 'dist/Research Desk.app' "$destination"
open "$destination" --args --language "$language"
