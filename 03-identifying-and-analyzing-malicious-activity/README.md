# Identifying & Analyzing Malicious Activity

[← Back to Security Operations](../README.md)

---

## Overview

**System resource monitoring, Active Directory security auditing, and privilege escalation detection** are very effective solutions to identify abnormal system activity and potentially unauthorized administrative changes.

Security monitoring requires visibility into both system performance and user account activity. Analyzing resource utilization helps identify unusual processes and potential performance anomalies, while auditing Active Directory group membership changes provides critical insight into unauthorized privilege assignments and potential security threats.

---
### Learning Outcomes

This lab covers the following exercises:
- Exercise 1 – Analyze Resource Utilization
- Exercise 2 – Analyze Account & Group Management

After completing this lab, you should be able to:

- Monitor resource utilization on Windows devices with Process Explorer and System Information
- Monitor resource utilization on Linux devices with `top` and `htop`
- Enable user-privilege monitoring to support the identification of unauthorized account permissions
- Configure domain-wide security auditing with Group Policy (Advanced Audit Policy)
- Detect privilege escalation by analyzing Windows Event IDs 4728 and 4737

---

## Objectives

- **System Resource Utilization Analysis:** Monitor CPU, memory, disk I/O, and running processes on Windows and Linux servers using **Microsoft Sysinternals Process Explorer**, `top`, and `htop` to evaluate system performance and identify potentially abnormal resource consumption.

- **Active Directory Account & Group Auditing:** Configure Security Group-Management-auditing through Group Policy and simulated privilege escalation by adding a test account to the Domain Admins group. Analyzed Windows Security Event Logs, including Event IDs `4728` and `4737`, to investigate group membership and security configuration changes.

---

## Lab Topology

![Lab Topology](images/lab-topology.png)

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

