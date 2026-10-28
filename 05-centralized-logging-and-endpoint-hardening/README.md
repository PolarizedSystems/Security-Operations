# Centralized Logging & Endpoint Hardening

[← Back to Security Operations](../README.md)

---

## Overview

Effective network security requires a centralized collection of system events, protection of sensitive data at rest, and strong authentication controls.
This helps to reduce the risk of unauthorized access. In these labs, we'll take a look at **Splunk Enterprise SIEM, Microsoft BitLocker Drive Encryption, and Active Directory smart-card authentication**.
These technologies provide strong security solutions across Windows and Linux environments.

### Learning Outcomes

This lab covers the following exercises:

- Exercise 1 – Deploy Splunk Enterprise on Linux
- Exercise 2 – Encrypting Sensitive Data
- Exercise 3 – Enabling Multi-Factor Authentication

After completing this lab, you should be able to:

- Install and configure Splunk Enterprise for centralized log collection on enterprise Linux
- Run Splunk as a hardened `systemd` service under a dedicated least-privilege account
- Manage the host firewall (`firewalld`) to expose only the required ports (8000, 9997)
- Deploy and configure a Splunk Universal Forwarder on a Windows endpoint
- Install BitLocker Drive Encryption and encrypt a data volume to protect data at rest
- Create Active Directory users and enforce smart-card-required multi-factor authentication
- Verify that an enforced MFA control actually blocks single-factor logon

---

## Lab Topology

![Lab Topology](images/lab-topology.png)

---

## Lab Environment

| Hostname | IP Address | Operating System | Role in this lab |
|----------|-----------|------------------|------------------|
| `corp-pfsense-001` | — | pfSense | Firewall / router between subnets |
| `soc-splunk-002` | 192.168.40.10 | Rocky Linux 10 | Splunk Enterprise indexer / SIEM (Ex 1) |
| `corp-wks-001` | 192.168.30.3 | Windows 11 | Universal Forwarder log source (Ex 1) · MFA logon test (Ex 3) |
| `corp-win-svr-001` | 192.168.20.7 | Windows Server | Member server — BitLocker data volume (Ex 2) |
| `corp-dc-001` | 192.168.20.2 | Windows Server | Domain Controller — Active Directory / MFA (Ex 3) |

---

## Exercises

| # | Exercise | Platform | Key Skills |
|---|----------|----------|-----------|
| 1 | [Deploy Splunk Enterprise on Linux](exercise-1-deploy-splunk-enterprise-on-linux/README.md) | Linux + Windows | Splunk indexer · `systemd` service · `firewalld` · Universal Forwarder · SPL verification |
| 2 | [Encrypting Sensitive Data](exercise-2-encrypting-sensitive-data/README.md) | Windows Server | BitLocker Drive Encryption · encryption at rest · recovery-key escrow |
| 3 | [Enabling Multi-Factor Authentication](exercise-3-enabling-multi-factor-authentication/README.md) | Windows / Active Directory | Smart-card (certificate) MFA · AD account hardening · control verification |

---

[← Back to Security Operations](../README.md)
