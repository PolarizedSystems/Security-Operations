# Exercise 2 – Validating Domain Names & IP Addresses

[← Back to Lab Overview](../README.md)

---

## Overview

As a **Information Systems Specialist**, validating domain names and IP addresses is essential for investigating suspicious network activity, identifying potentially malicious resources, and assessing security risks.

Security Professionals often use **WHOIS, AbuseIPDB, and VirusTotal** to investigate domain information, evaluate IP address reputations, and assess the safety of web links.

- **WHOIS Analysis:** Examine domain registration information and associated IP address details to support domain validation.
- **AbuseIPDB Reputation Checks:** Investigate reported malicious activity associated with IP addresses to support security assessments.
- **VirusTotal URL Analysis:** Evaluate web links for potential security threats using VirusTotal.

---

## Objectives
- **Validate Domain Names & IP Addresses:** Use WHOIS, AbuseIPDB and VirusTotal to research domain ownership, check IP addresses for a history of abuse, and scan URLs and addresses for malicious reputation.
  
## Devices

- **corp-wks-001** – Windows 11 – Microsoft Edge (192.168.30.3)

---

## Task 1 – Research Domain Ownership with WHOIS

1. On **corp-wks-001**, open **Microsoft Edge**.

   ![Open Edge](screenshots/exercise-2/e2-01-open-edge.png)

2. Browse to the WHOIS lookup service:

   ```
   https://www.whois.com/whois/
   ```

   ![WHOIS site](screenshots/exercise-2/e2-02-whois-site.png)

3. Search a domain — here, the bug-bounty platform `bugcrowd.com`.

   ![WHOIS search bugcrowd](screenshots/exercise-2/e2-03-whois-search-bugcrowd.png)

4. The record shows registration date (2012-09-01), registrar (Gandi SAS), name servers (AWS) and status **client transfer prohibited**.

   ![WHOIS bugcrowd result](screenshots/exercise-2/e2-04-whois-bugcrowd-result.png)

5. A second lookup on `hackerone.com` shows an older registration (2007-11-26), Cloudflare as registrar, and **six "prohibited" status flags**.


   ![WHOIS hackerone result](screenshots/exercise-2/e2-05-whois-hackerone-result.png)

6. The full bugcrowd record, including registrar IANA ID and abuse contact.

   ![WHOIS bugcrowd detail](screenshots/exercise-2/e2-06-whois-bugcrowd-detail.png)

---

## Task 2 – Check IP Abuse History with AbuseIPDB

7. Browse to AbuseIPDB, a crowdsourced database of IP addresses reported for malicious activity:

   ```
   https://www.abuseipdb.com
   ```

   ![AbuseIPDB home](screenshots/exercise-2/e2-07-abuseipdb-home.png)

8. Checking an address returns its abuse profile. This IP resolves to a **Cloudflare** content-delivery address and is on AbuseIPDB's **whitelist** — flagged as a trusted reverse proxy, with no abuse reports.


   ![AbuseIPDB IP details](screenshots/exercise-2/e2-08-abuseipdb-ip-details.png)

9. AbuseIPDB links straight to a WHOIS lookup for the same address, tying ownership to reputation in one place.

   ![AbuseIPDB WHOIS](screenshots/exercise-2/e2-09-abuseipdb-whois.png)

---

## Task 3 – Scan Reputation with VirusTotal

10. Browse to VirusTotal, which checks files, URLs, domains and IPs against 90+ security vendors at once:

    ```
    https://www.virustotal.com
    ```

    ![VirusTotal home](screenshots/exercise-2/e2-10-virustotal-home.png)

11. Select the **Search** tab to look up an existing indicator.

    ![VirusTotal Search tab](screenshots/exercise-2/e2-11-virustotal-search-tab.png)

12. Search an IP address.

    ![VirusTotal search IP](screenshots/exercise-2/e2-12-virustotal-search-ip.png)

13. The result shows **0 / 92 vendors flagged** the address as malicious — a clean verdict, with the owning network (AS 37518) and location.

    ![VirusTotal IP result](screenshots/exercise-2/e2-13-virustotal-ip-result.png)

14. Switch to the **URL** tab to scan a full web address.

    ![VirusTotal URL tab](screenshots/exercise-2/e2-14-virustotal-url-tab.png)

15. Enter a URL to scan — `https://www.bugcrowd.com/`.

    ![VirusTotal URL bugcrowd](screenshots/exercise-2/e2-15-virustotal-url-bugcrowd.png)

16. The URL report returns **0 / 93 vendors**, an HTTP 200 status, and the categories vendors assign it (information technology, technology).

   ### Reading a VirusTotal Verdict

> **VirusTotal compares a URL against multiple security vendors to identify potential threats. A result of **0/93** indicates that none of the 93 engines flagged the URL as malicious, while the report also provides HTTP status, content type, redirects, and categorization details.**
>
> **Note:** A clean result does not guarantee safety. Analysts should validate findings using additional threat intelligence and security indicators.

    ![VirusTotal URL result](screenshots/exercise-2/e2-16-virustotal-url-result.png)

17. The full URL report, including the detection score, redirect chain and category breakdown.

    ![VirusTotal URL details](screenshots/exercise-2/e2-17-virustotal-url-details.png)


> | Tool | Answers | Best for |
> |------|---------|----------|
> | **WHOIS** | Who owns this domain, and how long has it existed? | Spotting newly registered or anonymously owned domains |
> | **AbuseIPDB** | Has this IP been reported for attacks before? | Checking an address's community abuse history |
> | **VirusTotal** | Do security vendors consider this malicious? | A broad reputation check across 90+ engines |
>

---

> When something suspicious shows up — a strange link in an email, or an unfamiliar address in our logs, we can verify whether it's actually dangerous in seconds, without ever touching it. We check who owns the domain and how long it's existed, whether the address has a history of attacks, and whether security vendors across the industry consider it malicious. That means fewer false alarms, faster decisions, and the confidence to block a real threat or clear a harmless one without guessing.

---

[← Previous: Exercise 1 – Monitoring Network Activity](../exercise-1-monitoring-network-activity/README.md) | [Back to Lab Overview](../README.md)
