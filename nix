#!bin/sh -eux
echo =================
lsblk
echo =================
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MiB 513MiB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart home ext4 -300GiB 100%
parted /dev/sda -- mkpart root ext4 513MiB 100%
lsblk
echo =================
mkfs.ext4 -L nixos /dev/sda3
mount /dev/disk/by-label/nixos /mnt
mkfs.ext4 -L home /dev/sda2
mkdir -p /mnt/home
mount /dev/disk/by-label/home /mnt/home
mkfs.fat -F 32 -n boot /dev/sda1
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
lsblk
echo =================
#
nixos-generate-config --root /mnt
read -p "Disks partitioned, press any key to edit configuration.nix..."
vim /mnt/etc/nixos/configuration.nix
# nixos-install
