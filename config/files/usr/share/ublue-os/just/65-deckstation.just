# Include some of your custom scripts here!
selinux-looking-glass:
  sudo semanage fcontext -a -t svirt_tmpfs_t /dev/shm/looking-glass

hugetables-numa:
  printf "NODE=0\nPAGES=0\n" | sudo tee /etc/default/hugepages_numa
  sudo systemctl enable hugepages1g_numa
  echo Config written to /etc/default/hugepages_numa
  echo use this to change 1GB hugepages node location and reboot
  echo If the system does not have numa nodes, it will do nothing.
