# Include some of your custom scripts here!
selinux-looking-glass:
  sudo semanage fcontext -a -t svirt_tmpfs_t /dev/shm/looking-glass

hugetables-numa:
  echo '# This file is used when you enable hugepages1g_numa.service' | sudo tee /etc/default/hugepages_numa
  echo '# NODES=(nodenum1 nodenum2 nodenum3) remove nodes you do not want to reserve pages on' | sudo tee -a /etc/default/hugepages_numa
  echo 'NODES=(0 1)' | sudo tee -a /etc/default/hugepages_numa
  echo '# PAGES=5 means reserve 5GB RAM for hugepages on each node in NODES' | sudo tee -a /etc/default/hugepages_numa
  echo 'PAGES=0' | sudo tee -a /etc/default/hugepages_numa
  sudo systemctl enable hugepages1g_numa
  echo Config written to /etc/default/hugepages_numa
  echo use this to change 1GB hugepages node locations and how many pages you want per node then reboot
  echo If the system does not have numa nodes, it will do nothing.
