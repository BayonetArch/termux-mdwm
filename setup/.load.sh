#!/data/data/com.termux/files/usr/bin/bash

# --- Color Codes ---
# Usage: echo -e "${COLOR}Text${NC}"
# Regular Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
# Bold
BBLACK='\033[1;30m'
BRED='\033[1;31m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
BBLUE='\033[1;34m'
BMAGENTA='\033[1;35m'
BCYAN='\033[1;36m'
BWHITE='\033[1;37m'
# No Color (Reset)
NC='\033[0m' # No Color

# --- Configuration ---
LOGO_TEXT="Termux"
LOGO_FONT="big" # Try other figlet fonts like 'standard', 'big', 'doom'
BAR_WIDTH=50    # Width of the loading bar in characters
# Using Block Character - Requires a font like Fira Code Mono, Nerd Fonts, etc.
# Ensure Termux is configured to use your Fira Code Mono font (e.g., ~/.termux/font.ttf)
# If '?' still appears, fallback to BAR_CHAR_FILLED="=" or "#"
BAR_CHAR_FILLED="*"
BAR_CHAR_EMPTY="-"
BAR_COLOR_FILLED="${BBLUE}"                   # Use defined color variables (Bold Blue)
BAR_COLOR_EMPTY="${WHITE}"                    # Use defined color variables (White)
BAR_COLOR_RESET="${NC}"                       # Use defined reset code
UPDATE_COMMAND="apt update && apt upgrade -y" # Command to run with progress bar

DWM_CMD='start'


# function to display the centered logo
display_logo() {
  clear
  local logo
  # Generate the logo text using figlet
  logo=$(figlet -c -f "$LOGO_FONT" "$LOGO_TEXT")

  # Print the logo line by line and pipe to lolcat for color
  printf "%s\n" "$logo" | lolcat -a -d 1 -p 0.8
  echo # Add a newline after the logo
}

# Function to kill existing X11/VNC sessions
kill_x_sessions() {
  echo -e "${YELLOW}Attempting to kill previous X11/VNC sessions...${NC}"
  # Use pkill with -f to match command lines. The [X] trick avoids pkill matching itself.
  pkill -9 -f "[X]vnc" >/dev/null 2>&1
  pkill -9 -f "[X]tigervnc" >/dev/null 2>&1
  pkill -9 -f "[X]org" >/dev/null 2>&1
  pkill -9 -f "vncserver" >/dev/null 2>&1
  pkill -9 -f "[s]tartx" >/dev/null 2>&1        # Match startx itself
  pkill -9 -f "[t]ermux-x11" >/dev/null 2>&1    # Match termux-x11 command
  pkill -9 -f "[d]wm" >/dev/null 2>&1           # Match window manager
  pkill -9 -f "[x]fce4-session" >/dev/null 2>&1 # Match session manager
  echo -e "${GREEN}Done killing sessions.${NC}"
  sleep 1
}

# function to display the animated progress bar and run a command
run_with_progress_bar() {
  local cmd_to_run="$1"
  local total_steps=100 # Simulate 100 steps for the bar
  local current_step=0

  # Hide cursor
  tput civis

  # Run the command in the background
  eval "$cmd_to_run" >/dev/null 2>&1 &
  local pid=$!

  # Get terminal height for placing the bar at the bottom
  local term_height=$(tput lines)
  local bar_line=$((term_height - 1)) # Bar at the very bottom

  # Ensure bar_line is not negative or zero if terminal is too small
  if [ "$bar_line" -lt 1 ]; then
    bar_line=1 # Fallback to line 1 if terminal is tiny
  fi

  # Animation loop while the background process is running
  while kill -0 $pid 2>/dev/null; do
    current_step=$(((current_step + 2) % (total_steps + 1))) # Increment faster
    if [ $current_step -gt $total_steps ]; then current_step=$total_steps; fi

    local filled_width=$(((current_step * BAR_WIDTH) / total_steps))
    local empty_width=$((BAR_WIDTH - filled_width))

    # Build the bar string
    local bar_filled=$(printf "%${filled_width}s" "" | tr ' ' "$BAR_CHAR_FILLED")
    local bar_empty=$(printf "%${empty_width}s" "" | tr ' ' "$BAR_CHAR_EMPTY")

    # Move cursor to the target line, beginning
    tput cup $bar_line 0

    # Print the bar with colors - Use printf for better control
    printf "[${BAR_COLOR_FILLED}%s${BAR_COLOR_EMPTY}%s${BAR_COLOR_RESET}] ${BYELLOW}%3d%%${NC}" \
      "$bar_filled" "$bar_empty" "$current_step"
    tput el # Clear rest of the line just in case

    # Add a small delay for visibility
    sleep 0.1
  done

  # Wait for the command to actually finish and get exit status
  wait $pid
  local exit_status=$?

  # Ensure the bar shows 100% at the end
  tput cup $bar_line 0
  local bar_filled_final=$(printf "%${BAR_WIDTH}s" "" | tr ' ' "$BAR_CHAR_FILLED")
  printf "[${BAR_COLOR_FILLED}%s${BAR_COLOR_RESET}] ${BGREEN}100%%${NC}" "$bar_filled_final"
  tput el   # Clear rest of line
  sleep 0.5 # Keep 100% visible briefly

  # Move cursor up one line from the bar IF possible, then clear the bar line
  if [ "$bar_line" -gt 0 ]; then
    tput cup $((bar_line - 1)) 0
  fi
  # Clear the line where the progress bar was
  tput cup $bar_line 0
  tput el

  # Ensure cursor is back at a usable position (start of the cleared line)
  tput cup $bar_line 0

  # Show cursor again
  tput cnorm

  # Report status with color
  if [ $exit_status -eq 0 ]; then
    echo -e "${GREEN}System Updated Succesfully!${NC}"
  else
    echo -e "${RED}APT update & upgrade finished with errors (Exit Code: $exit_status).${NC}"
  fi
  echo # Add a newline
}

# Function to ask the user about starting a desktop
ask_desktop() {
  echo # Add spacing
  # Use command substitution with echo -e for colored prompt
  read -p "$(echo -e "${BYELLOW}Do you want to start a graphical desktop session? (y/N): ${NC}")" start_desktop
  start_desktop=${start_desktop:-N} # Default to No if user presses Enter

  if [[ "$start_desktop" =~ ^[Yy]$ ]]; then
    echo -e "${BCYAN}Select Desktop Environment:${NC}"
    echo -e "  ${WHITE}1) DWM (Default)${NC}"
    echo -e "  ${WHITE}2) XFCE4${NC}"
    # Color the input prompt
    read -p "$(echo -e "${BYELLOW}Enter choice (1): ${NC}")" desktop_choice
    desktop_choice=${desktop_choice:-1} # Default to 1

    case $desktop_choice in
    1)
      echo -e "${BLUE}Starting DWM...${NC}"
      # Use exec if you want the script to be replaced by dwm
      # otherwise, just run it:
      eval $DWM_CMD
      ;;
    2)
      echo -e "${BLUE}Starting XFCE4...${NC}"
      eval $XFCE_CMD
      ;;
    *)
      echo -e "${YELLOW}Invalid choice. Not starting any desktop.${NC}"
      ;;
    esac
  else
    echo -e "${GREEN}Okay, not starting a desktop session.${NC}"
  fi
}

# --- Main Script Execution ---

kill_x_sessions
display_logo
echo -e "${CYAN}Updating The System.........${NC}" # Added color here
run_with_progress_bar "$UPDATE_COMMAND"
ask_desktop

# --- End of Script ---
