# Include some of your custom scripts here!
selinux-looking-glass:
  sudo semanage fcontext -a -t svirt_tmpfs_t /dev/shm/looking-glass

hugetables-numa:
  echo '# This file is used when you enable hugepages1g.service' | sudo tee /etc/default/hugepages
  echo '# NODES=(nodenum1 nodenum2 nodenum3) remove nodes you do not want to reserve pages on, all systems have node 0' | sudo tee -a /etc/default/hugepages
  echo 'NODES=(0)' | sudo tee -a /etc/default/hugepages
  echo '# PAGES=5 means reserve 5GB RAM for hugepages on each node in NODES' | sudo tee -a /etc/default/hugepages
  echo 'PAGES=0' | sudo tee -a /etc/default/hugepages
  sudo systemctl enable hugepages1g
  echo 'Config written to /etc/default/hugepages'
  echo 'use this to change 1GB hugepages node locations and how many pages you want per node then reboot'
  echo 'You should not reserve more than half of your ram as hugepages unless you know what you are doing!'
