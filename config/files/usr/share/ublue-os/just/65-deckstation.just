# Include some of your custom scripts here!
selinux-looking-glass:
  sudo semanage fcontext -a -t svirt_tmpfs_t /dev/shm/looking-glass
