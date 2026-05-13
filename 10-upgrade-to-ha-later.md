# 10. Upgrade to HA Later

Sau khi MVP chạy ổn, có thể nâng cấp HA.

Không nên làm HA ngay nếu chưa hiểu rõ NFS, LINSTOR, DRBD và failover thủ công.

---

## Giai đoạn nâng cấp

### Phase 1: MVP

```text
NFS single primary
LINSTOR/DRBD replicate
Manual failover
Backup script
Daily check
```

### Phase 2: Monitoring

```text
Prometheus/Zabbix
Grafana
Alert
Log collection
```

### Phase 3: NFS HA

```text
NFS data trên LINSTOR volume
Pacemaker quản lý:
- Filesystem
- NFS service
- VIP
```

### Phase 4: Fencing

```text
IPMI/iDRAC/iLO/IMM fencing
STONITH test
Split-brain protection
```

### Phase 5: Semi-auto failover

```text
Pacemaker resource cho NFS
VM vẫn manual hoặc dùng script
```

---

## Khi nào nên HA thật?

Khi đã có:

```text
[ ] Test failover thủ công thành công nhiều lần
[ ] Có backup ngoài cụm
[ ] Có monitoring
[ ] Có fencing
[ ] Có thời gian test split-brain
[ ] Có tài liệu vận hành
```

---

## Cảnh báo

Không có fencing thì không nên gọi là HA production.

Nếu chưa có fencing, cứ để manual failover an toàn hơn.
