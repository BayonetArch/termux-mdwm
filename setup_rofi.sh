#!/usr/bin/env bash

info="[\033[1;33mi\033[0m]"

if ! command -v rofi >/dev/null; then
  echo -e "${info}installing \033[0;32mrofi\033[0m now..."
  if ! apt install rofi -y; then
    echo -e "installing rofi \033[0;31mfailed\033[0m" && exit 1
  fi
fi

[[ ! -d ./dwm ]] && echo "dwm dir not found " && exit 1
[[ ! -d ./rofi ]] && echo "rofi dir not found " && exit 1

rofi_config_path="$HOME/.config/rofi"

mkdir -p "$HOME"/.config/rofi || exit

echo -e "${info}copying rofi config to $rofi_config_path "
sleep 1.5

if ! cp -r ./rofi/ rofi_config_path; then
  echo -e "ERROR:failed to copy rofi config to path : '$(rofi_config_path)'"
  echo "you can copy the rofi folder to  .config/rofi"
  exit
fi

read -rp "start compiling?[Y/n] " choice && choice=${choice^}
[[ $choice == *"N"* ]] && exit

cd ./dwm || exit
echo -e "${info}compiling dwm "
echo
sleep 1.5

if ! make clean install; then
  echo "ERROR:failed to compile dwm "
  exit 1
fi
echo
echo -e "Setting \033[0;32mrofi\033[0m success"
echo "in dwm u can press alt + r to open rofi drun"
echo "you can change keybindings  in ./dwm/config.h "
