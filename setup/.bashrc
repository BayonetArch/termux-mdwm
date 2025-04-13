clear
alias kk='pkill -9 -u $(whoami)'
alias update='pkg update -y && pkg upgrade -y'
alias ..='cd ..'
alias ls='eza -A --icons --no-permissions --no-time --no-user --no-filesize'
function cd() {
  builtin cd "$@" && eza -A --icons --no-permissions --no-time --no-user --no-filesize
}

alias kill="export DISPLAY= && pkill -f 'virgl_test_server_android'&& pkill -f 'termux-x11' && pkill -f && 'com.termux.x11' "
alias k="pkill -f 'com.termux.x11.Loader :0 -ac' "
alias jk="kill & k"
export PATH="$PATH:$HOME/.local/bin/"
eval "$(starship init bash)"
