#!/bin/bash

# This file downloads the 20.04 Ubuntu Desktop ISO and customizes
# it for the Quori Robot. It then repacks the ISO.

wget -Nc http://old-releases.ubuntu.com/releases/focal/ubuntu-20.04-desktop-amd64.iso -O /tmp/ubuntu-20.04-desktop-amd64.iso

# Mount the Desktop .iso
mkdir mnt
sudo mount -o loop /tmp/ubuntu-20.04-desktop-amd64.iso mnt

# Extract .iso contents into dir 'extract-cd'
mkdir extract-cd
sudo rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd

# Extract the SquashFS filesystem
sudo unsquashfs mnt/casper/filesystem.squashfs
sudo mv squashfs-root edit

sudo mount -o bind /run/ edit/run
sudo mount --make-rslave edit/run

sudo mount --rbind /dev/ edit/dev
sudo mount --make-rslave edit/dev

sudo cp chroot.sh edit

# Chroot
sudo chroot edit /bin/bash -c "su - -c /chroot.sh"

sudo cp setup.bash edit/opt/quori

sudo cp 49-teensy.rules edit/etc/udev/rules.d/
sudo cp 56-orbbec-usb.rules edit/etc/udev/rules.d/
sudo cp 59-rplidar.rules edit/etc/udev/rules.d/
sudo cp 60-respeaker.rules edit/etc/udev/rules.d/

sudo umount edit/run
sudo umount -R edit/dev

# Build ISO

# Regenerate manifest
sudo chmod +w extract-cd/casper/filesystem.manifest
sudo chroot edit /bin/bash -c "su - -c dpkg-query -W --showformat='${Package} ${Version}\n' > extract-cd/casper/filesystem.manifest"
sudo cp extract-cd/casper/filesystem.manifest extract-cd/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' extract-cd/casper/filesystem.manifest-desktop
sudo sed -i '/casper/d' extract-cd/casper/filesystem.manifest-desktop

# Compress filesystem
sudo rm extract-cd/casper/filesystem.squashfs
sudo mksquashfs edit extract-cd/casper/filesystem.squashfs -b 1048576

# Update the filesystem.size file, which is needed by the installer:
sudo printf $(du -sx --block-size=1 edit | cut -f1) > extract-cd/casper/filesystem.size

# Remove old md5sum.txt and calculate new md5 sums
cd extract-cd
sudo rm md5sum.txt
find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sum.txt

# Create the ISO image
sudo mkisofs -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../Qubuntu-20.04-desktop-amd64-$(jq -r .version manifest.json).iso .

cd -


# Cleanup
sudo umount mnt
sudo rm -rf extract-cd edit mnt squashfs-root
