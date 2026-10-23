# Identifying & Analyzing Malicious Activity

[← Back to Security Operations](../README.md)

**Domain:** Security Operations
**Environment:** Polarized Systems lab — Windows Active Directory domain (`corp.polarizedsystems.com`) with a Windows member server, a Rocky Linux server, and a Domain Controller

---

## Overview

This project demonstrates the application of **system resource monitoring, Active Directory security auditing, and privilege escalation detection** to identify abnormal system activity and potentially unauthorized administrative changes within the **Polarized Systems SOC environment**.

Effective security monitoring requires visibility into both system performance and user account activity. Analyzing resource utilization helps identify unusual processes and potential performance anomalies, while auditing Active Directory group membership changes provides critical insight into unauthorized privilege assignments and potential security threats.

The project focuses on two primary areas of security investigation:

- **Exercise 1 – System Resource Utilization Analysis:** Monitored CPU, memory, disk I/O, and running processes on Windows and Linux servers using **Microsoft Sysinternals Process Explorer**, `top`, and `htop` to evaluate system performance and identify potentially abnormal resource consumption.

- **Exercise 2 – Active Directory Account & Group Auditing:** Configured Security Group Management auditing through Group Policy and simulated privilege escalation by adding a test account to the Domain Admins group. Analyzed Windows Security Event Logs, including Event IDs `4728` and `4737`, to investigate group membership and security configuration changes.

The objective of this project was to develop practical experience in **system performance analysis, security auditing, privileged account monitoring, and threat detection**. These exercises demonstrate how resource monitoring and Active Directory event analysis improve visibility into suspicious activity and support effective security investigations across enterprise infrastructure.
.

> 🔎 **The quietest attacks look exactly like normal administration.** Adding a user to Domain Admins isn't an exploit — it's a routine action Active Directory performs legitimately all the time. What makes it *detectable* is not the action but the context: who did it, from where, and whether it was expected. The same holds for resource load, where a malicious process hides inside ordinary CPU and memory usage. Analysis is the skill of separating the one abnormal event from the sea of normal ones it's hiding in.

---

## Lab Topology

![Lab Topology](images/lab-topology.png)

---

## Key Findings & Security Outcomes

By the end of this lab, I was able to:

- Monitor Windows processes and resource utilization with Sysinternals Process Explorer
This lab demonstrated the importance of system resource monitoring, user privilege auditing, and unauthorized privilege escalation detection in strengthening security operations across Windows and Linux environments.

Windows Resource Monitoring: Monitored resource utilization on Windows devices to support system oversight and security analysis.

Linux Resource Monitoring: Monitored resource utilization on Linux devices to evaluate system activity.

Privilege Monitoring: Enabled user privilege monitoring to support the identification of unauthorized account permissions.

Security Auditing: Generated auditing logs to provide records for security investigation and analysis.

Privilege Escalation Detection: Examined account privileges to identify potentially unauthorized privilege assignments.

> **Business Impact: Combining resource monitoring with user privilege auditing improves security visibility, strengthens access control oversight, and supports the detection and investigation of unauthorized privilege escalation.
- Trace a group change back to the account and source that performed it.

---

## Lab Environment

| Hostname | IP Address | Operating System | Role in this lab |
|----------|-----------|------------------|------------------|
| `corp-pfsense-001` | — | pfSense | Firewall / router between subnets |
| `corp-dc-001` | 192.168.20.2 | Windows Server | Domain Controller — auditing and event analysis (Ex 2) |
| `corp-win-svr-001` | 192.168.20.7 | Windows Server | Member server — Windows resource monitoring (Ex 1) |
| `corp-rhel-001` | 192.168.20.4 | Rocky Linux 10 | Linux resource monitoring target (Ex 1) |

---

## Exercises

| # | Exercise | Platform | Key Tools |
|---|----------|----------|-----------|
| 1 | [Analyze Resource Utilization](exercise-1-analyze-resource-utilization/README.md) | Windows + Linux | Process Explorer · System Information · `top` · `htop` · EPEL |
| 2 | [Analyze Account & Group Management](exercise-2-analyze-account-and-group-management/README.md) | Windows | Group Policy · Advanced Audit Policy · Active Directory Users and Computers · Event Viewer |

---

## Review

### Summary

In this lab I completed two exercises:

- Exercise 1 — Analyze Resource Utilization
- Exercise 2 — Analyze Account & Group Management

Together they cover both halves of identifying malicious activity: watching how a system *behaves* (resource load) and watching what *changes* inside it (privileged group membership), then proving the detection works by generating the activity and finding it.

### Skills Demonstrated

- Windows process and resource analysis with Sysinternals Process Explorer
- Cross-platform resource monitoring with `top` and `htop`
- Enterprise Linux package management, including enabling the EPEL repository
- Domain-wide audit configuration with Group Policy (Advanced Audit Policy)
- Detecting and attributing privilege escalation through Event IDs 4728 and 4737
