# Techniques to Determine Malicious Activity

[← Back to Security Operations](../README.md)

---

## Overview

Effective threat detection requires properly configured audit policies, centralized visibility, and the ability to analyze security events for indicators of compromise (IOCs). By generating controlled attack scenarios and examining the resulting authentication records, this project evaluates how security telemetry supports incident investigation and the identification of unauthorized access attempts.

### Learning Outcomes

This lab covers the following exercises:

- Exercise 1 – Monitor Windows Event Logs with PowerShell
- Exercise 2 – Monitor Login Events on Linux Devices

After completing this lab, you should be able to:

- Enable Windows logon auditing (success and failure) across a domain using Group Policy
- Configure an account-lockout threshold to slow and expose brute-force attacks
- Safely generate failed-logon telemetry for detection testing from an isolated attacker host
- Build a PowerShell event-log hunting script with `Get-WinEvent` and a filter hashtable
- Interpret Windows logon events, including Event ID 4625 and Logon Type codes
- Configure Windows Defender Firewall to support remote, centralized event-log collection
- Monitor interactive and remote login activity on a Linux server with `last`, `last reboot`, and `last -i`
- Recognize the signature of an SSH brute-force attack in Linux authentication records

---

## Lab Topology

![Lab Topology](images/lab-topology.png)

---

## Lab Environment

| Hostname | IP Address | Operating System | Role in this lab |
|----------|-----------|------------------|------------------|
| `corp-pfsense-001` | — | pfSense | Firewall / router between subnets |
| `corp-dc-001` | 192.168.20.2 | Windows Server | Domain Controller — audit policy, PowerShell hunting, SSH attack source (Ex 2) |
| `corp-rhel-001` | 192.168.20.4 | Rocky Linux 10 | Linux login-monitoring target (Ex 2) |
| `corp-wks-001` | 192.168.30.3 | Windows 11 | Analyst workstation — remote log collection (Ex 1) |
| `soc-kali-001` | 192.168.40.5 | Kali Linux | Attack simulation — SMB brute force (Ex 1) |

---

## Exercises

| # | Exercise | Platform | Key Tools |
|---|----------|----------|-----------|
| 1 | [Monitor Windows Event Logs with PowerShell](exercise-1-monitor-windows-event-logs/README.md) | Windows | Group Policy · smbclient · PowerShell ISE · `Get-WinEvent` ·  Windows Defender Firewall |
| 2 | [Monitor Login Events on Linux Devices](exercise-2-monitor-linux-login-events/README.md) | Linux | `last` · `last reboot` · `last -i` · OpenSSH · `hostnamectl` |

---

## Scripts

| Script | Host | Purpose |
|--------|------|---------|
| [`generate-test-logins.sh`](scripts/generate-test-logins.sh) | soc-kali-001 | Authorized detection test — generates failed SMB logons (Event ID 4625) |
| [`Monitor-FailedLogons.ps1`](scripts/Monitor-FailedLogons.ps1) | corp-dc-001 | Hunts failed-logon events in the Windows Security log and displays them in a grid |

