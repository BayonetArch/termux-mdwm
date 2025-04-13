#!/bin/bash
if ! command -v figlet >/dev/null 2>&1; then
  echo -e "\033[1;34mInstalling figlet...\033[0m"
  if apt install -y figlet >/dev/null 2>&1; then
    echo -e "\033[1;32m✓ Figlet installed successfully\033[0m"
  else
    echo -e "\033[1;31m✗ Failed to install Figlet\033[0m"
  fi
fi



source ./setup/colors.sh || {
  echo "Error: Failed to source colors.sh"
  exit 1
}

clear

echo -e "${CYAN_BOLD}"
figlet -w $COLUMNS -f small "Initial Check"
echo -e "${MAGENTA_BOLD}"
figlet -w $COLUMNS "For Installation"
echo -e "${NC}"

box_width=$((COLUMNS < 80 ? COLUMNS : 80))
padding=$(( (COLUMNS - box_width) / 2 ))
padding_spaces=$(printf "%${padding}s")

echo -e "${YELLOW_BOLD}"
echo "${padding_spaces}┌───────────────────────────────────────────────────────────────────────┐" | cut -c 1-$box_width
echo "${padding_spaces}│               We'll check if you have the required                    │" | cut -c 1-$box_width
echo "${padding_spaces}│                  apps for this setup                                  │" | cut -c 1-$box_width
echo "${padding_spaces}│                                                                       │" | cut -c 1-$box_width
echo "${padding_spaces}│     If not, you can choose 'no' to open the download link             │" | cut -c 1-$box_width
echo "${padding_spaces}│             and grab them directly from GitHub.                       │" | cut -c 1-$box_width
echo "${padding_spaces}└───────────────────────────────────────────────────────────────────────┘" | cut -c 1-$box_width
echo -e "${NC}"













TERMUX_X11_URL="https://github.com/termux/termux-x11/releases/tag/nightly"
TERMUX_API_URL="https://github.com/termux/termux-api/releases/tag/v0.51.0"

ask_yes_no() {
  local prompt="$1"
  local response
  while true; do
    read -p "$(echo -e "${BLUE}?${NC} ${prompt} (y/n):${NC} ")" response
    if [[ "$response" == "y" || "$response" == "yes" ]]; then
      return 0
    elif [[ "$response" == "n" || "$response" == "no" ]]; then
      return 1
    else
      echo -e "${WARN} Please enter 'y' or 'n'.${NC}"
    fi
  done
}

handle_app_check() {
  local app_name="$1"
  local app_pkg="$2"
  local app_desc="$3"
  local app_url="$4"
  local confirmation_var_name="$5"

  declare -g "$confirmation_var_name"="no"

  echo -e "\n${YELLOW_BOLD}--- Checking: ${app_name} ---${NC}"
  echo -e "${app_desc}"
  if ask_yes_no "Is ${WHITE_BOLD}${app_name}${NC} already installed?"; then
    echo -e "${GREEN}Okay, got it.${NC}"
    declare -g "$confirmation_var_name"="yes"
    return 0
  else
    if ask_yes_no "would you like to download by opening link in browser? ${app_name}?"; then
      echo -e "${MAGENTA}Opening link ${ARROW}${NC} ${app_url}"
      if command -v termux-open > /dev/null 2>&1; then
        termux-open "$app_url"
        echo -e "${YELLOW}Install the app from the page that opens, then come back here.${NC}"
      else
        echo -e "${WARN} Can't find 'termux-open'. Sorry, can't open the link.${NC}"
        echo -e "${YELLOW}Please install ${app_name} (${WHITE_BOLD}${app_pkg}${NC}${YELLOW}) manually.${NC}"
      fi
      echo
      if ask_yes_no "Did you get ${WHITE_BOLD}${app_name}${NC} installed now?"; then
        echo -e "${GREEN}Great! Marked as installed.${NC}"
        declare -g "$confirmation_var_name"="yes"
        return 0
      else
        echo -e "${WARN} Alright, marked as ${RED_BOLD}NOT installed${NC}${YELLOW}. You might need it later.${NC}"
        declare -g "$confirmation_var_name"="no"
        return 1
      fi
    else
      echo -e "${YELLOW}Okay, skipping the link.${NC}"
      echo -e "${YELLOW}Remember to install ${app_name} (${WHITE_BOLD}${app_pkg}${NC}${YELLOW}) yourself if needed.${NC}"
      declare -g "$confirmation_var_name"="no"
      return 1
    fi
  fi
}


handle_app_check "Termux:X11" "$TERMUX_X11_PKG" "$X11_DESC" "$TERMUX_X11_URL" "TERMUX_X11_CONFIRMED"
handle_app_check "Termux:API" "$TERMUX_API_PKG" "$API_DESC" "$TERMUX_API_URL" "TERMUX_API_CONFIRMED"

echo -e "\n${YELLOW_BOLD}--- Final Check ---${NC}"

final_confirmation_passed="no"

while true; do
  echo -e "So, here's the status:"
  if [[ "$TERMUX_X11_CONFIRMED" == "yes" ]]; then
    echo -e " ${CHECK} Termux:X11 ${ARROW} ${GREEN_BOLD}Looks installed${NC}"
  else
    echo -e " ${WARN} Termux:X11 ${ARROW} ${RED_BOLD}Looks missing${NC}"
  fi
  if [[ "$TERMUX_API_CONFIRMED" == "yes" ]]; then
    echo -e " ${CHECK} Termux:API  ${ARROW} ${GREEN_BOLD}Looks installed${NC}"
  else
    echo -e " ${WARN} Termux:API  ${ARROW} ${RED_BOLD}Looks missing${NC}"
  fi
  echo
  if ask_yes_no "Just to double-check, are ${WHITE_BOLD}both${NC} Termux:X11 and Termux:API installed now?"; then
    final_confirmation_passed="yes"
    break
  else
    echo -e "\n${WARN} Okay, looks like something might still be missing.${NC}"
    if ask_yes_no "Want to quickly run through the checks again?"; then
      handle_app_check "Termux:X11" "$TERMUX_X11_PKG" "$X11_DESC" "$TERMUX_X11_URL" "TERMUX_X11_CONFIRMED"
      echo -e "\n${YELLOW_BOLD}--- Re-checking Final Status ---${NC}"
    else
      echo -e "${YELLOW}Alright, skipping the re-check. Please install them manually if needed.${NC}"
      final_confirmation_passed="no"
      break
    fi
  fi
done

echo

if [[ "$final_confirmation_passed" == "yes" ]]; then
  echo -e "${BLUE}you are good to go !!${NC}"
else
  echo -e "${WARN}Check finished. Remember to install any missing apps!${NC}"
fi

read -p "$(echo -e "${YELLOW_BOLD}start the installation now? (y/n):${NC} ")" continue_choice

if [[ "$continue_choice" != "y" ]]; then
  echo -e "${RED_BOLD}installation stopped !${NC}"
  exit 1
fi
echo


# check if storage is already setup
clear 
echo -e "${ARROW}${RED}seting up storage !${NC}"

if [ ! -d "$HOME/storage/shared" ]; then
  echo
  echo -e "${RED_BOLD}you haven't setup the storage yet${NC}"
  echo -e "${WARN}${RED}Click allow on your screen${NC}"
  sleep  2
  echo 
  termux-setup-storage
  sleep 2
  echo
  echo  -e  "${TICK}${GREEN_BOLD}Done!${NC}"
else
  echo -e "${TICK}${GREEN_BOLD}Storage already set up !${NC}"
fi
sleep 3
clear
# package list
pkgs=(
  git  x11-repo tur-repo python nodejs wget abseil-cpp adwaita-icon-theme-legacy adwaita-icon-theme alacritty
  alsa-lib alsa-utils angle-android apt at-spi2-core bash brotli bzip2 ca-certificates
  clang command-not-found coreutils curl dash dbus debianutils desktop-file-utils
  dialog diffutils dmenu dos2unix dpkg ed ffmpeg fftw findutils firefox fontconfig
  freeglut freetype fribidi game-music-emu gawk gdbm gdk-pixbuf giflib glib-bin glib
  glmark2 glu gpgv grep gtk-update-icon-cache gtk3 gzip harfbuzz hicolor-icon-theme
  inetutils krb5 ldns less libandroid-execinfo libandroid-glob libandroid-posix-semaphore
  libandroid-selinux libandroid-shmem libandroid-spawn libandroid-support
  libandroid-sysv-semaphore libaom libass libassuan libbluray libbz2 libc++ libcairo
  libcap-ng libcompiler-rt libcrypt libcurl libdav1d libdb libdrm libedit libepoxy libevent
  libexpat libffi libflac libgcrypt libglvnd libgmp libgnutls libgpg-error libgraphite libice
  libiconv libicu libidn2 libjpeg-turbo libllvm libltdl liblua51 libluajit liblz4 liblzma
  liblzo libmd libmp3lame libmpfr libmsgpack libnettle libnghttp2 libnghttp3 libnpth
  libnspr libnss libogg libopencore-amr libopenmpt libopus libpixman libpng librav1e
  libresolv-wrapper libsamplerate libsm libsmartcols libsndfile libsodium libsoxr
  libsqlite libsrt libssh2 libssh libtheora libtiff libtirpc libudfread libunbound
  libunibilium libunistring libuuid libuv libv4l libvidstab libvmaf libvo-amrwbenc
  libvorbis libvpx libvterm libwayland libwebp libwebrtc-audio-processing libx11 libx264
  libx265 libxau libxcb libxcomposite libxcursor libxdamage libxdmcp libxext libxfixes
  libxft libxi libxinerama libxkbcommon libxml2 libxmu libxrandr libxrender libxshmfence
  libxt libxtst libxxf86vm libzimg libzmq littlecms lld llvm lsof lua51-lpeg luv make
  mesa-demos mesa-vulkan-icd-swrast mesa mpg123 nano ncurses-ui-libs ncurses
  ndk-sysroot neovim net-tools ocl-icd opengl openssh-sftp-server openssh openssl
  pango patch pcre2 pkg-config procps psmisc pulseaudio python-ensurepip-wheels
  python-pip python readline resolv-conf rubberband sed shared-mime-info speexdsp
  st svt-av1 tar termux-am-socket termux-am termux-api termux-auth termux-core
  termux-exec termux-keyring termux-licenses termux-tools termux-x11-nightly
  tree-sitter-c tree-sitter-lua tree-sitter-markdown tree-sitter-parsers
  tree-sitter-query tree-sitter-vim tree-sitter-vimdoc tree-sitter ttf-dejavu tur-repo
  unzip utf8proc util-linux virglrenderer-android virglrenderer vulkan-icd
  vulkan-loader-generic vulkan-loader vulkan-tools x11-repo xkeyboard-config
  xorg-util-macros xorg-xauth xorgproto xvidcore xxhash xz-utils zlib zstd starship
)

# Install function
install_pkgs() {
  echo -e "${YELLOW_BOLD}==> Starting package installation...${NC}"
  echo ""

  for p in "${pkgs[@]}"; do
    echo -ne "${CYAN_BOLD}Installing ${WHITE_BOLD}$p${NC}... "
    if apt install -y "$p" &>/dev/null; then
      echo -e "${GREEN}${TICK} Installed${NC}"
    else
      echo -e "${RED}${CROSS} Failed${NC}"
    fi
  done

  echo ""
  echo -e "${GREEN_BOLD}==> Packages are installed!${NC}"
}
install_pkgs
# setup termux color theme
echo -e "${CYAN_BOLD}setting up termux theme...${NC}"

mkdir -p "$HOME/.termux"

if cp ./setup-themes/colors.properties "$HOME/.termux/" 2>/dev/null; then
  echo -e "${GREEN}${TICK} theme has been set up${NC}"
else
  echo -e "${RED}${CROSS} failed to setup theme${NC}"
  echo -e "${YELLOW}you can copy the file manually from ./setup-themes/colors.properties to ~/.termux/colors.properties${NC}"
fi

#reload termux settings
echo  -e  "${ARROW}${BOLD_CYAN}.. Reloading termux${NC}"
termux-reload-settings
#setup .bashrc and starship themes
clear
echo -e "${ARROW}${YELLOW_BOLD}Setting up  Starship theme and bashrc!${NC}"
cp ./setup/.bashrc ~/.bashrc
sleep 1
echo -e "${TICK}${GREEN}Copied bashrc!"

sleep 1
echo -e "${ARROW}${YELLOW_BOLD}Setting up starship theme!${NC}"
echo
echo
mkdir -p ~/.config
cp ./setup-themes/starship.toml ~/.config
termux-reload-settings
sleep 2
echo 
echo
echo -e "${TICK}${GREEN}Finished setting starship1!${NC}"

#setting  up for dwm compilation
#scary
echo -e "${RED_BOLD}setting up for compiling dwm${NC}"

# replace X11 headers
echo -e "${ARROW} ${RED_BOLD}replacing X11 headers...${NC}"
rm -rf "$PREFIX/include/X11"
cp -r ./dwm-fixes/X11 "$PREFIX/include/"

# add freetype headers
echo -e "${ARROW}${RED_BOLD} copying freetype headers...${NC}"
rm -rf "$PREFIX/include/freetype"
cp -r ./dwm-fixes/freetype "$PREFIX/include/"
sleep 1
echo 
# add ft2build.h
echo -e "${ARROW} ${RED_BOLD} copying ft2build.h..${NC}."
cp ./dwm-fixes/ft2build.h "$PREFIX/include/"
sleep 1
echo 
echo -e "${TICK} ${GREEN_BOLD}dwm compile headers setup complete"

sleep 1
clear

#compiling dwm

echo -e "${ARROW}${CYAN_BOLD}COMPILING DWM !${NC}"
echo
echo
cd ./dwm
make clean install 
cd ..
sleep 1
echo
echo -e "${TICK}${YELLOW}COMPILING FINISHED!${NC}" 

#Copy start script  to /bin
echo -e "${INFO}${RED}         Copying start script to /bin !${NC}"
cp ./setup/start $PREFIX/bin/
sleep 1
echo
echo -e "${TICK}${YELLOW} DONE!${NC}" 

#setup for dwm themes
mkdir -p ~/.themes
mkdir -p ~/.local/share/fonts
cp -r ./setup-themes/Everforest-Dark ~/.themes/
cp ./setup-themes/JetBrainsMonoNerdFont-Regular.ttf ~/.local/share/fonts/
sleep 2
echo -e  "${CYAN_BOLD}Setting up theme succesfull !!${NC}"
sleep 2
clear


echo -e "${CYAN_BOLD}$(figlet  'Installation Finished')${NC}"
sleep 2
echo -e "\n${BLUE}Installation is complete.${NC}"
echo -e "${CYAN_BOLD}A restart is recommended.${NC}"
echo -e "\n${WARN}${RED_BOLD}To start your desktop,${NC} use: ${GREEN_BOLD}start${NC}\n"

echo -e "${CYAN}If you encounter any errors, check out my GitHub:${NC} ${CYAN_BOLD}https://github.com/BayonetArch/${RESET}"
echo -e "${CYAN}Or visit my YouTube channel ${NC} ${CYAN_BOLD}https://www.youtube.com/@Bayonet7${RESET}"

