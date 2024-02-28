#The Boot Process is Important.You should have a good understanding of what is happening.
    #1. Motherboard Firmware does a PowerOnSelfTest
    #2. Motherboard loads the bootloader
    #3. Bootloader loads the Linux Kernel-based on its configs/commands
    #4. The Kernel loads and prepares the system (root filesystem) and runs the initialization program
    #5. Init program start the service, other programs, ... (web server, graphical interface, networking, etc.)    

#UEFI (Unified Extensible Firmware Interface)**    
    # Specifies a special disk partition for the bootloader. Called EFI System Partition (ESP)
    # ESP is FAT and mounted on `/boot/efi` and bootloader files has .efi extensions
    # You can check `/sys/firmware/efi` to see if you are using a UEFI system or not.

#Kernel
    #The Kernel is the core of your operating system, the LINUX itself. Your bootloader loads the kernel in the memory and runs it. 
    #But kernel needs some initial info to start; Things like drivers are necessary to work with the hardware. 
    #Those are stored in `initrd` or `initramfs` alongside the kernel and used during the boot. 
    #You can also send parameters to the kernel during the boot using the Grub configs. 
    #For example, sending a 1 or S will result the system booting in single-user mode (recovery). 
    #Or you can force your graphics to work in 1024×768x24 mode by passing `vga=792` to the Kernel during the boot.

#initramfs (Inıtialization Ram File System)
    #Kernel's load spesific data system and It has a file which is called initramfs. 
    #It’s like a disk in the memory which has some drivers some needed things for the kernel to start. 
    #So when the system boots firmwire loads the bootloader, bootloader loads the kernel,and gives it the initramfs so now kernel knows how to control the hardware it can start everything and run everything from here. 
    #Inıt runs initializes everything else you need like webservers like network time protocol etc. 

#dmesg
#Linux will show you the boot process logs during the boot. Some desktop systems hide this behind a fancy boot splash which you can hide using the Esc key or press Ctrl+Alt+F1. 
#dmesg command will show the full data from **kernel ring buffer** up to now. But `cat /var/log/dmesg` will show only the data during the boot.
#We can also use `journalctl -k` to check Kernel logs or use `journalctl -b` to check for boot logs (or even use `journalctl -u kernel` to see all previous logs too).
#In addition to these, most systems keep the boot logs in a text-like file too. Under Debian-based systems, it's called `/var/log/boot` and for RedHat-based systems, it's `/var/log/boot.log`.

ccorbaci@B166ER:~$ cat /var/log/messages

#After the init process comes up, syslog daemon will log messages. It has timestamps and will persist during restarts.
#- The Kernel is still logging its messages in dmesg
#- in some systems, it might be called `/var/log/syslog`
#- there are many other logs at `/var/log`

#init
    #When the Kernel finished its initialization, its time to start other programs. 
    #To do so, the Kernel runs the Initialization Daemon process, and it takes care of starting other daemons, services, subsystems and programs. 
    #Using the init system one can say "I need service A and then service B. Then I need C and D and E but do not start D unless the A and B are running".
    #The system admin can use the init system to stop and start the services later.

#There are different init systems:

#SysVinit
    #is based on Unix System V. Not being used much but people loved it and you may see it on older machines or even on recently installed ones
    #Is the older init system. Still can be used on many systems. The control files are located at `/etc/init.d/` and are closer to the general bash scripts.
    #In many cases you can call like:

/etc/init.d/ntpd status
/etc/init.d/ntpd stop
/etc/init.d/ntpd start
/etc/init.d/ntpd restart

#systemd
    #Is the new replacement. Some people hate it but it is being used by all the major distros. Can start services in parallel and do lots of fancy stuff!
    #Is new, loved, and hated. Lots of new ideas but not following some of  the beloved UNIX principles (say.. not saving logs in a text file or trying to help you too much but asking for the root password when you are not running commands with sudo). 
    #It lets us run services if the hardware is connected, in time intervals, if nother service is started, and ...
    #The systemd is made around **unit**s. A unit can be a service, group of services, or an action. Units do have a name, a type, and a configuration file.
    #There are 12 unit types: automount, device, mount, path, scope, service, slice, snapshot, socket, swap, target & timer.
    #We use `systemctl` to work with these units and `journalctl` to see the logs.

#UpStart
    #was an event-based replacement for the traditional init daemon. The project was started in 2014 by Canonical (the company behind Ubuntu) to replace the SysV but did not continue after 2015 and Ubuntu is now using the systemd as its init system.

ccorbaci@cuneytnote:~$ which init
/usr/sbin/init
ccorbaci@cuneytnote:~$ readlink -f /usr/sbin/init
/usr/lib/systemd/systemd


ccorbaci@cuneytnote:~$ ps -p 1
    PID TTY          TIME CMD
      1 ?        00:00:02 systemd
