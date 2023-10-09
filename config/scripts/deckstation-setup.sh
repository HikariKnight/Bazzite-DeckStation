#!/usr/bin/env bash
set -oue pipefail

# Remove the autologin to gamescope-session
rm /usr/etc/sddm.conf.d/steamos.conf

# Remove virtual keyboard on SDDM
# as this image is for workstations and permanently docked steamdecks
rm /usr/etc/sddm.conf.d/virtualkbd.conf

# Add deckstation justfile to 60-custom.just
echo '!include /usr/share/ublue-os/just/65-deckstation.just' >> /usr/share/ublue-os/just/60-custom.just

# Create SELinux context so libvirt can use looking-glass shm
semanage fcontext -a -t svirt_tmpfs_t /dev/shm/looking-glass
