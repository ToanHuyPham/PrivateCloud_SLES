# 07. Manual Failover

Mục tiêu: chuyển VM từ node này sang node khác bằng tay.

Ví dụ:

```text
VM: vm01-sles
Disk: vm01-disk
Từ: pc-site-a
Sang: pc-site-b
```

---

## 1. Shutdown VM trên node cũ

Trên `pc-site-a`:

```bash
virsh shutdown vm01-sles
```

Nếu không tắt được:

```bash
virsh destroy vm01-sles
```

---

## 2. Make disk available trên node mới

Chạy từ node có `linstor-client`, thường là `pc-site-a`:

```bash
linstor resource make-available pc-site-b vm01-disk
```

---

## 3. Kiểm tra disk trên node mới

Trên `pc-site-b`:

```bash
ls -l /dev/drbd/by-res/vm01-disk/0
```

---

## 4. Define VM trên node mới

Trên `pc-site-b`:

```bash
virsh define /mnt/nfs/templates/vm01-sles.xml
```

Kiểm tra disk path trong XML:

```bash
virsh domblklist vm01-sles
```

---

## 5. Start VM trên node mới

```bash
virsh start vm01-sles
```

Kiểm tra:

```bash
virsh list --all
virsh dominfo vm01-sles
```

---

## 6. Ghi chú quan trọng

Không chạy cùng một VM disk trên 2 node cùng lúc.

Không mount cùng một DRBD block device ở nhiều node nếu dùng filesystem thường như EXT4/XFS.

Failover thủ công cần kiểm tra kỹ:

```bash
linstor resource list
cat /proc/drbd
virsh list --all
```
