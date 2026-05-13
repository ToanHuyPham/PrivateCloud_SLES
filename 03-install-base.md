# 03. Install Base

Làm trên cả 3 node.

---

## 1. Đặt hostname

Site A:

```bash
hostnamectl set-hostname pc-site-a
```

Site B:

```bash
hostnamectl set-hostname pc-site-b
```

Site C:

```bash
hostnamectl set-hostname pc-site-c
```

---

## 2. Cài công cụ cơ bản

```bash
zypper install -y vim curl wget rsync tar gzip lsof tcpdump sysstat chrony
```

---

## 3. Bật đồng bộ thời gian

```bash
systemctl enable --now chronyd
chronyc sources
```

---

## 4. Cài KVM/libvirt

```bash
zypper install -y qemu-kvm libvirt virt-install bridge-utils
```

Enable:

```bash
systemctl enable --now libvirtd
```

Kiểm tra:

```bash
lsmod | grep kvm
virsh list --all
```

---

## 5. Kiểm tra disk storage

```bash
lsblk
```

Ví dụ:

```text
/dev/sda = OS
/dev/sdb = storage cho LINSTOR
```

> Không dùng disk OS làm LINSTOR storage.
