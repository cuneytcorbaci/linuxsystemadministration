#RedHat Package Manager (RPM) and **YellowDog Update Manager (YUM)** are used by Fedora, RedHat, RHEL, CentOS, RocksOS, ... to manage packages.
 #The package format is called RPM and can be managed by `rpm` tools but if you want to use the repositories to install, update, search, ... packages, or even upgrade the whole system, you can use the `yum` command. 

#yum
 #`yum` is the package manager used by RedHat-based systems. Its configuration files are located at `/etc/yum.conf` and `/etc/yum.repos.d/`. Below is a sample.

 cat /etc/yum.conf
 [main]
 cachedir=/var/cache/yum/$basearch/$releasever
 keepcache=0
 debuglevel=2
 logfile=/var/log/yum.log
 exactarch=1
 obsoletes=1
 gpgcheck=1
 plugins=1
 installonly_limit=3

 #And here is a sample of an actual Repo file on a Fedora system:

 cat /etc/yum.repos.d/fedora.repo 

 #And here you can find some of the commands:

 | Command        | Description                                                                           |
 | ---            | ---                                                                                   |
 | update         | Updates the repositories and update the names of packages, or all if nothing is named |
 | install        | Install a package                                                                     |
 | reinstall      | Reinstall a package                                                                   |
 | list           | Show a list of packages                                                               |
 | info           | Show information about a package                                                      |
 | remove         | Removes an installed package                                                          |
 | search         | Searches repositories for packages                                                    |
 | provides       | Check which packages provide a specific file                                          |
 | upgrade        | Upgrades packages and removes the obsolete ones                                       |
 | localinstall   | Install from a local rpm file                                                         |
 | localupdate    | Updates from a local rpm file                                                         |
 | check-update   | Checks repositories for updates to the installed packages                             |
 | deplist        | Shows dependencies of a package                                                       |
 | groupinstall   | Install a group, say "KDE Plasma Workspaces"                                          |
 | history        | Show history of the usage                                                             |

 #This is a sample installation:

 yum install bzr
 
 #You can also use the wildcards:

 yum update 'cal*'

 #Fun fact: Fedora Linux uses `dnf` as its package manager and will translate your `yum` commands to its `dnf` equivalents.

#yumdownloader
 #This tool will download rpms from repositories without installing
 #them. If you need to download all the dependencies too, use the `--resolve` switch:

 yumdownloader --resolve bzr

#RPM
 #The rpm command can run ACTIONs on individual RPM files. You can use it like rpm ACTION [OPTION] rpm_file.rpm
 #One of common options is -v for verbose output and these are the common ACTIONs:

 | Short Form   | Long Form     | Description                               |
 | ---          | ---           | ---                                       |
 | -i           | --install     | Installs a package                        |
 | -e           | --erase       | Removes a package                         |
 | -U           | --upgrade     | Installs/Upgrades a package               |
 | -q           | --query       | Checks if the package is installed        |
 | -F           | --freshen     | Only update if its already installed      |
 | -V           | --verify      | Check the integrity of the installation   |
 | -K           | --checksig    | Checks the integrity of an rpm package    |

 #Please note that each action might have its specific options

 #Install and update
 #In most cases, we use `-U` which Installs or upgrades a package.
 #- RPM does not have a database of automatic package installation, so it can not remove the automatically installed dependencies.
 #If you have an rpm with all of its dependencies, you can install them using `rpm -Uvh *.rpm`. This will tell rpm not to complain about the dependencies if it is presented in other files. Here the `-h` creates 50 hash signs to show the progress.
 #In some cases - if you know what you are doing - you can use `--nodeps` to prevent the dependency check or even use `--force` to force the install / upgrade despite all the issues & complains.

 #Query
 # A normal query is like this:

 rpm -q breezy-3.2.1-3.fc36.x86_64.rpm
  breezy-3.2.1-3.fc36.x86_64
 rpm -q breezy
  breezy-3.2.1-3.fc36.x86_64
 rpm -q emacs
  package emacs is not installed

 #And you can use these options to spice it up:

 | Short    | Long              | Description                                   |
 | ---      | ---               | ---                                           |
 | -c       | --configfiles     | Show the packages configuration files         |
 | -i       | --info            | Detailed info about a pacakge                 |
 | -a       | --all             | Show all Installed packages                   |
 |          | --whatprovides    | Shows what packages provide this file         |
 | -l       | --list            | Query the list of files a package installs    |
 | -R       | --requires        | Show dependencies of a package                |
 | -f       | --file            | Query package owning file                     |

 #Verify
 #You can verify your packages and see if they are installed correctly or not. You can use the `-Vv` option for verbose output or just use the `-V` to verify and see only the issues. This is the output after I edited the `/bin/tmux` manually:
 
 rpm -V tmux
  S.5....T.    /usr/bin/tmux`

 #And this is part of the `man rpm`'s `-V` section:

    S Size differs
    M Mode differs (includes permissions and file type)
    5 digest (formerly MD5 sum) differs
    D Device major/minor number mismatch
    L readLink(2) path mismatch
    U User ownership differs
    G Group ownership differs
    T mTime differs
    P caPabilities differ

 #You can also check the integrity of an rpm package with `-K`:

 # rpm -Kv breezy-3.2.1-3.fc36.x86_64.rpm
 breezy-3.2.1-3.fc36.x86_64.rpm:
    Header V4 RSA/SHA256 Signature, key ID 38ab71f4: OK
    Header SHA256 digest: OK
    Header SHA1 digest: OK
    Payload SHA256 digest: OK
    V4 RSA/SHA256 Signature, key ID 38ab71f4: OK
    MD5 digest: OK`

 #The above output shows that this file is valid.

 #Uninstall

 rpm -e tmux
 error: Failed dependencies:
    tmux is needed by (installed) anaconda-install-env-deps-36.16.5-1.fc36.x86_64`

 #- rpm removes the package without asking!
 #- rpm won't remove a package that is needed by another package
 
 #Extract RPM Files
 #rpm2cpio
 #The **cpio** is an archive format (Just like zip or rar or tar). You can use the `rpm2cpio` command to convert RPM files to *cpio* and then use the `cpio` tool to extract them:
 
 [root@fedora tmp] rpm2cpio breezy-3.2.1-3.fc36.x86_64.rpm > breezy.cpio
 [root@fedora tmp] cpio -idv < breezy.cpio
 ./usr/bin/brz
 ./usr/bin/bzr
 ./usr/bin/bzr-receive-pack
 ./usr/bin/bzr-upload-pack
 ./usr/bin/git-remote-brz
 ./usr/bin/git-remote-bzr
 [...]


#Zypper
 #The SUSE Linux and its sibling openSUSE use ZYpp as their package manager engine. You can use YAST or Zypper tools to communicate with it.
 #These are the main commands used in `zypper`:

 | Command          | Description                                                   |
 | ---              | ---                                                           |
 | help             | General help                                                  |
 | install          | Installs a package                                            |
 | info             | Displays information of a package                             |
 | list-updates     | Shows available updates                                       |
 | lr               | Shows repository information                                  |
 | packages         | List all available packages or packages from a specific repo  |
 | what-provides    | Show the owner of a file                                      |
 | refresh          | Refreshes the repositories information                        |
 | remove           | Removes a package from the system                             |
 | search           | Searches for a package                                        |
 | update           | Checks the repositories and updates the installed packages    |
 | verify           | Checks a package and its dependencies                         |

 #You can shorten the command when using `zypper`, so `zypper se tmux` will *search* for tmux.
#Other tools
 #YUM and RPM are the main package managers on Fedora, RHEL & 
 Centos but other tools are also available. As mentioned, SUSE uses `YaST`, and some modern desktops (KDE & Gnome) use `PackageKit` which is a graphical tool. It is also good to note that the `dnf` suite is also gaining popularity and is pre-installed on Fedora systems.