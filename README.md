# rEFInd theme Nord
[![Script Static Analysis](https://github.com/jaltuna/refind-theme-nord/actions/workflows/test.yml/badge.svg)](https://github.com/jaltuna/refind-theme-nord/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-informational.svg)](https://opensource.org/licenses/MIT)

Simple [rEFInd](http://www.rodsbooks.com/refind/) theme inspired to the [Nord](https://www.nordtheme.com/) palette.

<img src="samples/boot_nolabel.png">

This theme is derived from icons from other source; see [COPYING](https://github.com/jaltuna/refind-theme-nord/blob/main/COPYING) for details.
 
## Installation

On UNIX-like platforms simply open a terminal and enter:

```bash
[~]$ curl -sL https://git.io/refind-theme-nord | bash
```

<img src="samples/install.gif">

Or if you prefer to install manually:

1. Download lastest release
   ```bash
   [~]$ curl -sL https://github.com/jaltuna/refind-theme-nord/releases/download/1.0.0/refind-theme-nord-1.0.0.tar.gz | tar xvz

   [~]$ cd refind-theme-nord-1.0.0
   ```

2. Identify your `EFI` partition and inside it your `refind` directory. For example: `/efi/EFI/refind`
   ```bash
   [~]$ tree -L 3 /efi
   /efi
   └── EFI
       └── refind
           ├── fonts             
           ├── icons        
           ├── refind.conf
           ├── refind_x64.efi        
           └── vars
   ```
  
3. Create the directory `/efi/EFI/refind/themes/nord` and copy files to it. You need root permissions
   ```bash
   [~]$ sudo mkdir -p /efi/EFI/refind/themes/nord

   [~]$ sudo cp -r {icons,theme.conf,*.png} $_      
   ```

4. Includes Nord theme in `/efi/EFI/refind/refind.conf`
   ```bash
   [~]$ sudo sed "s/^include/#include/g" -i /efi/EFI/refind/refind.conf
  
   [~]$ echo "include themes/nord/theme.conf" | sudo tee -a /efi/EFI/refind/refind.conf
   ```

## Installation on Arch Linux

From AUR repository:<br>

[![AUR version](https://img.shields.io/aur/version/refind-theme-nord?label=AUR)](https://aur.archlinux.org/packages/refind-theme-nord/)
```bash
[~]$ git clone https://aur.archlinux.org/refind-theme-nord.git

[~]$ cd refind-theme-nord

[~]$ makepkg -si
==> Making package: refind-theme-nord 1.0.0-1 (Sun 29 Aug 2021 02:47:40 AM -05)
==> Checking runtime dependencies...
==> Checking buildtime dependencies...
==> Retrieving sources...
  -> Downloading refind-theme-nord-1.0.0.tar.gz...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   638  100   638    0     0   1172      0 --:--:-- --:--:-- --:--:--  1174
100  110k  100  110k    0     0  93527      0  0:00:01  0:00:01 --:--:--  369k
==> Validating source files with sha256sums...
    refind-theme-nord-1.0.0.tar.gz ... Passed
==> Extracting sources...
  -> Extracting refind-theme-nord-1.0.0.tar.gz with bsdtar
==> Starting prepare()...
==> Entering fakeroot environment...
==> Starting package()...
==> Tidying install...
  -> Removing libtool files...
  -> Purging unwanted files...
  -> Removing static library files...
  -> Stripping unneeded symbols from binaries and libraries...
  -> Compressing man and info pages...
==> Checking for packaging issues...
==> Creating package "refind-theme-nord"...
  -> Generating .PKGINFO file...
  -> Generating .BUILDINFO file...
  -> Adding install file...
  -> Generating .MTREE file...
  -> Compressing package...
==> Leaving fakeroot environment.
==> Finished making: refind-theme-nord 1.0.0-1 (Sun 29 Aug 2021 02:47:44 AM -05)
==> Installing package refind-theme-nord with pacman -U...
loading packages...
resolving dependencies...
looking for conflicting packages...

Packages (1) refind-theme-nord-1.0.0-1

Total Installed Size:  0.04 MiB

:: Proceed with installation? [Y/n] Y
(1/1) checking keys in keyring                                                        [#################################################] 100%
(1/1) checking package integrity                                                      [#################################################] 100%
(1/1) loading package files                                                           [#################################################] 100%
(1/1) checking for file conflicts                                                     [#################################################] 100%
(1/1) checking available disk space                                                   [#################################################] 100%
:: Processing package changes...
(1/1) installing refind-theme-nord                                                    [#################################################] 100%
Setup refind-theme-nord-1.0.0-1
Executing /usr/share/refind/themes/nord/setup.sh...
Searching rEFInd installation in EFI partition...
rEFInd theme Nord installed!
:: Running post-transaction hooks...
(1/1) Arming ConditionNeedsUpdate...
[~]$
```

### TODO

* Add icons for other distros
* Add [Snow Storn](https://www.nordtheme.com/docs/colors-and-palettes) palette
