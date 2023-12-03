# Apply selinux context for looking-glass
selinux-looking-glass:
    sudo semanage fcontext -a -t svirt_tmpfs_t /dev/shm/looking-glass

# Enable Virtualization and add workaround for a specific windows VM crash
enable-virtualization:
    echo "Installing QEMU and virt-manager..."
    rpm-ostree install virt-manager edk2-ovmf qemu
    rpm-ostree kargs \
    --append-if-missing="kvm.ignore_msrs=1" \
    --append-if-missing="kvm.report_ignored_msrs=0"

# Enable VFIO on the system if virtualization is enabled
enable-vfio:
    #!/usr/bin/env bash
    echo "Enabling VFIO..."
    VIRT_TEST=$(rpm-ostree kargs)
    CPU_VENDOR=$(grep "vendor_id" "/proc/cpuinfo" | uniq | awk -F": " '{ print $2 }')
    VENDOR_KARG="unset"
    INITRAMFS_ARGS=$(rpm-ostree status | grep -m 1 Initramfs | perl -pe "s/\s+(Initramfs: regenerate|Initramfs:)//" | perl -pe "s/ \'/--arg='/")
    if [[ ${VIRT_TEST} == *kvm.report_ignored_msrs* ]]; then
      echo 'add_drivers+=" vfio vfio_iommu_type1 vfio-pci "' | sudo tee /etc/dracut.conf.d/vfio.conf
      echo $(($(cat /etc/bazzite/hws_version)-1)) | sudo tee /etc/bazzite/hws_version
      rpm-ostree initramfs --enable $INITRAMFS_ARGS
      if [[ ${CPU_VENDOR} == "AuthenticAMD" ]]; then
        VENDOR_KARG="amd_iommu=on"
      elif [[ ${CPU_VENDOR} == "GenuineIntel" ]]; then
        VENDOR_KARG="intel_iommu=on"  
      fi
      if [[ ${VENDOR_KARG} == "unset" ]]; then
        echo "Failed to get CPU vendor, exiting..."
        exit 1
      else
        rpm-ostree kargs \
          --append-if-missing="${VENDOR_KARG}" \
          --append-if-missing="iommu=pt" \
          --append-if-missing="rd.driver.pre=vfio_pci" \
          --append-if-missing="vfio_pci.disable_vga=1" \
        echo "VFIO enabled, make sure you enable IOMMU, VT-d or AMD-v in your BIOS!"
        echo "Please understand that since this is such a niche use case, support will be very limited!"
        echo "To add your unused/second GPU device ids to the vfio driver by running"
        echo 'rpm-ostree kargs --append-if-missing="vfio-pci.ids=xxxx:yyyy,xxxx:yyzz"'
        echo "NOTE: Your second GPU will not be usable by the host after you do this!"
      fi
    else
      echo "Enable virtualization with just enable-virtualization before running just enable-vfio."
    fi
