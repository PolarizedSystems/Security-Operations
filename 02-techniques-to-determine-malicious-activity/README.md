# Techniques to Determine Malicious Activity

[← Back to Security Operations](../README.md)

**Domain:** Security Operations
**Environment:** Polarized Systems lab — Windows Active Directory domain (`corp.polarizedsystems.com`) with a segmented server subnet, a Rocky Linux server, and an isolated Security Operations subnet for attack simulation

---

## Overview

Prevention controls fail eventually, so the difference between a minor incident and a breach is often how quickly an analyst can *see* the attack in the logs. This lab works that detection problem end to end on two platforms: I enabled the right auditing, generated a realistic attack, and then hunted the attacker's footprints in the logs the way a Security Operations analyst would during a live investigation.

A core idea runs through both exercises: **you cannot detect what you do not record.** An attack only becomes visible after the audit policy, logging, and collection are configured to capture it — so each exercise pairs a hardening/configuration step with a controlled attack and a detection step that proves the telemetry works.

- **Exercise 1 — Windows:** Enabled domain-wide logon auditing and an account-lockout threshold with Group Policy, simulated an SMB password-guessing attack from Kali Linux, then built a PowerShell hunting script to surface the resulting failed-logon events (Event ID 4625).
- **Exercise 2 — Linux:** Reviewed login and reboot history on a Rocky Linux server with the `last` family of commands, then simulated an SSH brute-force attack and confirmed both the failed attempts and the attacker's eventual successful login were visible in the authentication records.

> 🔎 **Detection begins before the attack, not during it.** Every exercise here deliberately pairs a configuration step with an attack and a detection step, because the telemetry that catches an intruder has to be enabled *in advance*. Logon auditing and an account-lockout threshold are worthless if they're switched on after the brute-force attempt — by then the evidence is already gone. The discipline a SOC analyst builds is to decide what must be recorded, and what "normal" looks like, long before anyone needs to go looking.

---

## Lab Topology

![Lab Topology](images/lab-topology.png)

---

## Learning Outcomes

By the end of this lab, I was able to:

- Enable Windows logon auditing (success and failure) across a domain using Group Policy
- Configure an account-lockout threshold to slow and expose brute-force attacks
- Safely generate failed-logon telemetry for detection testing from an isolated attacker host
- Build a PowerShell event-log hunting script with `Get-WinEvent` and a filter hashtable
- Interpret Windows logon events, including Event ID 4625 and Logon Type codes
- Configure Windows Defender Firewall to support remote, centralized event-log collection
- Monitor interactive and remote login activity on a Linux server with `last`, `last reboot`, and `last -i`
- Recognize the signature of an SSH brute-force attack in Linux authentication records

---

## Lab Environment

| Hostname | IP Address | Operating System | Role in this lab |
|----------|-----------|------------------|------------------|
| `corp-pfsense-001` | — | pfSense | Firewall / router between subnets |
| `corp-sw-001` | — | — | Core switch |
| `corp-dc-001` | 192.168.20.2 | Windows Server | Domain Controller — audit policy, PowerShell hunting, SSH attack source (Ex 2) |
| `corp-rhel-001` | 192.168.20.4 | Rocky Linux 10 | Linux login-monitoring target (Ex 2) |
| `corp-wks-001` | 192.168.30.3 | Windows 11 | Analyst workstation — remote log collection (Ex 1) |
| `soc-kali-001` | 192.168.40.5 | Kali Linux | Attack simulation — SMB brute force (Ex 1) |

---

## Exercises

| # | Exercise | Platform | Key Tools |
|---|----------|----------|-----------|
| 1 | [Monitor Windows Event Logs with PowerShell](exercise-1-monitor-windows-event-logs/README.md) | Windows | Group Policy · smbclient · PowerShell ISE · `Get-WinEvent` · Out-GridView · Windows Defender Firewall |
| 2 | [Monitor Login Events on Linux Devices](exercise-2-monitor-linux-login-events/README.md) | Linux | `last` · `last reboot` · `last -i` · OpenSSH · `hostnamectl` |

---

## Scripts

| Script | Host | Purpose |
|--------|------|---------|
| [`generate-test-logins.sh`](scripts/generate-test-logins.sh) | soc-kali-001 | Authorized detection test — generates failed SMB logons (Event ID 4625) |
| [`Monitor-FailedLogons.ps1`](scripts/Monitor-FailedLogons.ps1) | corp-dc-001 | Hunts failed-logon events in the Windows Security log and displays them in a grid |

---

## Review

### Summary

In this lab I completed two exercises:

- Exercise 1 — Monitor Windows Event Logs with a PowerShell Script
- Exercise 2 — Monitor Login Events on Linux Devices

Across both, I configured the auditing needed to capture authentication activity, generated controlled attacks to produce that activity, and then detected it in the logs — the full "configure, attack, detect" loop a SOC analyst relies on.

### Skills Demonstrated

- Domain-wide audit policy and account-lockout configuration with Group Policy
- Controlled, authorized attack simulation for detection validation
- PowerShell event-log hunting and filtering (`Get-WinEvent` / `-FilterHashtable`)
- Interpreting Windows logon events and Logon Type codes (4625, Type 3)
- Preparing an environment for centralized, remote log collection
- Linux login and session auditing with the `last` command family
- Recognizing brute-force signatures across both Windows and Linux telemetry
