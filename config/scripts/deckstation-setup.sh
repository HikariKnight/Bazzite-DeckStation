#!/usr/bin/env bash
set -oue pipefail

# Remove the autologin to gamescope-session
rm /usr/etc/sddm.conf.d/steamos.conf