#sysfs is a pseudo file system provided by the Linux kernel. 
 #In addition to providing information about various devices and kernel subsystems, exported virtual files are also used for their configuration.
 #Sysfs is mounted under the /sys mount point.

 ls /sys
 block  bus  class  dev  devices  firmware  fs  hypervisor  kernel  module  power

 #All block devices are at the block and bus directory has all the connected PCI, USB, serial, ... devices. Note that here in sys we have the devices based on their 
 #technology but /dev/ is abstracted.

#udev
 # udev (userspace `/dev`) is a device manager for the Linux kernel. As the successor of devfsd and hotplug, udev primarily manages device nodes in the `/dev`  directory. 
 #At the same time, udev also handles all user space events raised when hardware devices are added into the system or removed from it, including firmware loading as required by certain devices.
 #There are a lot of devices in `/dev/` and if you plug in any device, it will be assigned a file in `/dev` (say `/dev/sdb2`). udev lets you control what will be what in `/dev`. 
 #In essence, udev serves as the custodian of the `/dev/` directory. It abstracts the representation of devices, such as a hard disk, which is identified as `/dev/sda` or `/dev/hd0`, irrespective of its manufacturer, model, or underlying technology.

#/proc
 #This is where the Kernel keeps its settings and properties. 
 #This directory is created on ram and files might have write access (say for some hardware configurations). You can find things like:
  # IRQs (interrupt requests)
  #I/O ports (locations in memory where CPU can talk with devices)
  #DMA (direct memory access, faster than I/O ports)
  #Processes
  #Network Settings …

#lsusb, lspci, lsblk, lshw,lsmod
 #Just like `ls` but for pci, usb, ...
