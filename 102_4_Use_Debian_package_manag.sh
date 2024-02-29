#Concept of the package management system
 #Some people think that on GNU/Linux we have to compile all the software we need manually. This is not the case in 99% of cases and never has been the case in the last 20 years. 
 #GNU/Linux is the predecessor of what we call the App Store these days. All major distros do have huge archives of pre-compiled software called their *repositories* and some kind of a **package manager**
 #software that takes care of searching these repositories, installing software from them, finding dependencies, installing them, resolving conflicts, and updating the system and installed software. Debian-based distros use `.deb` files as their "packages" and use tools like `apt-get`, `dpkg`, `apt`, and other tools to manage them. Debian packages are names like `NAME-VERSION-RELEASE_ARCHITECTURE.deb`; Say `tmux_3.2a-4build1_amd64.deb`.

#Repositories
 #But where did this package come from? How does the OS know where to look for this deb package? The answer is **Repositories**.
 #Each distro has its repository of packages. It can be on a Disk, A network drive, a collection of DVDs, or most commonly, a network address on the Internet.
 #On debian systems, the main configuration locations are:
 `/etc/apt/sources.list`
 `/etc/apt/sources.list.d/`
 
 apt-get update

 #This will check all the sources in the configs and update the information about the latest software available there.
 #This won't actually *Upgrade* the software. The *Update* will only *Update the information about the packages and not the packages themselves*.

#Installing packages
 #Say you have heard about this amazing terminal multiplexer called `tmux` and you want to give it a try.

 $ tmux
 The program 'tmux' is currently not installed. You can install it by typing:
 sudo apt-get install tmux
 $ which tmux
 $ type tmux
 bash: type: tmux: not found

 #So let's install it. If it's in the repositories it's enough to tell the package manager to install it:

 apt-get install tmux

 #Note that
 #- apt-get install asked for confirmation (Y)
 #- apt-get resolved *dependencies*, It knows what is needed to install this package and installs them
 #- Debian packages are something.deb

 #If you only want a dry-run/simulation:

 apt-get install -s tmux
 
 #and this will only download the files needed into the cache without installing them:

 apt-get install --download-only tmux

 #The downloaded packages are stored as a cache in `/var/cache/apt/archive/`.
 #If you want to download only one specific package, you can do:

 apt-get download tmux

#Removing debian packages**

 apt-get remove tmux

 #And if you want to remove automatically installed dependencies:

 $ apt-get autoremove tmux

 #or even

 $ apt-get autoremove
 Reading package lists... Done
 Building dependency tree       
 Reading state information... Done
 The following packages will be REMOVED:
 linux-image-3.16.0-25-generic linux-image-extra-3.16.0-25-generic
 0 upgraded, 0 newly installed, 2 to remove, and 0 not upgraded.
 After this operation, 203 MB of disk space will be freed.
 Do you want to continue? [Y/n] y

 #To autoremove whatever is not needed anymore.
 #Notes:
 #- Removing a package will not remove its dependencies
 #- If removing a dependency, you'll get a warning about what will be removed alongside this package

#Searching for packages
 #If you are using the apt suit, the search is done via `apt-cache` or you can use the general `apt`.

 $ apt-cache search "tiny window"
 $ apt search grub2

#Upgrading
 #For updating a single package:

 apt-get install tzdata

 #And for upgrading whatever is installed:

 apt-get upgrade

 #Or going to a new distribution:

 apt-get dist-upgrade

 #Note: like most other tools, you can configure the default configs at `/etc/apt/apt.conf` and there is a program apt-config for this purpose.

#Reconfiguring packages
 #Debian packages can have *configuration actions* that will take after the package is installed. This is done by `debconf`. For example, tzdata will ask you about the timezone settings after you installed it. 
  #If you want to *reconfigure* a package that is already installed, you can use the `dpkg-reconfigure`:
 
  dpkg-reconfigure tzdata

#Package information with dpkg
 #The underlying tool to work with `.deb` files is the `dpkg`. It is your to-go tool if you want to do manual actions on a deb package. The general format is:

 dpkg [OPTIONS] ACTION PACKAGE

 #Some common actions are:

 | Switch               | Description                                                       |
 | ---                  | ---                                                               |
 | -c or --contents     | Show the contents of a package                                    |
 | -C or --audit        | Search for broken installed packages and propose solutions        |
 | --configure          | Reconfigure an installed package                                  |
 | -i or --install      | Install or Upgrade a package; Wont resolve / install dependencies |
 | -I or --info         | Show Info                                                         |
 | -l or --list         | List all installed packages                                       |
 | -L or --listfiles    | List all files related to this package                            |
 | -P or --purge        | Remove the package and its configuration files                    |
 | -r or --remove       | Remove the package; Keep the configurations                       |
 | -s or --status       | Display status of a package                                       |
 | -S or --search       | Search and see which package owns this file                       |

 #You can check the contents:

 jadi@lpicjadi:/tmp$ dpkg --contents bzr_2.7.0+bzr6622+brz_all.deb
 drwxr-xr-x root/root         0 2019-09-19 18:25 ./
 drwxr-xr-x root/root         0 2019-09-19 18:25 ./usr/
 drwxr-xr-x root/root         0 2019-09-19 18:25 ./usr/share/
 drwxr-xr-x root/root         0 2019-09-19 18:25 ./usr/share/doc/
 drwxr-xr-x root/root         0 2019-09-19 18:25 ./usr/share/doc/bzr/
 -rw-r--r-- root/root       404 2019-09-19 18:25 ./usr/share/doc/bzr/NEWS.Debian.gz
 -rw-r--r-- root/root      1301 2019-09-19 18:25 ./usr/share/doc/bzr/changelog.gz
 -rw-r--r-- root/root      1769 2019-09-19 18:25 ./usr/share/doc/bzr/copyright

 #Or install a deb package (without its dependencies) or check its status:

 $ dpkg -s bzr 
 $ dpkg -L bzr

 #and -S will show which package installed the given file:

 $ dpkg -S /var/lib/mplayer/prefs/mirrors
 mplayer: /var/lib/mplayer/prefs/mirrors


#Common apt-get options

 | Option       | Usage                                                                     |
 | ---          | ---                                                                       |
 | autoclean    | Removes unused packages                                                   |
 | check        | Check db for issues                                                       |
 | clean        | Clean the DB, you can do a clean all to clean everything and start afresh |
 | dist-upgrade | Checks for new versions of the OS; Major upgrade                          |
 | install      | Install or upgrade packages                                               |
 | remove       | Removes a package                                                         |
 | source       | Install the source of a package                                           |
 | update       | Updates the information about packages from repositories                  |
 | upgrade      | Upgrades all packages                                                     |

 #In some cases a package is installed but without proper dependencies (say using `dpkg`) or an installation is interrupted for any reason. In these cases a `apt-get install -f` might help, `-f` is for `fix broken`.

#Common apt-cache options

 | Option   | Usage                                                                         |
 | ---      | ---                                                                           |
 | depends  | Show dependencies                                                             |
 | pkgnames | Shows all installed packages                                                  |
 | search   | Search                                                                        |
 | showpkg  | Show information about a package                                              |
 | stats    | Show statistics                                                               |
 | unmet    | Show unmet dependencies for all installed packages or the one you specified   |

#Other tools
 #There are even more tools, the tools with fancy GUIs or text-based tools and user interface tools like `aptitude`.