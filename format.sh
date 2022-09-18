DISK="/dev/sda"
set -x
parted -s $DISK -- mklabel gpt
parted -s $DISK -- mkpart primary 512MiB -8GiB
parted -s $DISK -- mkpart primary linux-swap -8GiB 100%
parted -s $DISK -- mkpart ESP fat32 1MiB 512MiB
parted -s $DISK -- set 3 esp on

echo "Final Result :"
parted --list

read -t 10 -p "Continue in 10 seconds..."

cryptsetup luksFormat "${DISK}1"
cryptsetup luksOpen "${DISK}1" nixos
mkfs.ext4 -L nixos /dev/mapper/nixos
mount /dev/mapper/nixos /mnt
mkswap -L swap "${DISK}2"
mkfs.fat -F 32 -n boot "${DISK}3"


mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
mkdir -p /mnt/etc/nixos
sudo nixos-generate-config --root --show-hardware-config --dir /mnt/etc/nixos/
read -t 10 -p "Copying Nix files in 10s.. CTRL+C to cancel"
sudo cp *.nix /mnt/etc/nixos/
