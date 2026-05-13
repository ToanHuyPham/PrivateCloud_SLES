# 02. IP Plan

## Hostname

| Site | Hostname |
|---|---|
| Site A | `pc-site-a` |
| Site B | `pc-site-b` |
| Site C | `pc-site-c` |

## IP đơn giản

| Node | Management | Storage |
|---|---|---|
| `pc-site-a` | `10.10.10.11` | `10.10.20.11` |
| `pc-site-b` | `10.10.10.12` | `10.10.20.12` |
| `pc-site-c` | `10.10.10.13` | `10.10.20.13` |

## Network

| Network | CIDR | Dùng cho |
|---|---|---|
| Management | `10.10.10.0/24` | SSH, NFS, libvirt, quản lý |
| Storage | `10.10.20.0/24` | LINSTOR/DRBD replication |

> Để đơn giản, ban đầu chỉ cần 2 network. Sau này có thể tách thêm VM network, backup network.

---

## `/etc/hosts`

Thêm trên cả 3 node:

```bash
cat >> /etc/hosts <<'EOF'
10.10.10.11 pc-site-a
10.10.10.12 pc-site-b
10.10.10.13 pc-site-c

10.10.20.11 pc-site-a-storage
10.10.20.12 pc-site-b-storage
10.10.20.13 pc-site-c-storage
EOF
```

Kiểm tra:

```bash
ping -c 3 pc-site-a
ping -c 3 pc-site-b
ping -c 3 pc-site-c

ping -c 3 pc-site-a-storage
ping -c 3 pc-site-b-storage
ping -c 3 pc-site-c-storage
```

---

## Gợi ý đặt IP

Nếu chưa có nhiều VLAN, có thể dùng tạm một dải mạng:

```text
10.20.20.11 pc-site-a
10.20.20.12 pc-site-b
10.20.20.13 pc-site-c
```

Nhưng production nên tách management và storage network.
