# 08. Backup

Replication không phải backup.

LINSTOR/DRBD giúp khi hỏng node/disk.  
Backup giúp khi:

- Xóa nhầm.
- Cấu hình sai.
- VM bị lỗi dữ liệu.
- Ransomware.
- Toàn cụm gặp sự cố.

---

## 1. Backup config

Chạy:

```bash
./scripts/backup-config.sh
```

Script sẽ backup:

```text
/etc/linstor
/etc/sysconfig
/etc/exports
VM XML
```

---

## 2. Backup VM XML thủ công

```bash
mkdir -p /mnt/nfs/backup/vm-xml

for vm in $(virsh list --all --name | grep -v '^$'); do
  virsh dumpxml "$vm" > /mnt/nfs/backup/vm-xml/${vm}.xml
done
```

---

## 3. Backup NFS

```bash
rsync -avh /srv/nfs/ /mnt/nfs/backup/nfs-copy/
```

---

## 4. Backup nên để ngoài cụm

Nên có thêm backup ngoài 3 node:

```text
NAS khác
Ổ cứng rời
Object storage
Server backup riêng
```

---

## 5. Test restore

Ít nhất mỗi tháng test:

```text
[ ] Restore VM XML
[ ] Restore file backup
[ ] Start thử VM test
[ ] Kiểm tra dữ liệu
```
