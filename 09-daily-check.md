# 09. Daily Check

Dành cho 1 người vận hành.

---

## 1. Chạy script kiểm tra nhanh

```bash
./scripts/check-system.sh
```

---

## 2. Kiểm tra thủ công

### LINSTOR

```bash
linstor node list
linstor storage-pool list
linstor resource list
```

### DRBD

```bash
cat /proc/drbd
drbdadm status
```

### VM

```bash
virsh list --all
```

### NFS

```bash
df -h | grep nfs
exportfs -v
```

### Disk

```bash
df -h
pvs
vgs
lvs
```

---

## 3. Checklist hằng ngày

```text
[ ] 3 node ping được nhau
[ ] LINSTOR node online
[ ] Resource không lỗi
[ ] DRBD không split-brain
[ ] VM quan trọng đang chạy
[ ] NFS mount được
[ ] Disk chưa đầy
[ ] Backup config gần nhất còn mới
```

---

## 4. Checklist hằng tuần

```text
[ ] Test backup config
[ ] Kiểm tra dung lượng storage
[ ] Kiểm tra log lỗi
[ ] Test manual failover với VM test
[ ] Cập nhật tài liệu nếu có thay đổi
```
