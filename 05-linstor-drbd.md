# 05. LINSTOR / DRBD

LINSTOR dùng để quản lý DRBD replicated block storage.

Trong mô hình này:

```text
pc-site-a = LINSTOR Controller + Satellite
pc-site-b = Satellite
pc-site-c = Satellite
```

---

## 1. Cài package

Chạy trên cả 3 node:

```bash
zypper install -y lvm2 drbd-utils linstor-satellite
```

Chạy riêng trên `pc-site-a`:

```bash
zypper install -y linstor-controller linstor-client
```

---

## 2. Start service

Trên cả 3 node:

```bash
systemctl enable --now linstor-satellite
```

Trên `pc-site-a`:

```bash
systemctl enable --now linstor-controller
```

Kiểm tra:

```bash
linstor node list
```

---

## 3. Tạo LINSTOR node

Chạy trên `pc-site-a`:

```bash
linstor node create pc-site-a 10.10.20.11 --node-type Combined
linstor node create pc-site-b 10.10.20.12 --node-type Satellite
linstor node create pc-site-c 10.10.20.13 --node-type Satellite
```

Kiểm tra:

```bash
linstor node list
```

---

## 4. Chuẩn bị disk storage

Chạy trên cả 3 node.

Ví dụ dùng `/dev/sdb`.

> Kiểm tra kỹ, không wipe nhầm disk OS.

```bash
lsblk
```

Làm sạch disk:

```bash
wipefs -a /dev/sdb
sgdisk --zap-all /dev/sdb
partprobe /dev/sdb
```

Tạo LVM:

```bash
pvcreate /dev/sdb
vgcreate vg_linstor /dev/sdb
lvcreate -l 90%FREE -T vg_linstor/thinpool
```

Kiểm tra:

```bash
pvs
vgs
lvs
```

---

## 5. Tạo storage pool

Chạy trên `pc-site-a`:

```bash
linstor storage-pool create lvmthin pc-site-a sp_linstor vg_linstor/thinpool
linstor storage-pool create lvmthin pc-site-b sp_linstor vg_linstor/thinpool
linstor storage-pool create lvmthin pc-site-c sp_linstor vg_linstor/thinpool
```

Kiểm tra:

```bash
linstor storage-pool list
```

---

## 6. Tạo resource group

Mặc định tạo 3 bản sao:

```bash
linstor resource-group create rg_vm \
  --storage-pool=sp_linstor \
  --place-count=3
```

Tạo volume group:

```bash
linstor volume-group create rg_vm
```

Kiểm tra:

```bash
linstor resource-group list
linstor volume-group list
```

---

## 7. Bật quorum cơ bản

```bash
linstor controller set-property DrbdOptions/Resource/quorum majority
linstor controller set-property DrbdOptions/Resource/on-no-quorum io-error
```

---

## 8. Tạo volume VM

Ví dụ tạo disk VM 20GB:

```bash
linstor resource-group spawn-resources rg_vm vm01-disk 20G
```

Kiểm tra:

```bash
linstor resource list
linstor volume list
```

Make available trên node muốn chạy VM:

```bash
linstor resource make-available pc-site-a vm01-disk
```

Kiểm tra device:

```bash
ls -l /dev/drbd/by-res/vm01-disk/0
```

---

## Lệnh kiểm tra quan trọng

```bash
linstor node list
linstor storage-pool list
linstor resource list
linstor volume list
cat /proc/drbd
drbdadm status
```
