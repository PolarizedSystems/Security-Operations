# Security Operations

A Security Operations Center turns raw telemetry into decisions: gathering threat intelligence, hardening systems and networks, and spotting malicious activity before it becomes an incident. These projects show how I collect, analyze and act on security data across an enterprise environment.

All work is performed in **Polarized Systems**, my enterprise lab environment: a Windows Active Directory domain (`corp.polarizedsystems.com`) with segmented server, workstation and Security Operations subnets routed through a pfSense firewall.

---

## Projects

| # | Project | Focus |
|---|---------|-------|
| 01 | [Threat Intelligence & Threat Gathering](01-threat-intelligence-and-threat-gathering/README.md) | Passive OSINT reconnaissance, threat-intel sources, logon-event hunting, MITRE ATT&CK and domain firewall logging |
| 02 | [Techniques to Determine Malicious Activity](02-techniques-to-determine-malicious-activity/README.md) | Windows event-log hunting with PowerShell and Linux login monitoring, validated with simulated brute-force attacks |
| 03 | [Identifying & Analyzing Malicious Activity](03-identifying-and-analyzing-malicious-activity/README.md) | Resource-utilization monitoring on Windows and Linux, plus detecting Active Directory privilege escalation (Events 4728/4737) |
| 04 | [Tools for Identifying Malicious Activity](04-tools-for-identifying-malicious-activity/README.md) | Live network capture with Wireshark and tcpdump, plus domain and IP validation with WHOIS, AbuseIPDB and VirusTotal |
| 05 | [Centralized Logging & Endpoint Hardening](05-centralized-logging-and-endpoint-hardening/README.md) | Deploying Splunk on enterprise Linux for centralized log collection, plus BitLocker drive encryption and multi-factor authentication hardening |
| 06 | [Enterprise SIEM & Endpoint Monitoring with Wazuh](06-enterprise-siem-and-endpoint-monitoring-with-wazuh/README.md) | Deploying a Wazuh SIEM on enterprise Linux with agents across Windows and Linux endpoints |

---

## Related Portfolios

- [Vulnerability Management](https://github.com/PolarizedSystems/Vulnerability-Management)
- [Incident Response Management](https://github.com/PolarizedSystems/Incident-Response-Management)
- [Reporting & Communication](https://github.com/PolarizedSystems/Reporting-and-Communication)
