**FHS**

- Filesystem Hierarchy Standard (FHS) is a document describing the Linux/Unix file hierarchy. It is very useful to know these because it lets you easily find what you are looking for as a system admin.
    
    
    | directory | usage |
    | --- | --- |
    | / | Primary hierarchy root and root directory of the entire file system hierarchy |
    | /bin | Essential command binaries |
    | /boot | Static files of the boot loader |
    | /dev | Device files |
    | /etc | Host-specific system configuration |
    | /lib | Essential shared libraries and kernel modules |
    | /media | Mount point for removable media |
    | /mnt | Mount point for mounting a filesystem temporarily |
    | /opt | Add-on application software packages |
    | /sbin | Essential system binaries |
    | /srv | Data for services provided by this system |
    | /tmp | Temporary files |
    | /usr | Secondary hierarchy |
    | /var | Variable data |
    | /home | User home directories (optional) |
    | /lib | Alternate format essential shared libraries (optional) |
    | /root | Home directory for the root user (optional) |
- The `/usr` is the second level of the hierarchy. It containins shareable, read-only data. It can be shared between systems, although present practice does not often do this.
- The `/var` filesystem contains variable data files, including spool directories and files, administrative and logging data, and transient and temporary files. Some portions of /var are not shareable between different systems, but others, such as /var/mail, /var/cache/man, /var/cache/fonts, and /var/spool/news, may be shared.

**Path**

- A general linux install has a lot of files; 741341 files in my case. 
So how the shell finds and runs a command? This is done by a variable 
called PATH:
    
    ```bash
    $ echo $PATH
    /home/jadi/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games;/home/jadi/bin/
    ```
    
- And for the root user:
    
    ```bash
    # echo $PATH
    /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    ```
    
- As you can see, this is the list of directories separated with colon. Obviously you can change your path with `export PATH=$PATH:/usr/new/dir` or put this in `.bashrc` to make it permanent.

**Locating files**

`**which`, `type` and `whereis`**

- The `which` command shows the first appearance of the command given in the path. In other words the  `which mkfs` will tell you what will be run if you issue this `mkfs` command.
    
    ```bash
    $ which mkfs
    /usr/bin/mkfs
    jadi@ubuntuserver:~$ which ping
    /usr/bin/ping
    jadi@ubuntuserver:~$ which -a ping
    /usr/bin/ping
    /bin/ping
    ```
    

> use the -a switch to show all appearance in the path and not only the first one.
> 

But where is the `cd` command?

```bash
jadi@ubuntuserver:~$ which cd
jadi@ubuntuserver:~$ type cd
cd is a shell builtin
```

As you can see, `which` did not find anything for `cd`, so we tried it with `type` to see what the h**l it is.

```bash
$ type type
type is a shell builtin
$ type for
for is a shell keyword
$ type mkfs
mkfs is /sbin/mkfs
$ type chert
bash: type: chert: not found
```

The `type` command is more general than `which` and also understand and shows the *bash keywords*.

Another useful command in this category is `whereis`. Unlike `which`, `whereis` shows man pages and source codes of programs alongside their binary location.

```bash
$ whereis mkfs
mkfs: /usr/sbin/mkfs /usr/share/man/man8/mkfs.8.gz
```

> tip: there is also a whatis command, try it.
> 

**find**

We have already seen this command in [chapter 103.7](https://linux1st.com/1037-search-text-files-using-regular-expressions.html) but let's see a couple of new switches.

- The `user` and `group` specifies a specific user & group
- The `maxdepth` tells the find how deep it should go into the directories.

```bash
$ find /tmp/ -maxdepth 1 -user jadi | head
/tmp/1
/tmp/2
```

Or even find the files not belonging to any user/group with `-nouser` and `-nogroup`.

> Like other tests, you can add a ! just before any phrase to negate it. So this will find files not belonging to jadi: find . ! -user jadi
> 

It is also very common to use for files with specific strings in their names:

```
$ sudo find /etc -iname "*vmware*"
/etc/vmware-tools
/etc/vmware-tools/scripts/vmware

```

**locate & updatedb**

You tries `find` and loved it but there is an issue with it: it does a live active search! This can slow down your system or push too much pressure on your hard or on larger file systems take too long.
 To solve this, there is a faster command:

```bash
$ locate networking
/etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
/snap/core20/1408/usr/lib/python3/dist-packages/cloudinit/distros/networking.py
/snap/core20/1408/usr/lib/python3/dist-packages/cloudinit/distros/__pycache__/networking.cpython-38.pyc
/snap/core20/1826/usr/lib/python3/dist-packages/cloudinit/distros/networking.py
/snap/core20/1826/usr/lib/python3/dist-packages/cloudinit/distros/__pycache__/networking.cpython-38.pyc
/usr/lib/python3/dist-packages/cloudinit/distros/networking.py
/usr/lib/python3/dist-packages/cloudinit/distros/__pycache__/networking.cpython-310.pyc
/usr/lib/python3/dist-packages/sos/report/plugins/networking.py
/usr/lib/python3/dist-packages/sos/report/plugins/__pycache__/networking.cpython-310.pyc
```

And it is fast:

```bash
$ time locate kernel / | wc -l
16989

real    0m0.091s
user    0m0.094s
sys 0m0.034s
```

This is fast because its data comes from a database created with `updatedb` (its package is called `plocate` on debian). Usually this command runs automatically (with a cronjob) on a daily basis. Its configuration file is `/etc/updatedb.conf` or `/etc/sysconfig/locate`:

```bash
$ cat /etc/updatedb.conf
PRUNE_BIND_MOUNTS="yes"
# PRUNENAMES=".git .bzr .hg .svn"
PRUNEPATHS="/tmp /var/spool /media /home/.ecryptfs"
PRUNEFS="NFS nfs nfs4 rpc_pipefs afs binfmt_misc proc smbfs autofs iso9660 ncpfs coda devpts ftpfs devfs mfs shfs sysfs cifs lustre tmpfs usbfs udf fuse.glusterfs fuse.sshfs curlftpfs ecryptfs fusesmb devtmpfs"
```

You can update the  db by running `updatedb` as root.