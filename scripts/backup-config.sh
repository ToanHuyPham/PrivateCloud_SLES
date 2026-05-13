#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/mnt/nfs/backup/config"
DATE="$(date +%F-%H%M%S)"

mkdir -p "$BACKUP_DIR"

tar czf "$BACKUP_DIR/etc-linstor-$DATE.tar.gz" /etc/linstor 2>/dev/null || true
tar czf "$BACKUP_DIR/etc-sysconfig-$DATE.tar.gz" /etc/sysconfig 2>/dev/null || true
cp /etc/exports "$BACKUP_DIR/exports-$DATE" 2>/dev/null || true

mkdir -p "$BACKUP_DIR/vm-xml-$DATE"

for vm in $(virsh list --all --name | grep -v '^$'); do
  virsh dumpxml "$vm" > "$BACKUP_DIR/vm-xml-$DATE/$vm.xml"
done

tar czf "$BACKUP_DIR/vm-xml-$DATE.tar.gz" -C "$BACKUP_DIR" "vm-xml-$DATE"
rm -rf "$BACKUP_DIR/vm-xml-$DATE"

echo "Backup saved to $BACKUP_DIR"
