#!/bin/bash

# Load colors
source ./setup/colors.sh
clear
# check if storage is already setup
if [ ! -d "$HOME/storage/shared" ]; then
  echo
  echo -e "${RED_BOLD}you haven't setup the storage yet${NC}"
  echo -e "${WARN}${RED}Click allow on your screen${NC}"
  sleep  2
  echo 
  termux-setup-storage
  sleep 3
  echo
  echo  -e  "${TICK}${GREEN_BOLD}Done!${NC}"
  echo
  echo -e "${TICK}${GREEN_BOLD}Storage already set up !${NC}"
fi
sleep 3.5
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
echo  -e  "${INFO}${BOLD_CYAN}.. Reloading termux${NC}"
termux-reload-settings


