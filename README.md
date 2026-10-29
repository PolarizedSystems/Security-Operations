# Security Operations

![Polarized Systems — Enterprise Network Architecture](images/enterprise-topology.png)

## Overview

Security Operations focuses on the continuous **monitoring, detection, investigation**, and **response** to potential threats across computer network systems. Effective security operations require centralized visibility, endpoint monitoring, network traffic analysis, and the ability to distinguish legitimate activity from abnormal activity.

Polarized Systems is a virtualized network & security environment designed to demonstrate these capabilities through hands-on labs.

The environment consists of multiple segmented networks that are interconnected through a pfSense firewall. The pfSense firewall provides routing between the server, workstation, and SOC networks. I use Windows Active Directory, (`corp.polarizedsystems.com`), to support centralized identity & access management.
>
After completing these exercises, you should be able to:

- Perform passive OSINT reconnaissance and gather threat intelligence
- Hunt Windows event logs with PowerShell and monitor Linux login activity
- Detect Active Directory privilege escalation and account abuse
- Capture and analyze network traffic with Wireshark and tcpdump
- Validate domain and IP reputation with WHOIS, AbuseIPDB and VirusTotal
- Centralize log collection with the Splunk and Wazuh SIEM platforms
- Harden endpoints with BitLocker encryption and multi-factor authentication
- Map adversary activity to the MITRE ATT&CK framework

---

## Projects

| # | Project | What I Did | Key Tools / Sources |
|---|---------|------------|---------------------|
| 01 | [Threat Intelligence & Threat Gathering](01-threat-intelligence-and-threat-gathering/README.md) | Performed passive OSINT reconnaissance, gathered threat intelligence, hunted logon events and mapped activity to MITRE ATT&CK, with domain firewall logging | OSINT · MITRE ATT&CK · Windows Event Logs · pfSense |
| 02 | [Techniques to Determine Malicious Activity](02-techniques-to-determine-malicious-activity/README.md) | Hunted Windows event logs with PowerShell and monitored Linux logins, validated with simulated brute-force attacks | PowerShell · Windows Event Logs · Linux auth logs |
| 03 | [Identifying & Analyzing Malicious Activity](03-identifying-and-analyzing-malicious-activity/README.md) | Monitored resource utilization on Windows and Linux and detected Active Directory privilege escalation (Events 4728/4737) | Process Explorer · Event Viewer · Top · Htop · Active Directory |
| 04 | [Tools for Identifying Malicious Activity](04-tools-for-identifying-malicious-activity/README.md) | Captured live network traffic with Wireshark and tcpdump and validated domains and IPs against threat-intelligence services | Wireshark · tcpdump · WHOIS · AbuseIPDB · VirusTotal |
| 05 | [Centralized Logging & Endpoint Hardening](05-centralized-logging-and-endpoint-hardening/README.md) | Deployed Splunk on enterprise Linux for centralized logging, encrypted data at rest with BitLocker and enforced smart-card MFA | Splunk · Universal Forwarder · BitLocker · Active Directory |
| 06 | [Enterprise SIEM & Endpoint Monitoring with Wazuh](06-enterprise-siem-and-endpoint-monitoring-with-wazuh/README.md) | Deployed a Wazuh all-in-one SIEM and enrolled Windows and Linux agents for cross-platform endpoint monitoring | Wazuh · systemd · Windows MSI / Linux Wazuh agents |

---

## Related Portfolios

- [Vulnerability Management](https://github.com/PolarizedSystems/Vulnerability-Management)
- [Incident Response](https://github.com/PolarizedSystems/Cybersecurity-Incident-Response)
- [Windows Server Identity & Access Management](https://github.com/PolarizedSystems/Windows-Server-Identity-and-Access-Management)
