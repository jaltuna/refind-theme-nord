#!/usr/bin/env bash
#
# The MIT License (MIT)
#
# Copyright (c) 2021 Jeromy Altuna
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# The root of the exec directory
THEME_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

main() {
  if ! [[  $UID -eq 0 ]]; then 
    echo "Permission denied (you must be root)" >&2
    exit 1
  fi

  if ! command -v git &>/dev/null; then
    echo "git must be installed" >&2
    exit 1
  fi
  
  # If you don't use PKGBUILD from Arch
  if ! [[ "${THEME_ROOT#*/}" == "usr/share/refind/themes/nord" ]]; then    
    echo "Downloading rEFInd theme Nord..."

    if ! git clone "https://github.com/jaltuna/refind-theme-nord.git" &>/dev/null; then
      echo "Could not downloaded refind-theme-nord"
      exit 1
    fi
    
    THEME_ROOT="$(cd refind-theme-nord && pwd -P)"
  fi

  echo "Searching rEFInd installation in EFI partition..."
  if ! __has_esp__; then 
    echo "EFI partition not found" >&2
    exit 1
  fi
  
  local yesNo='N'  
  if __refind_dir_exists__; then
    read -r -p "Is rEFInd directory '$REFIND_DIR' (Y/n)? " yesNo    
  fi

  if [[ "${yesNo,,}" == "n" ]]; then
    read -r -p "Enter rEFInd directory: " REFIND_DIR
  fi

  if ! [[ -d "$REFIND_DIR" ]]; then 
    echo "'$REFIND_DIR' is not a directory" >&2
    exit 1 
  fi
  if ! [[ -e "$REFIND_DIR/refind.conf" ]]; then
    echo "File 'refind.conf' not found in '$REFIND_DIR'"
    exit 1
  fi

  # Initializing constants
  NORD_DIR="$REFIND_DIR/themes/nord"
  REFIND_CONF="$REFIND_DIR/refind.conf"
  INCLUDE_LINE="include themes/nord/theme.conf"
  
  # Copying files
  install -D -m0644 -t "$NORD_DIR/" "$THEME_ROOT/"{theme.conf,*.png}
  install -D -m0644 -t "$NORD_DIR/icons/" "$THEME_ROOT/icons/"*.png

  # Including theme
  if ! grep -e "^$INCLUDE_LINE" "$REFIND_CONF" &>/dev/null; then
    sed "s/^include/#include/g" -i "$REFIND_CONF"
    sync

    echo -e "\n#Nord theme\n$INCLUDE_LINE" >> "$REFIND_CONF"
    sync
  fi

  echo "rEFInd theme Nord installed!"  
}

__refind_dir_exists__() {  
  read -r REFIND_DIR <<<"$(find "$ESP" -type d -iname refind 2>/dev/null)"

  [[ -d "$REFIND_DIR" ]] && return 0 || return 1 
}

# Copied from https://github.com/jaltuna/sbmok/master/verify.sh
# Verify EFI System Partition
__has_esp__() {
  __find_esp__

  mount "$ESP" &>/dev/null
  [[ -d "$ESP/EFI" ]] && return 0 || return 1  
}

__find_esp__() {
  local parttype 
  local fstype
  local device 

  while read -r device; do
    read -r parttype fstype ESP <<<"$(lsblk -o "PARTTYPE,FSTYPE,MOUNTPOINT" "$device" 2>/dev/null | awk 'NR==2')"
  
    [[ "${parttype,,}" != "c12a7328-f81f-11d2-ba4b-00a0c93ec93b" ]] && continue
    [[ "${fstype,,}" != "vfat" ]] && continue      
    [[ -z $(findmnt -sn "$ESP") ]] && continue 

  done <<< "$(fdisk -l 2>/dev/null | grep -i efi | cut -d " " -f 1)"

  readonly ESP
}
###

[[ "${BASH_SOURCE[0]}" == "$0" ]] && main "$@"
