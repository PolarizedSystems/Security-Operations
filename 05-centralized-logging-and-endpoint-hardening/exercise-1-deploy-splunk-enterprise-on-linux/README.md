# Exercise 1 – Deploy Splunk Enterprise on Linux

[← Back to Lab Overview](../README.md)

---

## Exercise 1 – Log Collection with Splunk

### Overview

As a **Systems Specialist**, centralized log collection is essential for identifying suspicious activity, monitoring security events, and supporting investigations across enterprise infrastructure.

In this exercise, I deployed **Splunk Enterprise on a Rocky Linux server** within the Polarized Systems SOC environment to establish a centralized logging platform. I also installed and configured the **Splunk Universal Forwarder on a Windows endpoint (`corp-wks-001`)** to collect and transmit Windows event logs to the Splunk Enterprise server.

The exercise focuses on three primary objectives:

- **Splunk Enterprise Deployment:** Installed and configured Splunk Enterprise on Rocky Linux for centralized security monitoring.
- **Windows Endpoint Integration:** Deployed the Splunk Universal Forwarder to collect and forward Windows event logs.
- **Centralized Log Collection:** Verified successful log ingestion to support security event analysis and investigation.

> **This exercise demonstrated practical experience in **SIEM deployment, endpoint integration, centralized log management, and security monitoring** across Windows and Linux infrastructure.**

## Devices

- **soc-splunk-002** – Rocky Linux 10 – Splunk Enterprise indexer / SIEM (192.168.40.10)
- **corp-wks-001** – Windows 11 – Splunk Universal Forwarder (log source) (192.168.30.3)

---

## Task 1 – Prepare and Verify the Linux Server

Before installing anything, confirm you are on the right host, the OS is what you expect, and the system is fully patched. In an enterprise you never deploy onto an unknown or out-of-date baseline.

1. On **soc-splunk-002**, open a terminal.

   ![Terminal on soc-splunk-002](screenshots/exercise-1/e1-01-terminal-soc-splunk-002.png)

2. Confirm the hostname and operating system:

   ```bash
   hostnamectl
   cat /etc/redhat-release
   ```

   This confirms the static hostname **`soc-splunk-002`**, **Rocky Linux 10.1 (Red Quartz)**, and that the machine is a VMware virtual guest — exactly the baseline we intend to build on.

   ![hostnamectl verification](screenshots/exercise-1/e1-02-hostnamectl-verification.png)

3. Check the system state before changes.

   ![System check](screenshots/exercise-1/e1-03-system-check.png)

4. Patch the server to current before installing new software:

   ```bash
   sudo dnf update && sudo dnf upgrade -y
   ```

   ![dnf update](screenshots/exercise-1/e1-04-dnf-update.png)

5. The update completes and the baseline is current.

   ![dnf update complete](screenshots/exercise-1/e1-05-dnf-update-complete.png)

6. Create a dedicated, non-login service account for Splunk rather than running it as `root`:

   ```bash
   sudo useradd splunk
   tail /etc/passwd
   ```

   ![Create the splunk service account](screenshots/exercise-1/e1-06-create-splunk-user.png)

> 🔎 **Why a dedicated service account?** Running Splunk as `root` means any flaw in the application runs with full control of the host. A purpose-built `splunk` account enforces least privilege — if the service is ever compromised, the blast radius is limited to what that one account can touch. This is standard practice for every production service, not just Splunk.

---

## Task 2 – Install Splunk Enterprise

7. Log into a workstation with a browser to reach the Splunk download portal.

   ![Log into the workstation](screenshots/exercise-1/e1-07-login-workstation.png)

8. Open a web browser.

   ![Open the browser](screenshots/exercise-1/e1-08-open-browser.png)

9. Browse to the Splunk Enterprise download page.

   ![Splunk download page](screenshots/exercise-1/e1-09-splunk-download-page.png)

10. Select the **Linux** `.tgz`/`.rpm` package and copy the direct download (`wget`) link so the server can pull it itself — no file shuffling between machines.

    ![Choose the Linux package](screenshots/exercise-1/e1-10-choose-linux-package.png)

11. Back on the server, create a clean staging directory for the installer:

    ```bash
    sudo mkdir -p /opt/installers
    cd /opt/installers
    ```

    ![Create the installer directory](screenshots/exercise-1/e1-11-create-installer-dir.png)

12. Download the Splunk package directly to the server with the copied link:

    ```bash
    sudo wget -O splunk.rpm "<copied-download-link>"
    ```

    ![Download Splunk](screenshots/exercise-1/e1-12-download-splunk.png)

13. Install the package:

    ```bash
    sudo dnf install ./splunk.rpm -y
    ```

    ![Install the Splunk RPM](screenshots/exercise-1/e1-13-install-splunk-rpm.png)

14. The installer lays Splunk down under **`/opt/splunk`**.

    ![Install output](screenshots/exercise-1/e1-14-install-output.png)

15. Start Splunk for the first time, accepting the license, then hand ownership of the service to `systemd` under the `splunk` account so it survives reboots:

    ```bash
    sudo -u splunk /opt/splunk/bin/splunk start --accept-license
    sudo /opt/splunk/bin/splunk enable boot-start -user splunk -systemd-managed 1
    ```

    ![Enable boot-start](screenshots/exercise-1/e1-15-enable-boot-start.png)

16. On first start Splunk brings up its web interface. The console reports it is available at **`http://soc-splunk-002:8000`**.

    ![Splunk web interface ready](screenshots/exercise-1/e1-16-splunk-web-ready.png)

17. Confirm the install landed where expected:

    ```bash
    cd /opt/
    ls -l
    ```

    You can see both the `installers` staging directory and the `splunk` install directory owned by the `splunk` account.

    ![Verify /opt directories](screenshots/exercise-1/e1-17-verify-opt-dirs.png)

---

## Task 3 – Run Splunk as a Managed Service

18. Register Splunk as a `systemd`-managed boot-start service (this creates the `Splunkd` unit):

    ```bash
    sudo /opt/splunk/bin/splunk enable boot-start -user splunk -systemd-managed 1
    ```

    ![Enable boot-start as a systemd service](screenshots/exercise-1/e1-18-enable-boot-start-systemd.png)

19. Confirm the service is active and healthy:

    ```bash
    systemctl status Splunkd
    ```

    ![systemctl status Splunkd](screenshots/exercise-1/e1-19-systemctl-status-splunkd.png)

20. Confirm Splunk is listening on its ports:

    ```bash
    sudo ss -tlnp
    ```

    ![ss -tlnp listening ports](screenshots/exercise-1/e1-20-ss-tlnp-ports.png)

> 🔎 **Why run it under `systemd`?** A SIEM that stops collecting after a reboot is a blind spot nobody notices until an incident. Registering `Splunkd` as a `systemd` service means the collector comes back automatically on every restart and can be managed with the same `systemctl` tooling as every other service on the box — started, stopped, monitored and alerted on consistently.

---

## Task 4 – Open the Firewall and Access the Console

21. Rocky Linux ships with `firewalld` blocking inbound ports by default. Open the web console port (8000):

    ```bash
    sudo firewall-cmd --permanent --add-port=8000/tcp
    sudo firewall-cmd --reload
    sudo firewall-cmd --list-ports
    ```

    ![Open firewall port 8000](screenshots/exercise-1/e1-21-firewall-open-8000.png)

22. Browse to **`http://192.168.40.10:8000`** and sign in with the admin account created during setup.

    ![Splunk web login](screenshots/exercise-1/e1-22-splunk-web-login.png)

23. Dismiss the product-usage prompt.

    ![Usage data prompt](screenshots/exercise-1/e1-23-usage-data-prompt.png)

---

## Task 5 – Enable Receiving (TCP 9997)

For the indexer to accept forwarded data it must be told to listen for it.

24. Go to **Settings → Forwarding and receiving**.

    ![Settings – Forwarding and receiving](screenshots/exercise-1/e1-24-settings-forwarding-receiving.png)

25. Under **Receive data**, click **Configure receiving → Add new**.

    ![Configure receiving – Add new](screenshots/exercise-1/e1-25-configure-receiving-add-new.png)

26. Set the listen port to **9997** (the Splunk convention for forwarder traffic) and **Save**.

    ![Listen on port 9997](screenshots/exercise-1/e1-26-receiving-port-9997.png)

27. Open the matching firewall port on the server so forwarders can reach it:

    ```bash
    sudo firewall-cmd --permanent --add-port=9997/tcp
    sudo firewall-cmd --reload
    ```

    ![Open firewall port 9997](screenshots/exercise-1/e1-27-firewall-open-9997.png)

28. Confirm the indexer is now listening on 9997:

    ```bash
    sudo ss -tlnp | grep 9997
    ```

    ![ss -tlnp 9997](screenshots/exercise-1/e1-28-ss-tlnp-9997.png)

> 🔎 **Port 8000 vs. port 9997.** `8000` is the **web console** humans log into. `9997` is the **data-receiving port** forwarders push events to. They are deliberately separate, and in production only `9997` needs to be reachable from the endpoint subnets — the console can be locked down to the admin network. Opening only the ports you need, and only from where you need them, is the whole point of the host firewall.

---

## Task 6 – Install the Universal Forwarder on the Endpoint

29. On **corp-wks-001**, browse to the Splunk **Universal Forwarder** download page and get the Windows 64-bit `.msi`.

    ![Universal Forwarder download page](screenshots/exercise-1/e1-29-uf-download-page.png)

30. The installer downloads.

    ![Universal Forwarder MSI downloaded](screenshots/exercise-1/e1-30-uf-msi-downloaded.png)

31. Launch the installer and accept the license agreement.

    ![Accept the license agreement](screenshots/exercise-1/e1-31-uf-license-agreement.png)

32. Proceed to install.

    ![Begin install](screenshots/exercise-1/e1-32-uf-install-begin.png)

33. The first run completes, but a default install never prompts for an indexer or inputs — so it would sit there doing nothing.

    ![First install finished](screenshots/exercise-1/e1-33-uf-first-install-finish.png)

> 🔎 **Gotcha — you must choose "Customize Options".** The modern Universal Forwarder MSI performs a silent minimal install unless you explicitly click **Customize Options** on the first screen. Without it, the forwarder is installed but has no receiving indexer and no inputs defined — it collects nothing. The fix below reinstalls with the full wizard so the indexer and Windows event-log inputs are actually configured.

34. Reinstall, and this time click **Customize Options** on the first screen.

    ![Customize Options](screenshots/exercise-1/e1-34-uf-customize-options.png)

35. Accept the default install location.

    ![Install location](screenshots/exercise-1/e1-35-uf-install-location.png)

36. Install the forwarder to run as **Local System** so it can read all Windows event logs.

    ![Install as Local System](screenshots/exercise-1/e1-36-uf-install-as-local-system.png)

37. Select the Windows event logs to forward — **Application, Security, System and Forwarded Events**.

    ![Select Windows Event Logs](screenshots/exercise-1/e1-37-uf-windows-event-logs.png)

38. Set the forwarder's local admin credentials.

    ![Forwarder admin credentials](screenshots/exercise-1/e1-38-uf-admin-credentials.png)

39. Leave the **Deployment Server** blank — this environment points forwarders straight at the indexer.

    ![Deployment server (blank)](screenshots/exercise-1/e1-39-uf-deployment-server.png)

40. Set the **Receiving Indexer** to the Splunk server: **`192.168.40.10 : 9997`**.

    ![Receiving indexer 192.168.40.10:9997](screenshots/exercise-1/e1-40-uf-receiving-indexer.png)

41. Install.

    ![Install the forwarder](screenshots/exercise-1/e1-41-uf-install.png)

42. The Universal Forwarder install completes.

    ![Install complete](screenshots/exercise-1/e1-42-uf-install-complete.png)

43. Confirm the forwarder is running as a Windows service — open **Services**.

    ![Open Services](screenshots/exercise-1/e1-43-open-services.png)

44. The **SplunkForwarder** service is present and **Running**.

    ![SplunkForwarder service running](screenshots/exercise-1/e1-44-splunkforwarder-service-running.png)

---

## Task 7 – Verify Receiving and Confirm Data Flow

45. Back on the indexer's console, open a browser.

    ![Open the browser](screenshots/exercise-1/e1-45-open-browser-2.png)

46. Sign in to Splunk.

    ![Splunk web login](screenshots/exercise-1/e1-46-splunk-web-login-2.png)

47. Return to **Settings → Forwarding and receiving**.

    ![Settings – Forwarding and receiving](screenshots/exercise-1/e1-47-settings-forwarding-receiving-2.png)

48. Open **Configure receiving**.

    ![Configure receiving](screenshots/exercise-1/e1-48-configure-receiving-verify.png)

49. Confirm port **9997** is listed and **Enabled**.

    ![Receiving 9997 enabled](screenshots/exercise-1/e1-49-receiving-9997-enabled.png)

50. Open the **Search & Reporting** app.

    ![Open Search & Reporting](screenshots/exercise-1/e1-50-open-search-app.png)

51. The search landing page.

    ![Search landing page](screenshots/exercise-1/e1-51-search-landing.png)

52. Run the first verification search to prove the forwarder is connected and checking in:

    ```spl
    index=_internal host="corp-wks-001"
    ```

    This returns **2,340 events**, and the `tcpout_connections` metric event shows the forwarder shipping to `destIp=192.168.40.10, destPort=9997` — the entire pipeline confirmed from the data itself.

    ![Search _internal from the forwarder](screenshots/exercise-1/e1-52-search-internal-forwarder.png)

> 🔎 **Reading the proof in the data.** `index=_internal` is Splunk's own operational log. Seeing `host="corp-wks-001"` events in it — specifically the `tcpout` metrics naming the indexer IP and port **9997** — is definitive proof the forwarder established its connection and is actively streaming. This is the first thing to check when onboarding any new log source: is the forwarder *talking* before you worry about *what* it's sending.

53. Confirm the actual Windows events are landing, not just the forwarder's own chatter:

    ```spl
    host="corp-wks-001"
    ```

    ![Search endpoint events](screenshots/exercise-1/e1-53-search-endpoint-events.png)

54. Break the incoming data down by source type:

    ```spl
    host="corp-wks-001" | stats count by sourcetype
    ```

    All three Windows channels are present and indexing: **`WinEventLog:Application`**, **`WinEventLog:Security`** and **`WinEventLog:System`**.

    ![Stats by sourcetype](screenshots/exercise-1/e1-54-stats-by-sourcetype.png)

55. The Splunk deployment is live, receiving and searchable — a working central log collector for the environment.

    ![Splunk home](screenshots/exercise-1/e1-55-splunk-home.png)

---

## Takeaway

Every Windows endpoint can now ship its security, system and application logs to a single hardened collector, where they are retained out of an attacker's reach and searchable in seconds. That is the foundation every other detection capability is built on — failed-logon hunting, privilege-escalation alerting, incident timelines and compliance reporting all depend on the logs being in one trustworthy place. Before this, an investigation meant logging into each machine individually and hoping the local logs hadn't rolled over or been tampered with; now it is a single search.

---

[← Back to Lab Overview](../README.md) | [Next: Exercise 2 – Encrypting Sensitive Data →](../exercise-2-encrypting-sensitive-data/README.md)
