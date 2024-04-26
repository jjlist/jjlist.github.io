#!bin/sh -eux
echo =================
lsblk
echo =================
disk="$1"
parted $disk -- mklabel gpt
parted $disk -- mkpart ESP fat32 1MiB 513MiB
parted $disk -- set 1 esp on
parted $disk -- mkpart home ext4 -300GiB 100%
parted $disk -- mkpart root ext4 513MiB 100% #-8GB
#parted $disk -- mkpart swap linux-swap -8GB 100%
lsblk
echo =================
mkfs.ext4 -L NIXOS "$disk"3
mount /dev/disk/by-label/NIXOS /mnt
mkfs.ext4 -L NIXHOME "$disk"2
mount /dev/disk/by-label/NIXHOME /mnt/home
#mkswap -L NIXSWAP "$disk"2
#swapon "$disk"2
mkfs.fat -F 32 -n NIXBOOT "$disk"1
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/NIXBOOT /mnt/boot
lsblk
echo =================
#
nixos-generate-config --root /mnt
read -p "Disks partition succesfully, press any key to edit configuration.nix..."
vim /mnt/etc/nixos/configuration.nix
# nixos-install
# reboot
