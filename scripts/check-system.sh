#!/usr/bin/env bash
set -euo pipefail

echo "===== Host ====="
hostname
date

echo
echo "===== Network ====="
ip -br a || true
ip r || true

echo
echo "===== libvirt ====="
systemctl is-active libvirtd || true
virsh list --all || true

echo
echo "===== LINSTOR ====="
linstor node list || true
linstor storage-pool list || true
linstor resource list || true

echo
echo "===== DRBD ====="
cat /proc/drbd || true
drbdadm status || true

echo
echo "===== NFS ====="
df -h | grep -E 'nfs|Filesystem' || true
exportfs -v || true

echo
echo "===== Disk ====="
df -h
pvs || true
vgs || true
lvs || true
