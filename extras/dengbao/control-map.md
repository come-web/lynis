# Lynis tests to GB/T 22239-2019 (MLPS 2.0)

This map is a helper for technical self-check and remediation. It is not a substitute
for GB/T 22239-2019, GB/T 28448, or the official 自查工具.

Default mapping assumes a **level-3** computing environment. Level-2 systems should
drop controls that the standard marks as not required at that grade.

| Control | Title | Lynis signals | Typical remediation |
| --- | --- | --- | --- |
| 8.1.2.a | Network architecture | MANUAL | Zoning drawings, dedicated OOB/management path |
| 8.1.2.b | Communication protection | `CRYP-*`, SSH crypto | TLS 1.2+, disable weak ciphers, integrity protection |
| 8.1.2.c | Trusted verification | MANUAL | Hardware/boot chain evidence |
| 8.1.3.a | Boundary protection | `FIRE-*`, `firewall_active` | Host firewall + edge ACL, no empty policy |
| 8.1.3.b | Access control | `SSH-*` | Allow-list, drop unused services |
| 8.1.3.c | Intrusion prevention | `TOOL-51*`, `IDS_IPS_TOOL_FOUND` | IDS/IPS or WAF at the boundary |
| 8.1.3.d | Malware prevention | `MALW-*` | Deploy and update AV/EDR |
| 8.1.3.e | Security audit | `ACCT-*`, `LOG-*` | Audit on network devices; retain logs |
| 8.1.4.a | Identity authentication | `AUTH-*` | Unique IDs, lockout, MFA for level 3 |
| 8.1.4.b | Access control | `FILE-*`, `AUTH-925*` | Least privilege, default deny |
| 8.1.4.c | Security audit | `ACCT-9628`, `audit_daemon_running` | auditd rules, protected log storage |
| 8.1.4.c-time | Clock sync | `TIME-*`, `NTP_DAEMON_RUNNING` | NTP/chrony to a trusted source |
| 8.1.4.d | Intrusion prevention | `TOOL-5102` Fail2ban, IDS | Host IDS / login guarding |
| 8.1.4.e | Malware prevention | `MALW-*` | Scanner + signature updates |
| 8.1.4.f | Trusted verification | MANUAL | Measured boot / trusted compute |
| 8.1.4.g | Data integrity | `FINT-*`, `FILE_INT_TOOL_FOUND` | AIDE/Tripwire/OSSEC syscheck |
| 8.1.4.h | Data confidentiality | `CRYP-*` | Encryption at rest, approved crypto |
| 8.1.4.i | Backup and recovery | MANUAL | Backup job + restore drill evidence |
| 8.1.4.j | Residual information | `HOME-*`, storage tests | Wipe, secure delete, memory reuse |
| 8.1.4.k | Personal information | MANUAL | Minimization, consent, masking |
| 8.1.5 | Management center | MANUAL | Fill 态势感知 / 综合业务平台 items in v10.2 |

Scan command:

```sh
./lynis audit system --profile dengbao.prf --quick
```

Report fields written by the plugin:

- `dengbao_control[]=<id>|<title>|<OK|GAP|MANUAL>|<evidence>|`
- `dengbao_ok`, `dengbao_gap`, `dengbao_manual`
