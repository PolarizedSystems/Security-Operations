# Threat Intelligence & Threat Gathering

[← Back to Security Operations](../README.md)

---

## Overview

This section demonstrates the application of Open-Source Intelligence (OSINT), threat intelligence analysis, and threat hunting techniques.
These methods and tools assist security operations with identifying potential security threats, investigate suspicious activity, and strengthen defensive visibility across a company's infrastructure.

### Learning Outcomes

This lab covers the following exercises:

- Exercise 1 – Collection Methods and Sources (OSINT)
- Exercise 2 – Threat Intelligence Hunting and Sharing

After completing this lab, you should be able to:

- Conduct passive OSINT reconnaissance against an organization using only public sources
- Interpret WHOIS, DNS, hosting and technology-profile data to map an external attack surface
- Identify threat-intelligence sources, including SIEM platforms, commercial CTI (Cyber Threat Intelligence) and research honeynets
- Hunt for successful and failed logons in the Windows Security log
- Map adversary behavior to MITRE ATT&CK tactics and techniques
- Enable domain-wide firewall logging through Group Policy to support investigations

---

## Lab Topology

![Lab Topology](images/lab-topology.png)

---

## Lab Environment

| Hostname | IP Address | Operating System | Role |
|----------|-----------|------------------|------|
| `corp-pfsense-001` | — | pfSense | Firewall / router between subnets |
| `corp-dc-001` | 192.168.20.2 | Windows Server | Domain Controller (Group Policy) |
| `corp-wks-001` | 192.168.30.3 | Windows 11 | OSINT research, threat intelligence and log analysis |

---

## Exercises

| # | Exercise | Tools |
|---|----------|-------|
| 1 | [Collection Methods and Sources (OSINT)](exercise-1-osint-collection-methods/README.md) | Edge DevTools · Wayback Machine · BuiltWith · Intelligence X · Whois.com · Website Informer · Social Searcher |
| 2 | [Threat Intelligence Hunting and Sharing](exercise-2-threat-intelligence-hunting/README.md) | Microsoft Sentinel · Intel 471 · CIC Honeynet · Event Viewer · MITRE ATT&CK · Group Policy |

