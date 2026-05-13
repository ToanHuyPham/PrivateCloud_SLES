# 01. Overview

## Mục tiêu hệ thống

Hệ thống dùng 3 server đặt ở 3 site khác nhau.

Mục tiêu chính:

- Có một cụm private cloud nhỏ.
- Tạo VM trên SLES bằng KVM/libvirt.
- Disk VM được replicate qua LINSTOR/DRBD.
- Có NFS để chứa ISO, template và backup.
- Khi node chính lỗi, có thể chuyển VM sang node khác bằng tay.

---

## Mô hình tối giản

```text
pc-site-a
  - Main node
  - LINSTOR Controller
  - NFS Server
  - KVM/libvirt
  - Có thể chạy VM

pc-site-b
  - LINSTOR Satellite
  - KVM/libvirt
  - Có thể chạy VM khi failover

pc-site-c
  - LINSTOR Satellite
  - KVM/libvirt
  - Giữ bản sao dữ liệu
```

---

## Vì sao không làm HA tự động ngay?

HA tự động cần:

- Pacemaker
- Corosync
- STONITH/Fencing
- VIP
- Resource ordering
- Test split-brain
- Test fencing
- Test failover/failback
