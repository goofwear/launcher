#!/bin/bash
exit1() {
  exit 1
}
tYEL="\e[33m"
tRED="\e[91m"
tGRE="\e[92m"
tRST="\e[39m"
tBLD="\e[1m"
tTICK="✔"
tELLIP="⋯"
e_red() { echo -e "${tRED}${1}${tRST}";}
e_green() { echo -e "${tGRE}${1}${tRST}";}
e_yellow() { echo -e "${tYEL}${1}${tRST}";}
noop() {
  echo "noop" > /dev/null
}
OPT_CHECK_BASE=true
OPT_UNINSTALL=false
OPTIND=1
while getopts ":n:u" opt; do
  case ${opt} in
    n )
      OPT_CHECK_BASE=false
      e_green "Skipping check of base directory"
    ;;
    u )
      e_red "This is where the uninstall would be called probably"
      OPT_UNINSTALL=true
    ;;
    \?)
      e_red "Invalid option: -$OPTARG" 1>&2
      exit1
    ;;
  esac
done
shift $((OPTIND -1))


## yesno <prompt> <yes_text> <yes_cmd> <no_text> <no_cmd>
yesno() {
  e_yellow "${1} [Y/n]"
  local choice_made=0
  read user_choice
  while [[ "${choice_made}" < 1 ]]; do
    case "$(echo ${user_choice} | tr '[:upper:]' '[:lower:]')" in
      "y" | "yes" | "")
        choice_made=1
        e_green "${tELLIP} ${2}"
        ${3}
      ;;
      "n" | "no")
        choice_made=1
        e_yellow "${tELLIP} ${4}"
        ${5}
      ;;
      *)
        e_red "Please enter 'y' or 'n'."
        read user_choice
      ;;
    esac
  done
}
CURRENT_BASE=$(cd "$(dirname "${0}")"; pwd -P)
EXPECTED_BASE="${HOME}/launcher"

delete_existing_base () {
  rm -r "${EXPECTED_BASE}"
}
check_base () {
  if [ "$EXPECTED_BASE" != "$CURRENT_BASE" ]; then
    e_yellow "Not running Launcher install from the right place. I'll attempt to move it..."
    if [ -d "$EXPECTED_BASE" ]; then
      e_red "You already have a '${EXPECTED_BASE}' directory!"
      yesno "Do you want me to delete it?" "Deleting '${EXPECTED_BASE}'" delete_existing_base "Okay go and sort your files out and try the install again" exit1
    fi
    e_green "${tELLIP} Creating '${EXPECTED_BASE}' directory"
    mkdir -p "${EXPECTED_BASE}"
    e_green "${tELLIP} Copying files from '${CURRENT_BASE}' to '${EXPECTED_BASE}'"
    cd "${CURRENT_BASE}"
    cp -R ./* "${EXPECTED_BASE}"
    if [[ -d "${EXPECTED_BASE}" ]]; then
        e_green "${tELLIP} Deleting '${CURRENT_BASE}'"
        rm -r "${CURRENT_BASE}"
        CURRENT_BASE="${EXPECTED_BASE}"
        cd "${CURRENT_BASE}"
        exec "./install.sh" -n
    else
        e_red "Something went wrong!"
    fi
    exit1
  fi
}
do_backup_awesome() {
  cp -R "${HOME}/.config/awesome" "${HOME}/.config/awesome.bak"
  e_green "${tTICK} Backup created!"
  e_yellow "You can run the install script with -u to restore the backup"
}
check_backup_awesome () {
  yesno "Do you want to backup the default config for awesome? (~/.config/awesome)" "Creating a backup in ~/.config/awesome.bak" do_backup_awesome "Overwriting ~/.config/awesome with new config" noop
}
do_install_awesome () {
  echo "Installing awesome config"
  cd "${CURRENT_BASE}/awesome"
  cp -R ./* "${HOME}/.config/awesome"
}
check_running_root () {
  if [[ $(id -u) -eq 0 ]]; then
    e_red "Don't run this script as root/sudo, parts of the script depend on you"
    e_red "being the correct non-root user. You will be prompted for your sudo"
    e_red "password when it is needed..."
    exit1
  fi
}
do_install_deps () {
  sudo apt update
  sudo apt install git libuser synaptic -y
  sudo apt install python-wicd wicd wicd-curses python-pycurl python-alsaaudio python-pygame python-gobject python-xlib -y
  sudo apt install python-pip -y
  sudo pip install validators numpy requests python-mpd2 beeprint

  chmod +x load.sh
}
do_make_usergroup () {
  sudo groupadd cpifav -g 31415
  sudo adduser chip cpifav
}
do_add_sudoers () {
  printf "chip ALL = (root) NOPASSWD: /sbin/reboot\nchip ALL = (root) NOPASSWD: /sbin/shutdown\nchip ALL = (root) NOPASSWD: /usr/sbin/rfkill\n" | sudo tee /etc/sudoers.d/launcher
  sudo chmod 0440 /etc/sudoers.d/launcher
}
do_remove_pockethome () {
  sudo apt -y remove pocket-home
}
do_restart () {
  sudo reboot
}
do_complete () {
  e_green "Installation complete!"
  yesno "Do you want to restart your PocketCHIP now?" "Restarting" do_restart "Alright, but you need to restart to start using the new launcher" noop
}
do_uninstall() {
  echo "Uninstall would be here"
  if [[ -d "${HOME}/.config/awesome.bak" ]]; then
    e_green "Restoring awesome config"
    cd "${HOME}/.config/awesome.bak"
    cp -R ./* "${HOME}/.config/awesome"
  fi
  sudo apt -y install pocket-home
  e_green "pocket-home launcher is now reinstalled."
}

check_running_root
if [[ "$OPT_UNINSTALL" == true ]]; then
  do_uninstall
else
  if [[ "$OPT_CHECK_BASE" == true ]]; then check_base; fi
  check_backup_awesome
  do_install_awesome
  do_install_deps
  do_make_usergroup
  do_remove_pockethome
  do_add_sudoers
fi
do_complete
