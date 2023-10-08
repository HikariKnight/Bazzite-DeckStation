#!/usr/bin/env bash
set -oue pipefail

# Remove the autologin to gamescope-session
rm /usr/etc/sddm.conf.d/steamos.conf

# Remove virtual keyboard on SDDM
# as this image is for workstations and permanently docked steamdecks
rm /usr/etc/sddm.conf.d/virtualkbd.conf