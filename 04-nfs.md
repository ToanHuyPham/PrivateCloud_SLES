# 04. NFS

Trong mô hình đơn giản, `pc-site-a` làm NFS Server.

NFS dùng để lưu:

- ISO
- Template
- VM XML
- Backup config
- Script

---

## 1. Cài NFS trên pc-site-a

Chạy trên `pc-site-a`:

```bash
zypper install -y nfs-kernel-server
```

---

## 2. Tạo thư mục NFS

```bash
mkdir -p /srv/nfs/iso
mkdir -p /srv/nfs/templates
mkdir -p /srv/nfs/backup
chmod -R 755 /srv/nfs
```

---

## 3. Cấu hình export

File:

```bash
vim /etc/exports
```

Nội dung:

```text
/srv/nfs/iso       10.10.10.0/24(ro,sync,no_subtree_check,no_root_squash)
/srv/nfs/templates 10.10.10.0/24(rw,sync,no_subtree_check,no_root_squash)
/srv/nfs/backup    10.10.10.0/24(rw,sync,no_subtree_check,no_root_squash)
```

Apply:

```bash
exportfs -rav
systemctl enable --now nfsserver
exportfs -v
```

---

## 4. Mount NFS trên cả 3 node

```bash
mkdir -p /mnt/nfs/iso
mkdir -p /mnt/nfs/templates
mkdir -p /mnt/nfs/backup
```

Mount:

```bash
mount -t nfs pc-site-a:/srv/nfs/iso /mnt/nfs/iso
mount -t nfs pc-site-a:/srv/nfs/templates /mnt/nfs/templates
mount -t nfs pc-site-a:/srv/nfs/backup /mnt/nfs/backup
```

Kiểm tra:

```bash
df -h | grep nfs
```

---

## 5. Auto mount

Thêm vào `/etc/fstab` trên cả 3 node:

```text
pc-site-a:/srv/nfs/iso       /mnt/nfs/iso       nfs defaults,_netdev 0 0
pc-site-a:/srv/nfs/templates /mnt/nfs/templates nfs defaults,_netdev 0 0
pc-site-a:/srv/nfs/backup    /mnt/nfs/backup    nfs defaults,_netdev 0 0
```

Test:

```bash
mount -a
df -h | grep nfs
```

---

## Ghi chú

Mô hình này NFS chưa HA. Nếu `pc-site-a` lỗi thì NFS mất.

Vì đây là bản đơn giản cho 1 người, chấp nhận trước. Sau này nâng cấp bằng:

```text
Pacemaker + VIP + replicated NFS volume
```
