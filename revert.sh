# Debug
set -x

# load variables
source "/etc/libvirt/hooks/kvm.conf"

# unload vfio-pci
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# Rebind GPU
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

# rebind VTconsoles
echo 1 > /sys/class/vtconsole/vtcon0/bind

# Read nvidia x config
nvidia-xconfig --query-gpu-info > /dev/null 2>&1

# Bind EFI-framebuffer
echo "efi_framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# load nvidia
modprobe nvidia_drm
modprobe nvidia_modeset
modprobe drm_kms_helper
modprobe nvidia
modprobe drm
modprobe nvidia_uvm

# Restart Display service
systemctl start sddm.service
