# Lynis tests to GB/T 22239-2019 (MLPS 2.0)

This map is a helper for technical self-check and remediation. It is not a substitute
for GB/T 22239-2019, GB/T 28448, or the official 自查工具.

Default mapping assumes a **level-3** computing environment. Level-2 systems should
drop controls that the standard marks as not required at that grade.

| Control | Title | Lynis signals | Typical remediation |
| --- | --- | --- | --- |
| 8.1.2.a | 网络架构 | MANUAL | Zoning drawings, dedicated OOB/management path |
| 8.1.2.b | 通信传输 | `CRYP-*`, SSH crypto | TLS 1.2+, disable weak ciphers, integrity protection |
| 8.1.2.c | 可信验证 | MANUAL | Hardware/boot chain evidence |
| 8.1.3.a | 边界防护 | `FIRE-*`, `firewall_active` | Host firewall + edge ACL, no empty policy |
| 8.1.3.b | 访问控制 | `SSH-*` | Allow-list, drop unused services |
| 8.1.3.c | 入侵防范 | `TOOL-51*`, `IDS_IPS_TOOL_FOUND` | IDS/IPS or WAF at the boundary |
| 8.1.3.d | 恶意代码防范 | `MALW-*` | Deploy and update AV/EDR |
| 8.1.3.e | 安全审计 | `ACCT-*`, `LOG-*` | Audit on network devices; retain logs |
| 8.1.4.a | 身份鉴别 | `AUTH-*` | Unique IDs, lockout, MFA for level 3 |
| 8.1.4.b | 访问控制 | `FILE-*`, `AUTH-925*` | Least privilege, default deny |
| 8.1.4.c | 安全审计 | `ACCT-9628`, `audit_daemon_running` | auditd rules, protected log storage |
| 8.1.4.c-time | 时钟同步 | `TIME-*`, `NTP_DAEMON_RUNNING` | NTP/chrony to a trusted source |
| 8.1.4.d | 入侵防范 | `TOOL-5102` Fail2ban, IDS | Host IDS / login guarding |
| 8.1.4.e | 恶意代码防范 | `MALW-*` | Scanner + signature updates |
| 8.1.4.f | 可信验证 | MANUAL | Measured boot / trusted compute |
| 8.1.4.g | 数据完整性 | `FINT-*`, `FILE_INT_TOOL_FOUND` | AIDE/Tripwire/OSSEC syscheck |
| 8.1.4.h | 数据保密性 | `CRYP-*` | Encryption at rest, approved crypto |
| 8.1.4.i | 数据备份恢复 | MANUAL | Backup job + restore drill evidence |
| 8.1.4.j | 剩余信息保护 | `HOME-*`, storage tests | Wipe, secure delete, memory reuse |
| 8.1.4.k | 个人信息保护 | MANUAL | Minimization, consent, masking |
| 8.1.5 | 安全管理中心 | MANUAL | Fill 态势感知 / 综合业务平台 items in v10.2 |

Scan command:

```sh
./lynis audit system --profile dengbao.prf --quick
```

Report fields written by the plugin:

- `dengbao_control[]=<id>|<title>|<OK|GAP|MANUAL>|<evidence>|`
- `dengbao_ok`, `dengbao_gap`, `dengbao_manual`
