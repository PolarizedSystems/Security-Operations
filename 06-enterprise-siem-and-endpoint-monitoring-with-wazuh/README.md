# Enterprise SIEM & Endpoint Monitoring with Wazuh

[← Back to Security Operations](../README.md)

---

## Overview

In Security Operations, centralized security monitoring and endpoint visibility are essential for detecting suspicious activity, identifying potential threats, and strengthening security operations across our network environments.

In this project, I deploy **Wazuh, an open-source SIEM and XDR platform**, on an Ubuntu Linux server within the Polarized Systems SOC environment. The platform provides centralized security monitoring, event correlation, and alerting across Windows and Linux endpoints.

### Learning Outcomes

This lab covers the following exercises:

- Exercise 1 – Deploy the Wazuh Server
- Exercise 2 – Deploy a Windows Agent
- Exercise 3 – Deploy a Linux Agent

---

## Objectives

- **Exercise 1 – Wazuh Server Deployment:** Install and configure the Wazuh all-in-one platform, including the manager, indexer, and dashboard, on Ubuntu Linux. Configure firewall access, verify service functionality, and access the management dashboard.

- **Exercise 2 – Windows Endpoint Monitoring:** Install and configure the Wazuh agent on a Windows Server endpoint, confirm successful agent enrollment and active communication with the Wazuh manager.

- **Exercise 3 – Linux Endpoint Monitoring:** Deploy the Wazuh agent on an Ubuntu Linux endpoint.

> **This project demonstrates practical SIEM deployment, endpoint security monitoring, agent management, and cross-platform security operations, while establishing a centralized monitoring solution environment across Windows and Linux environments.**

---

## Lab Topology

![Lab Topology](images/lab-topology.png)

---

## Lab Environment

| Hostname | IP Address | Operating System | Role in this lab |
|----------|-----------|------------------|------------------|
| `corp-pfsense-001` | — | pfSense | Firewall / router between subnets |
| `soc-wazuh-002` | 192.168.40.11 | Ubuntu 22.04 LTS | Wazuh all-in-one SIEM (Ex 1) |
| `corp-win-svr-001` | 192.168.20.7 | Windows Server 2025 | Windows agent endpoint (Ex 2) |
| `corp-ubuntu-001` | 192.168.20.5 | Ubuntu 22.04 LTS | Linux agent endpoint (Ex 3) |

---

## Exercises

| # | Exercise | Platform | Key Skills |
|---|----------|----------|-----------|
| 1 | [Deploy the Wazuh Server](exercise-1-deploy-the-wazuh-server/README.md) | Linux | Wazuh all-in-one install · `ufw` · `systemctl` service verification · dashboard |
| 2 | [Deploy a Windows Agent](exercise-2-deploy-a-windows-agent/README.md) | Windows | Agent enrollment · PowerShell MSI install · dashboard confirmation |
| 3 | [Deploy a Linux Agent](exercise-3-deploy-a-linux-agent/README.md) | Linux | `.deb` agent install · `systemd` service · cross-platform visibility |

---

[← Back to Security Operations](../README.md)
