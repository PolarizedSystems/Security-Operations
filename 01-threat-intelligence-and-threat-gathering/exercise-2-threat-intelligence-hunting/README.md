# Exercise 2 – Threat Intelligence Hunting and Sharing

[← Back to Lab Overview](../README.md)

---

## Overview

This exercise explores the application of threat hunting and threat intelligence analysis to proactively identify suspicious activity, investigate potential security incidents, and detect indicators of compromise (IOCs) across enterprise infrastructure.

Threat hunting involves examining system logs, network activity, authentication records, and security telemetry to identify malicious behavior that may evade traditional security controls. Particular emphasis is placed on detecting advanced persistent threats (APTs), unauthorized access, privilege escalation, and lateral movement within an organization's network.

Common indicators of potentially malicious activity include:

- **Network Anomalies:** Unusual network traffic, suspicious IP addresses, abnormal DNS activity, and potential distributed denial-of-service (DDoS) activity.

- **Authentication & Access Anomalies:** Repeated failed login attempts, off-hours authentication, unexpected privilege escalation, and unusual access to sensitive files or databases.

- **System Integrity Changes:** Unauthorized modifications to system files, Windows Registry settings, and security configurations.

- **Defense Evasion:** Unexpected clearing of security logs or other attempts to conceal suspicious activity.

The objective of this exercise was to examine threat hunting methodologies, indicators of compromise, and security event analysis techniques used to investigate potential threats and strengthen organizational detection capabilities. This exercise demonstrates foundational knowledge of threat detection, incident investigation, security monitoring, and threat intelligence analysis.

## Devices

- **corp-wks-001** – Windows 11 – Microsoft Edge and Event Viewer (192.168.30.3)
- **corp-dc-001** – Windows Server – Group Policy Management (192.168.20.2)

---

## Task 1 – Review Threat Intelligence Sources

### SIEM: Microsoft Sentinel

1. On **corp-wks-001**, review Microsoft Sentinel, a cloud-native **Security Information and Event Management (SIEM)** platform:

   ```
   https://www.microsoft.com/security/business/siem-and-xdr/microsoft-sentinel
   ```

   A SIEM collects logs from across the environment, correlates them and raises alerts, giving analysts one place to detect, investigate and respond to threats.

   ![Microsoft Sentinel](../screenshots/exercise-2/e2-01-microsoft-sentinel.png)

### Commercial threat intelligence: Intel 471

2. Review Intel 471's **Cyber Threat Exposure** platform, an example of a commercial threat-intelligence provider:

   ```
   https://www.intel471.com/platform/cyber-threat-exposure
   ```

   ![Intel 471](../screenshots/exercise-2/e2-02-intel471-threat-exposure.png)

3. Download the product brief.

   ![Download the brief](../screenshots/exercise-2/e2-03-intel471-brief-download.png)

4. The brief describes three monitoring areas: **Attack Surface Exposure** (exposed assets and misconfigurations), **Third-Party Exposure** (risk from vendors and partners) and **Brand Exposure** (impersonation across lookalike sites, social platforms and underground forums). These are the same areas I assessed manually in Exercise 1.

   ![Intel 471 brief](../screenshots/exercise-2/e2-04-intel471-brief.png)

### Research honeynet: CIC Honeynet

5. Browse to the CIC Honeynet project, which runs decoy systems (honeypots) to capture real attacker behavior:

   ```
   https://honeynetproject.com
   ```

   ![CIC Honeynet](../screenshots/exercise-2/e2-05-cic-honeynet.png)

6. Review the project's services: live threat hunting, a real-time attack map and bi-weekly traffic reports.

   ![Honeynet services](../screenshots/exercise-2/e2-06-honeynet-services.png)

7. Open the **Real-time Attack Map**. The T-Pot honeypot platform recorded **134,593 attacks in 24 hours** (**8,605 in the last hour**), including SSH brute-force attempts captured by **Cowrie** on port 22, VNC probes on port 5900 and VoIP (SIP) abuse on port 5060.

   > **Any internet-facing service is attacked within minutes of going online. Honeynet data shows which services and source regions are most active, which helps prioritize what to harden and monitor.**

   ![T-Pot attack map](../screenshots/exercise-2/e2-07-tpot-live-attack-map.png)

8. Review the honeypot software used in the project, including **T-Pot**, **Cowrie** (SSH/Telnet), **Conpot** (industrial control systems) and **Artillery**.

   ![Honeynet software](../screenshots/exercise-2/e2-08-honeynet-software.png)

   ![Honeypot software list](../screenshots/exercise-2/e2-09-honeypot-software-list.png)

---

## Task 2 – Hunt for Logon Events in the Windows Security Log

1. To generate evidence to hunt for, I deliberately entered an incorrect password several times at the **corp-wks-001** sign-in screen, then signed in successfully.

   ![Failed logon test](../screenshots/exercise-2/e2-10-failed-logon-test.png)

2. Open **Event Viewer** from the Start menu.

   ![Open Event Viewer](../screenshots/exercise-2/e2-11-open-event-viewer.png)

3. Go to **Windows Logs → Security**. In the Actions pane, click **Find…** and search for:

   ```
   4624
   ```

   ![Find 4624](../screenshots/exercise-2/e2-12-security-log-find.png)

4. **Event ID 4624 – An account was successfully logged on.** The successful logon was recorded at **1:34:33 PM**.

   ![Event 4624](../screenshots/exercise-2/e2-13-event-4624.png)

5. Just before it, the log shows a series of **Event ID 4625 – An account failed to log on** entries, flagged as **Audit Failure**, at **1:34:23, 1:34:24, 1:34:26 and 1:34:28 PM**.

   > **Finding:** Four failed logons in five seconds, immediately followed by a success, is the classic signature of a **password-guessing attack that worked**. In a real environment, I would confirm whether the user made the attempts, check the source workstation and logon type, and reset the credential if the activity wasn't legitimate.

   ![Event 4625](../screenshots/exercise-2/e2-14-event-4625.png)

6. The **Details** tab shows each event's raw fields, such as the account name, domain, logon ID and process, which are the data points a SIEM parses and correlates.

   ![Event details](../screenshots/exercise-2/e2-15-event-details-view.png)

   | Event ID | Meaning | Hunting use |
   |----------|---------|-------------|
   | **4624** | Successful logon | Off-hours logons, unusual source hosts |
   | **4625** | Failed logon | Brute force and password spraying |
   | **4672** | Special privileges assigned | Administrator activity |
   | **4648** | Logon with explicit credentials | Lateral movement, `runas` use |

---

## Task 3 – Map Activity to MITRE ATT&CK

1. Browse to the **Active Scanning (T1595)** technique:

   ```
   https://attack.mitre.org/techniques/T1595/
   ```

   Active scanning is reconnaissance that directly probes victim infrastructure, unlike the passive OSINT in Exercise 1, which never touched the target. Then open **Tactics → Enterprise**.

   ![T1595](../screenshots/exercise-2/e2-16-mitre-t1595.png)

2. The Enterprise matrix organizes adversary behavior into **15 tactics**, each representing the attacker's goal at that stage. Select **Reconnaissance**.

   ![Enterprise tactics](../screenshots/exercise-2/e2-17-mitre-enterprise-tactics.png)

3. **Reconnaissance (TA0043)** contains **12 techniques** that adversaries use to gather information for planning future operations.

   ![Reconnaissance](../screenshots/exercise-2/e2-18-mitre-reconnaissance.png)

4. Select **Privilege Escalation (TA0004)**, the tactic attackers use to gain higher-level permissions such as SYSTEM, local administrator or domain administrator.

   ![Privilege Escalation](../screenshots/exercise-2/e2-19-mitre-privilege-escalation.png)

5. Review its **13 techniques** and select **Abuse Elevation Control Mechanism**.

   ![Privilege Escalation techniques](../screenshots/exercise-2/e2-20-mitre-privesc-techniques.png)

6. **T1548 – Abuse Elevation Control Mechanism** has **6 sub-techniques**, including **Bypass User Account Control**, and applies to Windows, Linux, macOS and cloud platforms.

   > **Mapping a detection to an ATT&CK technique tells the whole team what the alert means, which stage of the attack it represents and what the attacker is likely to try next.**

   ![T1548](../screenshots/exercise-2/e2-21-mitre-t1548.png)

---

## Task 4 – Enable Firewall Logging with Group Policy

Firewall logs record which connections were allowed and blocked. Without them, investigators can't reconstruct network activity during an incident.

1. On **corp-dc-001**, open **Server Manager → Tools → Group Policy Management**.

   ![Open GPMC](../screenshots/exercise-2/e2-22-open-gpmc.png)

2. Expand **Forest → Domains → corp.polarizedsystems.com**, right-click **Default Domain Policy** and select **Edit**.

   ![Edit Default Domain Policy](../screenshots/exercise-2/e2-23-edit-default-domain-policy.png)

3. Navigate to:

   ```
   Computer Configuration > Policies > Administrative Templates > Network >
   Network Connections > Windows Defender Firewall > Domain Profile
   ```

   Double-click **Windows Defender Firewall: Allow logging**.

   ![Domain Profile](../screenshots/exercise-2/e2-24-firewall-domain-profile.png)

4. Select **Enabled**, check **Log dropped packets** and **Log successful connections**, keep the default log path `%systemroot%\system32\LogFiles\Firewall\pfirewall.log`, and click **OK**.

   ![Allow logging settings](../screenshots/exercise-2/e2-25-allow-logging-settings.png)

5. The setting now shows **Enabled**. It applies to every domain-joined computer at the next Group Policy refresh.

   > **Production note:** The default **4 MB** log size fills quickly on a busy host. In production I would raise the size limit and forward firewall logs to the SIEM. For newer systems, the same settings can also be managed under *Windows Settings → Security Settings → Windows Defender Firewall with Advanced Security*.

   ![Allow logging enabled](../screenshots/exercise-2/e2-26-allow-logging-enabled.png)

6. Close the Group Policy Management Editor and console.

   ![Close GPMC](../screenshots/exercise-2/e2-27-close-gpmc.png)

---
>
> "### 🎤 Stakeholder Takeaway

"Effective threat intelligence combines external threat research with internal security monitoring. By analyzing honeypot activity, identifying password-guessing attempts in system logs, and mapping findings to MITRE ATT&CK, we gain better visibility into attacker behavior. **Centralized logging and threat intelligence help us detect, investigate, and respond to security threats more effectively."

---

[← Previous: Exercise 1 – OSINT](../exercise-1-osint-collection-methods/README.md) | [Back to Lab Overview](../README.md)
