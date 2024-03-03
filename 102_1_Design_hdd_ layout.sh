#Filesystem Hierarchy Standard (FHS)
    -----------------------------------------------------------------
    | Directory | Description                                       |
    | ---       | ---                                               |
    | bin       | Essential command binaries                        |
    | boot      | Static files of the boot loader                   |
    | dev       | Device files                                      |
    | etc       | Host-specific system configuration                |
    | home      | Home directory of the users                       |
    | lib       | Essential shared libraries and kernel modules     |
    | media     | Mount point for removable media                   |
    | mnt       | Mount point for mounting a filesystem temporarily |
    | opt       | Add-on application software packages              |
    | root      | Home directory of the root user                   |
    | sbin      | Essential system binaries                         |
    | srv       | Data for services provided by this system         |
    | tmp       | Temporary files, sometimes purged on each boot    |
    | usr       | Secondary hierarchy                               |
    | var       | Variable data (logs, ...)                         |
    -----------------------------------------------------------------

#Partitions
    #Devices are defined at /dev/.
    #First SATA or SCSI disks you will have /dev/sda, 
    #For newer NVME drives you can see /dev/nvme0 and partitions are available as /dev/nvme0n1, 
    #For the 3rd PATA (super old) disk you will see /dev/hdc, also for SD/eMMC/bare NAND/NOR devices you will have /dev/mmcblk0 and partitions are seen as /dev/mmcblk0p0.
    #You have to PARTITION the disks, that is create smaller parts on a big disk. These are self-contained sections on the main drive. OS sees these as standalone disks.  
    #We call them /dev/sd**a**1 (first partition of the first SCSI disk) or /dev/hd**b**3 (3rd partition on the second disk).
    #BIOS systems were using MBR and could have up to 4 partitions on each  disk, although instead of creating 4 Primary partitions, you could create an Extended partition and define more Logical partitions inside it.
    #UEFI systems use GUID Partition Table (GPT) which supports 128 partitions on each device.
    #Linux systems can **mount** these partitions on different paths. Say you can have a separated disk with one huge partition for your `/home` and another one for your /var/logs/.

    fdisk /dev/sda

        Welcome to fdisk (util-linux 2.25.1).
        Changes will remain in memory only, until you decide to write them.
        Be careful before using the write command.

        Command (m for help): p
        Disk /dev/sda: 298.1 GiB, 320072933376 bytes, 625142448 sectors
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        Disklabel type: dos
        Disk identifier: 0x000beca1

        Device     Boot     Start       End   Sectors   Size Id Type
        /dev/sda1  *         2048  43094015  43091968  20.6G 83 Linux
        /dev/sda2        43094016  92078390  48984375  23.4G 83 Linux
        /dev/sda3        92080126 625141759 533061634 254.2G  5 Extended
        /dev/sda5        92080128 107702271  15622144   7.5G 82 Linux swap / Solaris
        /dev/sda6       107704320 625141759 517437440 246.8G 83 Linux

    #The newer **GUID Partition Table (or GPT)** solves these problems. If you format your disk with GPT you can have 128 primary partitions (no need for extended and logical).

#Commands
    #parted

    sudo parted /dev/sda p
        Model: ATA ST320LT000-9VL14 (scsi)
        Disk /dev/sda: 320GB
        Sector size (logical/physical): 512B/512B
        Partition Table: msdos
        Disk Flags:
    
        Number  Start   End     Size    Type      File system     Flags
        1      1049kB  22.1GB  22.1GB  primary   ext4            boot
        2      22.1GB  47.1GB  25.1GB  primary   ext4
        3      47.1GB  320GB   273GB   extended
        5      47.1GB  55.1GB  7999MB  logical   linux-swap(v1)
        6      55.1GB  320GB   265GB   logical
        
    Note: parted does not understands GPT
    
    #fdisk

    sudo fdisk /dev/sda
        [sudo] password for ccorbaci:

        Welcome to fdisk (util-linux 2.25.1).
        Changes will remain in memory only, until you decide to write them.
        Be careful before using the write command.

        Command (m for help): p
        Disk /dev/sda: 298.1 GiB, 320072933376 bytes, 625142448 sectors
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        Disklabel type: dos
        Disk identifier: 0x000beca1

        Device     Boot     Start       End   Sectors   Size Id Type
        /dev/sda1  *         2048  43094015  43091968  20.6G 83 Linux
        /dev/sda2        43094016  92078390  48984375  23.4G 83 Linux
        /dev/sda3        92080126 625141759 533061634 254.2G  5 Extended
        /dev/sda5        92080128 107702271  15622144   7.5G 82 Linux swap / Solaris
        /dev/sda6       107704320 625141759 517437440 246.8G 83 Linux


#LVM
    #You need to resize your partitions or even install new disks and *add* them to your current mount points; Increasing the total size. LVM is designed for this.
    #LVM helps you create one partition from different disks and add or remove space to them. The main concepts are:
        #- Physical Volume (PV): A whole drive or a partition. It is better to define partitions and **not use whole disks - unpartitioned**.
        #- Volume Groups (VG): This is the collection of one or more **PV**s. OS will see the vg as one big disk. PVs in one VG, can have different sizes or even be on different physical disks.
        #- Logical Volumes (LV): OS will see lvs as partitions. You can format an LV with your OS and use it.

#Design Hard disk layout
    #Disk layout and allocation partitions to directories depend on your usage. First, we will discuss *swap* and *boot* and then will see three different cases.

    #swap
        #Swap in Linux works like an extended memory. The Kernel will *page* memory to this partition/file. It is enough to format one partition with **swap file system** and define it in /etc/fstab.
        #Note: There is no strict formula for swap size. People used to say "double the ram but not more than 8GB". On recent machines with SSDs,some say "RAM + 2" (Hibernation + some extra ) or "RAM * 2" depending on your usage.

    #/boot
        #Older Linux systems were not able to handle HUGE disks during the boot (say Terabytes) so there was a separated **/boot**. It is also useful to recover broken systems or even you can make /boot read-only. Most of the time, having 100MB for `/boot` is enough. 
        #This can be a different disk or a separated partition.
        #This partition should be accessible by BIOS/UEFI during the boot (No network drive).
        #On UEFI systems, there is a **/boot/efi** mount point called
        #EFI (Extensible Firmware Interface) system partition or ESP. Thiscontains the bootloader and kernel and should be accessible by the UEFI firmware during the boot.