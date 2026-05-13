#!/usr/bin/env bash
set -euo pipefail

VM_NAME="${1:-vm01-sles}"
DISK_NAME="${2:-vm01-disk}"
DISK_SIZE="${3:-20G}"
NODE="${4:-pc-site-a}"
ISO="${5:-/mnt/nfs/iso/SLE-12-SP5-Server-DVD-x86_64.iso}"

echo "Create LINSTOR disk: $DISK_NAME $DISK_SIZE"
linstor resource-group spawn-resources rg_vm "$DISK_NAME" "$DISK_SIZE"

echo "Make resource available on $NODE"
linstor resource make-available "$NODE" "$DISK_NAME"

DISK_PATH="/dev/drbd/by-res/$DISK_NAME/0"

echo "Check disk path: $DISK_PATH"
ls -l "$DISK_PATH"

echo "Create VM: $VM_NAME"
virt-install \
  --name "$VM_NAME" \
  --memory 2048 \
  --vcpus 2 \
  --cpu host \
  --disk path="$DISK_PATH",format=raw,bus=virtio \
  --cdrom "$ISO" \
  --network bridge=br0,model=virtio \
  --graphics vnc \
  --os-variant sles12sp5

echo "Export VM XML"
mkdir -p /mnt/nfs/templates
virsh dumpxml "$VM_NAME" > "/mnt/nfs/templates/${VM_NAME}.xml"

echo "Done"
