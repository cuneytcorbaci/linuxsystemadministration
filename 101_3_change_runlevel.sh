#Runlevels define what tasks can be accomplished in the current state (or runlevel) of a Linux system. Think of it as different stages of *being alive*.
#SYSTEMD
#On systemd, we have different targets which are groups of services:

root@debian:~# systemctl list-units --type=target
  UNIT                LOAD   ACTIVE SUB    DESCRIPTION
---------------------------------------------------------
  basic.target        loaded active active Basic System
  cryptsetup.target   loaded active active Local Encrypted Volumes
  getty.target        loaded active active Login Prompts
  graphical.target    loaded active active Graphical Interface
  local-fs-pre.target loaded active active Local File Systems (Pre)
  local-fs.target     loaded active active Local File Systems
  multi-user.target   loaded active active Multi-User System
  network.target      loaded active active Network
  paths.target        loaded active active Paths
  remote-fs.target    loaded active active Remote File Systems
  slices.target       loaded active active Slices
  sockets.target      loaded active active Sockets
  sound.target        loaded active active Sound Card
  swap.target         loaded active active Swap
  sysinit.target      loaded active active System Initialization
  time-set.target     loaded active active System Time Set
  time-sync.target    loaded active active System Time Synchronized
  timers.target       loaded active active Timers


#And we can check the default one or get the status of each of them:

root@debian:~# systemctl get-default 
graphical.target

root@debian:~# systemctl status multi-user.target 
● multi-user.target - Multi-User System
     Loaded: loaded (/lib/systemd/system/multi-user.target; static)
     Active: active since Sat 2022-05-07 11:58:36 EDT; 4h 24min left
       Docs: man:systemd.special(7)

#It is also possible to *isolate* any of the targets or move to two special targets too:

1. `rescue`: Local file systems are mounted, there is no networking, and only root user (*maintenance* mode)
2. `emergency`: Only the root file system and in read-only mode, No networking and only root (*maintenance* mode)
3. `reboot`
4. `halt`: Stops all processes and halts CPU activities
5. `poweroff`: Like halt but also sends an ACPI shutdown signal (No lights!)


# systemctl isolate emergency
Welcome to emergency mode! After logging in, type "journalctl -xb" to view system logs, "systemctl reboot" to reboot, "systemctl default" or ^D to try again to boot into default mode.
Give root password for maintenance
(or type Control-D to continue):
#
# systemctl is-system-running
maintenance
#____________________________________________________________________________________________________________________________________________________________________________

#SysV runlevels
    #On SysV we were able to define different stages. On a Red Hat-based system we usually had 7:
- 0- Shutdown
- 1- Single-user mode (recovery); Also called S or s
- 2- Multi-user without networking
- 3- Multi-user with networking
- 4- to be customized by the admin
- 5- Multi-user with networking and graphics
- 6- Reboot

#And in Debian based system we had:
- 0- Shutdown
- 1- Single-user mode
- 2- Multi-user mode with graphics
- 6- Reboot

#Checking status and setting defaults
    #You can check your current runlevel with `runlevel` command. It comes from SysV era but still works on systemd systems. The default was in `/etc/inittab`

grep "^id:" /etc/inittab #on initV systems
id:5:initdefault:
    #It can also be done on grub kernel parameters.
    #Or using the runlevel and `telinit` command.

# runlevel
N 3
# telinit 5
# runlevel
3 5
# init 0 # shutdown the system !!


#You can find the files in `/etc/init.d` and runlevels in `/etc/rc[0-6].d` directories where S indicates Start and K indicates Kill.
#On systemd, you can find the configs in:

- `/etc/systemd`
- `/usr/lib/systemd/`

#/etc/inittab

Is being replaced by upstart and systemd but is still part of the exam.

######################################################################################
# inittab       This file describes how the INIT process should be set up
#               the system in a certain run-level.
#
# Author:       Miquel van Smoorenburg, <miquels@drinkel.nl.mugnet.org>
#               Modified for RHS Linux by Marc Ewing and Donnie Barnes
#

# Default runlevel. The runlevels used by RHS are:
#   0 - halt (Do NOT set initdefault to this)
#   1 - Single-user mode
#   2 - Multiuser, without NFS (The same as 3, if you do not have networking)
#   3 - Full multiuser mode
#   4 - unused
#   5 - X11
#   6 - reboot (Do NOT set initdefault to this)
#
id:5:initdefault:

# System initialization.
si::sysinit:/etc/rc.d/rc.sysinit

l0:0:wait:/etc/rc.d/rc 0
l1:1:wait:/etc/rc.d/rc 1
l2:2:wait:/etc/rc.d/rc 2
l3:3:wait:/etc/rc.d/rc 3
l4:4:wait:/etc/rc.d/rc 4
l5:5:wait:/etc/rc.d/rc 5
l6:6:wait:/etc/rc.d/rc 6

# Trap CTRL-ALT-DELETE
ca::ctrlaltdel:/sbin/shutdown -t3 -r now

# When our UPS tells us power has failed, assume we have a few minutes
# of power left.  Schedule a shutdown for 2 minutes from now.
# This does, of course, assume you have powered installed and your
# UPS connected and working correctly.
pf::powerfail:/sbin/shutdown -f -h +2 "Power Failure; System Shutting Down"

# If power was restored before the shutdown kicked in, cancel it.
pr:12345:powerokwait:/sbin/shutdown -c "Power Restored; Shutdown Cancelled"

# Run gettys in standard runlevels
1:2345:respawn:/sbin/mingetty tty1
2:2345:respawn:/sbin/mingetty tty2
3:2345:respawn:/sbin/mingetty tty3
4:2345:respawn:/sbin/mingetty tty4
5:2345:respawn:/sbin/mingetty tty5
6:2345:respawn:/sbin/mingetty tty6

# Run xdm in runlevel 5
x:5:respawn:/etc/X11/prefdm -nodaemon
########################################################################################

#This is the format:

id:runlevels:action:process

#- id: 2 or 3 chars
#- runlevels: Which runlevel this commands refers to (empty means all)
#- action: Respawn, wait, once, initdefault (default run level as seen above), ctrlaltdel (What to do with Ctrl+Alt+Delete)

#All scripts are here:
ls -ltrh /etc/init.d


#And start/stop on runlevels are controlled from these directories:

root@funlife:~# ls /etc/rc2.d/


#Stopping the System
#The preferred method to shut down or reboot the system is to use the `shutdown` command, which first sends a warning message to all logged-in users and blocks any further logins. 
#It then signals init to switch runlevels. The init process then sends all running processes a `SIGTERM` signal, giving them a chance to save data or otherwise properly terminate. 
#After 1 minute or another delay, if specified, init sends a `SIGKILL` signal to forcibly end each remaining process.

- Default is a 1-minute delay and then going to runlevel 1
- `h` will halt the system
- `r` will reboot the system
- Time is `hh:mm` or n (minutes) or now
- Whatever you add, will be broadcasted to logged-in users using the `wall` command
- If the command is running, ctrl+c or the `shutdown -c` will cancel it


shutdown -r 60 Reloading updated kernel


#for more advanced users
    #t60 will delay 60 seconds between SIGTERM and SIGKILL
    #if you cancel a shutdown, users won't get the news! you can use the "wall" command to tell them that the shutdown is canceled

#Advanced Configuration and Power Interface (ACPI)
    #ACPI provides an open standard that operating systems can use to discover and configure computer hardware components, perform power management (e.g. putting unused hardware components to sleep), perform auto-configuration (e.g. Plug and Play, and hot-swapping), and perform status monitoring.
    #This subsystem lets OS commands (like shutdown) send signals to the computer which results in powering down of the whole PC. In older times we used to have these mechanical keyboards to do a *real* power down after the OS has done its shutdown and told us that "it is not safe to power down your computer".

#Halt,Reboot and Poweroff
    # The `halt` command halts the system.
    # The `poweroff` command halts the system and then attempts to power it off.
    # The `reboot` command halts the system and then reboots it.
    # On most distros, these are symbolic links to the systemctl utility

#Notifying Users
    #It is good to be informed! Especially if the system is going down;
    #Especially on a shared server. Linux has different tools for system admins to notify their users:
- `wall`: Sending *wall messages* to logged-in users
- `/etc/issue`: Text to be displayed on the tty terminal logins (before login)
- `/etc/issue.net`: Text to be displayed on the remote terminal logins (before login)
- `/etc/motd`: Message of the day (after login). Some companies add "Do not enter if you are not allowed" texts here for legal reasons.
- `mesg`: Command controls if you want to get wall messages or not. You can do `mesg n` and `who -T` will show mesg status. Note that `shutdown` wall messages do not respect the `mesg` status
- systemctl sends wall messages for emergency, halt, power-off, reboot, and rescue
