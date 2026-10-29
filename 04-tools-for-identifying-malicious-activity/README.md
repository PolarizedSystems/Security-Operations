# Tools for Identifying Malicious Activity

[← Back to Security Operations](../README.md)

---

## Overview

Identifying malicious activity comes down to two questions: *what is actually crossing my network,* and *can I trust the domains and addresses my systems are talking to?* This lab builds hands-on skill with the core tools that answer both. I captured and analyzed live network traffic with Wireshark and tcpdump, then validated domains and IP addresses against public threat-intelligence services.

### Learning Outcomes

---

This lab covers the following exercises:

- Exercise 1 – Monitoring Network Activity
- Exercise 2 – Validating Domain Names & IP Addresses

After completing this lab, you should be able to:

- Capture and analyze live network traffic with Wireshark
- Customize Wireshark columns and time display to highlight the fields that matter for threat hunting
- Write display filters to isolate traffic by port, host and subnet
- Capture targeted traffic from the command line with tcpdump and save it to a file
- Analyze saved packet captures (`.pcap`) in Wireshark
- Research domain ownership and registration with WHOIS
- Check IP addresses for a history of abuse with AbuseIPDB
- Scan URLs and IP addresses for malicious reputation with VirusTotal

---

## Lab Topology

![Lab Topology](images/lab-topology.png)

---

## Lab Environment

| Hostname | IP Address | Operating System | Role in this lab |
|----------|-----------|------------------|------------------|
| `corp-pfsense-001` | — | pfSense | Firewall / router between subnets |
| `soc-kali-001` | 192.168.40.5 | Kali Linux | Packet capture and analysis — Wireshark, tcpdump (Ex 1) |
| `corp-wks-001` | 192.168.30.3 | Windows 11 | Traffic generation and threat-intel validation (Ex 1 + 2) |

---

## Exercises

| # | Exercise | Platform | Key Tools |
|---|----------|----------|-----------|
| 1 | [Monitoring Network Activity](exercise-1-monitoring-network-activity/README.md) | Linux | Wireshark · tcpdump · display filters · `.pcap` analysis |
| 2 | [Validating Domain Names & IP Addresses](exercise-2-validating-domains-and-ips/README.md) | Web | WHOIS · AbuseIPDB · VirusTotal |

