# Exercise 1 – Monitor Windows Event Logs with a PowerShell Script

[← Back to Lab Overview](../README.md)

---

## Overview

Monitoring Windows logs for malicious activity is one of the most common jobs in a Security Operations Center — and one of the most repetitive, which is exactly why it gets scripted. In this exercise I turned on the auditing that records logon attempts, generated a password-guessing attack from an isolated Kali host, and then wrote a PowerShell script to pull the resulting failed-logon events out of the Security log and display them for analysis. Finally, I configured the firewall so the same hunt could be run remotely from an analyst workstation, which is how this is done at scale in production.

> **The detection chain:** *Audit policy records the events → the attack generates them → the PowerShell script surfaces them.* Remove any link and the attacker is invisible.

## Devices

- **corp-dc-001** – Windows Server – Domain Controller – Group Policy, PowerShell ISE (192.168.20.2)
- **soc-kali-001** – Kali Linux – attack simulation (192.168.40.5)
- **corp-wks-001** – Windows 11 – analyst workstation for remote collection (192.168.30.3)

---

## Task 1 – Enable Logon Auditing with Group Policy

1. On **corp-dc-001**, open **Server Manager → Tools → Group Policy Management**.

   ![Open Group Policy Management](screenshots/exercise-1/e1-01-server-manager-gpmc.png)

2. Expand **Forest → Domains → corp.polarizedsystems.com**, right-click **Default Domain Policy** and select **Edit**.

   ![Edit Default Domain Policy](screenshots/exercise-1/e1-02-edit-default-domain-policy.png)

3. Navigate to **Computer Configuration → Policies → Windows Settings → Security Settings → Local Policies → Audit Policy**.

   ![Navigate to Audit Policy](screenshots/exercise-1/e1-03-navigate-audit-policy.png)

4. Right-click **Audit logon events** and select **Properties**.

   ![Audit logon events properties](screenshots/exercise-1/e1-04-audit-logon-events-properties.png)

5. Tick **Define these policy settings**, then check both **Success** and **Failure**, and click **OK**.

   ![Audit success and failure](screenshots/exercise-1/e1-05-audit-success-failure.png)

> ### 🔎 Why audit both success and failure
> Auditing **failures** catches the attack in progress — a burst of failed logons is the classic brute-force signature. Auditing **successes** catches the attack that *worked*: a successful logon right after a wave of failures is far more alarming than either event alone. Logging only failures would hide the most important moment — the breach itself. Every logged logon is written to the Security log with an **Event ID**: **4625** for a failed logon and **4624** for a successful one.

6. Under **Account Policies → Account Lockout Policy**, open **Account lockout threshold**.

   ![Account Lockout Policy](screenshots/exercise-1/e1-06-account-lockout-policy.png)

7. Tick **Define this policy setting**, set the account to lock after **4 invalid logon attempts**, and click **OK** (accepting the suggested lockout-duration values).

   ![Account lockout threshold](screenshots/exercise-1/e1-07-account-lockout-threshold.png)

> ### 🔎 Why a lockout threshold matters
> An account-lockout threshold does two jobs at once. It **slows** an attacker — after a handful of wrong guesses the account locks, making automated password-guessing impractical — and it **raises a signal**, because the lockout itself is a recordable event (**Event ID 4740**) that a monitoring system can alert on. The trade-off is availability: set it too low and ordinary users lock themselves out, so production environments balance the threshold against help-desk load.

8. Close the editor and, in an elevated **PowerShell** window, apply the policy immediately:

   ```powershell
   gpupdate /force
   ```

   ![gpupdate force](screenshots/exercise-1/e1-08-gpupdate.png)

   *Group Policy normally refreshes on a timer; `gpupdate /force` reapplies it now so the new audit settings take effect without waiting.*

---

## Task 2 – Generate Failed Logons for Detection Testing

To confirm the auditing actually works, I generated real failed-logon events from the isolated **soc-kali-001** host. This is deliberate detection testing — producing the exact telemetry an attacker would, in a controlled way, so I can verify it is captured.

1. On **soc-kali-001**, create the attack script with `nano`:

   ```bash
   nano generate-test-logins.sh
   ```

   ![Create attack script](screenshots/exercise-1/e1-09-nano-attack-script.png)

2. The script loops through a series of wrong passwords against the Domain Controller's SMB service:

   ```bash
   #!/bin/bash
   for i in $(seq 15); do
       smbclient -L //192.168.20.2 -U "testuser%WrongPassword$i" 2>/dev/null
   done
   ```

   ![Attack script contents](screenshots/exercise-1/e1-10-attack-script-contents.png)

   *Each loop asks the DC's file-sharing service to authenticate as `testuser` with a wrong password. Every rejection is logged on the DC as Event ID 4625. The full script is in [`scripts/generate-test-logins.sh`](../scripts/generate-test-logins.sh).*

3. Make the script executable:

   ```bash
   chmod +x generate-test-logins.sh
   ```

   ![chmod the script](screenshots/exercise-1/e1-11-chmod-attack-script.png)

4. Run it. Each attempt returns **`NT_STATUS_LOGON_FAILURE`** — the expected, successful result of a detection test, because every rejected logon is one more 4625 event for the hunt to find:

   ```bash
   sudo ./generate-test-logins.sh
   ```

   ![Generate failed logons](screenshots/exercise-1/e1-12-generate-failed-logons.png)

> ### 🔎 Why generate the attack yourself
> A detection control is only trustworthy if it has been proven to fire. Generating the attack traffic — here, an SMB password-guessing burst — produces known-good telemetry so I can confirm the audit policy captured it and the hunting script surfaces it. This is the blue-team practice of **detection validation**: you never assume a log source works, you test it. Because 15 rapid attempts exceeds the lockout threshold set in Task 1, this run also exercises the lockout control in passing.

---

## Task 3 – Hunt the Failed Logons with PowerShell

1. On **corp-dc-001**, open **Windows PowerShell ISE** as Administrator and enter the hunting script in the editor pane:

   ```powershell
   Get-WinEvent -ComputerName corp-dc-001 -MaxEvents 100 -FilterHashtable @{
   LogName = "Security"
   ID = (4625)
   StartTime=((Get-Date).AddDays(-1))} |
   Out-GridView
   ```

   ![PowerShell ISE script](screenshots/exercise-1/e1-13-powershell-ise-script.png)

> ### 🔎 Reading the hunting script
> | Element | What it does |
> |---------|--------------|
> | `Get-WinEvent` | Reads the Windows event logs |
> | `-ComputerName corp-dc-001` | Which host's logs to read (local or remote) |
> | `-MaxEvents 100` | Caps the result at the 100 most recent matches, keeping it fast |
> | `-FilterHashtable @{…}` | Filters **at the source** so only wanted events are returned |
> | `LogName = "Security"` | Logons are recorded in the Security log |
> | `ID = (4625)` | Return only failed-logon events |
> | `StartTime=((Get-Date).AddDays(-1))` | Only the last 24 hours |
> | `Out-GridView` | Displays the results in a sortable, filterable grid window |
>
> Filtering with a hashtable is deliberate: on a busy Domain Controller the Security log holds hundreds of thousands of events, and filtering *as the log is read* is far faster than pulling everything and filtering afterward.

2. Save the script as **Monitor-FailedLogons.ps1** in the Documents folder (**File → Save As**).

   ![Save the script](screenshots/exercise-1/e1-14-save-script.png)

3. Run the script with the green **Run** button (or **F5**).

   ![Run the script](screenshots/exercise-1/e1-15-run-script.png)

4. The grid opens with the failed logons generated from Kali — each one **Event ID 4625**, seconds apart, with **Logon Type 3**.

   ![Failed logons grid](screenshots/exercise-1/e1-16-failed-logons-grid.png)

> ### 🔎 What the results reveal
> Three details confirm this is the simulated attack, not routine noise. The events are all **4625** (failed logons); they are stamped **seconds apart**, the machine-speed cadence of an automated tool rather than a human mistyping a password; and they are **Logon Type 3** — a *network* logon, meaning the attempt arrived over the network (the SMB service) rather than from someone at the keyboard (which would be Logon Type 2). Together, rapid network failed-logons are a textbook brute-force signature.

---

## Task 4 – Enable Remote Log Collection

Running the hunt directly on the Domain Controller works, but in production an analyst collects logs *remotely* from a workstation so they never have to log in to the server being monitored. That requires opening the right firewall rule on the host whose logs are being read.

1. On the Domain Controller, open **Windows Defender Firewall** and select **Allow an app or feature through Windows Defender Firewall**. The **Domain** profile is the active, connected network (`corp.polarizedsystems.com`).

   ![Windows Defender Firewall](screenshots/exercise-1/e1-17-firewall-home.png)

2. Enable **Remote Event Log Management** and **Remote Event Monitor** for the **Domain** profile, then click **OK**.

   ![Remote Event Log Management](screenshots/exercise-1/e1-18-remote-event-log-management.png)

> ### 🔎 Why this enables centralized monitoring
> By default a server's firewall blocks the remote procedure calls that `Get-WinEvent -ComputerName` relies on. Enabling **Remote Event Log Management** on the **Domain** profile permits trusted, domain-joined hosts to read the server's event log across the network, which is the foundation of centralized monitoring — one analyst console, or a SIEM, pulling from many servers at once instead of logging into each. It is scoped to the Domain profile on purpose: the exception applies on the trusted corporate network, not on public or untrusted networks.
>
> **Production note:** a full remote pull also depends on the Remote Registry service and appropriate credentials on the target; at enterprise scale this collection is normally handled by **Windows Event Forwarding** or a SIEM agent rather than ad-hoc remote queries. In this lab the detection itself was validated by running the hunt on the Domain Controller (Task 3); this task establishes the firewall foundation that the centralized model is built on.

---

> ### 🎤 Stakeholder Takeaway
>
> "We proved that our Windows servers can actually see a password-guessing attack. First we turned on the auditing that records every logon attempt and set accounts to lock after repeated failures. Then we safely simulated the attack and used a short PowerShell script to pull those failed attempts straight out of the log — fifteen failures, seconds apart, coming in over the network. That's the exact fingerprint of an automated break-in attempt, and we can now spot it on demand. The last step opened the door to doing this centrally, so one analyst can watch every server instead of logging into each one."

---

[← Back to Lab Overview](../README.md) | [Next: Exercise 2 – Monitor Login Events on Linux →](../exercise-2-monitor-linux-login-events/README.md)
