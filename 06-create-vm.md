# 06. Create VM

Tạo VM dùng disk từ LINSTOR/DRBD.

Ví dụ:

```text
VM name: vm01-sles
Disk:    vm01-disk
Node:    pc-site-a
```

---

## 1. Make disk available

Chạy trên `pc-site-a`:

```bash
linstor resource make-available pc-site-a vm01-disk
```

Kiểm tra:

```bash
ls -l /dev/drbd/by-res/vm01-disk/0
```

---

## 2. Tạo VM

Ví dụ ISO nằm ở NFS:

```text
/mnt/nfs/iso/SLE-12-SP5-Server-DVD-x86_64.iso
```

Lệnh:

```bash
virt-install \
  --name vm01-sles \
  --memory 2048 \
  --vcpus 2 \
  --cpu host \
  --disk path=/dev/drbd/by-res/vm01-disk/0,format=raw,bus=virtio \
  --cdrom /mnt/nfs/iso/SLE-12-SP5-Server-DVD-x86_64.iso \
  --network bridge=br0,model=virtio \
  --graphics vnc \
  --os-variant sles12sp5
```

---

## 3. Kiểm tra VM

```bash
virsh list --all
virsh dominfo vm01-sles
virsh domblklist vm01-sles
virsh domiflist vm01-sles
```

---

## 4. Lưu XML của VM

```bash
virsh dumpxml vm01-sles > /mnt/nfs/templates/vm01-sles.xml
```

File này dùng để define VM lại trên node khác khi failover.
