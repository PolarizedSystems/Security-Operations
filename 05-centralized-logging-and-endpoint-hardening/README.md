# Centralized Logging & Endpoint Hardening

[← Back to Security Operations](../README.md)

**Domain:** Security Operations
**Environment:** Polarized Systems lab — a Splunk SIEM on an enterprise Linux server, a Windows Universal Forwarder endpoint, a Windows member server, and an Active Directory domain controller

---

## Overview

This project demonstrates the implementation of **centralized security logging, data encryption, and multi-factor authentication (MFA)** to strengthen threat visibility, protect sensitive information, and improve access security within the **Polarized Systems SOC environment**.

Effective enterprise security requires centralized collection of system events, protection of sensitive data at rest, and strong authentication controls to reduce the risk of unauthorized access. This project combines **Splunk Enterprise SIEM, Microsoft BitLocker Drive Encryption, and Active Directory smart-card authentication** to demonstrate these security capabilities across Windows and Linux infrastructure.

The project focuses on three primary areas of security engineering:

- **Exercise 1 – Centralized Logging with Splunk Enterprise:** Deployed Splunk Enterprise on Rocky Linux as a `systemd`-managed service, configured TCP port `9997` for log ingestion, and installed a Splunk Universal Forwarder on a Windows endpoint. Verified centralized collection and real-time searchability of Windows Security, System, and Application event logs.

- **Exercise 2 – Data Protection with BitLocker:** Installed and configured Microsoft BitLocker Drive Encryption on a Windows member server to encrypt a dedicated data volume, implementing password-based unlocking and recovery key escrow to protect sensitive information at rest.

- **Exercise 3 – Multi-Factor Authentication:** Configured an Active Directory user account to require smart-card authentication and validated the enforcement of certificate-based MFA by demonstrating that password-only authentication was rejected at the workstation.

The objective of this project was to develop practical experience in **SIEM deployment, centralized log management, endpoint security, data encryption, and identity and access management (IAM)**. These exercises demonstrate how layered security controls strengthen enterprise monitoring, protect sensitive resources, and reduce exposure to unauthorized access.

---

## Lab Topology

![Lab Topology](images/lab-topology.png)

---

## Learning Outcomes

By the end of this lab, I was able to:

- Install and configure Splunk Enterprise for centralized log collection on enterprise Linux
- Run Splunk as a hardened `systemd` service under a dedicated least-privilege account
- Manage the host firewall (`firewalld`) to expose only the required ports (8000, 9997)
- Deploy and configure a Splunk Universal Forwarder on a Windows endpoint
- Confirm and troubleshoot forwarder-to-indexer data flow using Splunk's own `_internal` index and SPL searches
- Install BitLocker Drive Encryption and encrypt a data volume to protect data at rest
- Create Active Directory users and enforce smart-card-required multi-factor authentication
- Verify that an enforced MFA control actually blocks single-factor logon

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

## Review

### Summary

In this lab I completed three exercises that together cover the full arc of *collect it, protect the data, protect the access*:

- Exercise 1 — Deploy Splunk Enterprise on Linux (centralized logging)
- Exercise 2 — Encrypting Sensitive Data (BitLocker, data at rest)
- Exercise 3 — Enabling Multi-Factor Authentication (smart-card MFA, access hardening)

Centralized logging gives the environment a single, trustworthy place to search every endpoint's events; encryption at rest ensures the data those endpoints hold is useless if the hardware is lost; and enforced MFA ensures a stolen password can't be used to reach any of it. Each control reinforces the others — and in production the hardening events themselves would feed back into the SIEM from Exercise 1.

### Skills Demonstrated

- SIEM deployment and log centralization with Splunk Enterprise on Linux
- Hardened service configuration (least-privilege account, `systemd`, minimal firewall exposure)
- Endpoint log forwarding with the Splunk Universal Forwarder
- Data-flow verification and troubleshooting with SPL
- Encryption at rest with BitLocker Drive Encryption
- Account hardening with enforced certificate-based multi-factor authentication

---

[← Back to Security Operations](../README.md)
