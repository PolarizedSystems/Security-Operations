# Exercise 3 – Deploy a Linux Agent

[← Back to Lab Overview](../README.md)

---

## Overview

A real environment is never all one operating system, and neither is its monitoring. Having enrolled a Windows endpoint, I now add a **Linux agent** on `corp-ubuntu-001` so the SIEM has visibility across both platforms. The Linux agent does the same job as its Windows counterpart — collecting security events, watching files for integrity changes, and streaming telemetry to the manager — bringing the Ubuntu server under the same single pane of glass.

> 🔎 **Same model, platform-native package.** Wazuh enrollment is identical in concept across platforms — generate a command carrying the manager IP and a unique agent name, run it on the endpoint — but the package is native to the OS. Windows used an `.msi`; Ubuntu uses a `.deb` installed with `dpkg`. On Linux the agent then runs as a standard `systemd` service, started and enabled with the same `systemctl` tooling as everything else on the box.

## Devices

- **soc-wazuh-002** – Ubuntu – Wazuh manager (192.168.40.11)
- **corp-ubuntu-001** – Ubuntu 22.04 LTS – the endpoint being enrolled (192.168.20.5)

---

## Task 1 – Generate the Agent Install Command

1. In the dashboard, open **Agents → Deploy new agent**.

   ![Deploy new agent](screenshots/exercise-3/e3-01-deploy-new-agent.png)

2. Select the **Linux** package and choose **DEB amd64** (the correct package for Ubuntu).

   ![Select Linux DEB amd64](screenshots/exercise-3/e3-02-select-linux-deb.png)

3. Set the **server address** to `192.168.40.11` and the **agent name** to `corp-ubuntu-001`.

   ![Server address and agent name](screenshots/exercise-3/e3-03-server-address-agent-name.png)

4. The dashboard generates the tailored install command. Copy it.

   ![Generated install command](screenshots/exercise-3/e3-04-generated-install-command.png)

---

## Task 2 – Install the Agent on the Endpoint

5. On **corp-ubuntu-001**, open a terminal.

   ![Ubuntu terminal](screenshots/exercise-3/e3-05-ubuntu-terminal.png)

6. Paste and run the command. It downloads the `.deb` package with `wget` and installs it with `dpkg`, passing the manager IP and agent name:

   ```bash
   wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.14.9-1_amd64.deb && sudo WAZUH_MANAGER='192.168.40.11' WAZUH_AGENT_NAME='corp-ubuntu-001' dpkg -i ./wazuh-agent_4.14.9-1_amd64.deb
   ```

   ![Install the agent .deb](screenshots/exercise-3/e3-06-install-agent-deb.png)

7. Reload `systemd` so it picks up the new service unit:

   ```bash
   sudo systemctl daemon-reload
   ```

   ![systemctl daemon-reload](screenshots/exercise-3/e3-07-systemctl-daemon-reload.png)

8. Enable the agent to start on boot:

   ```bash
   sudo systemctl enable wazuh-agent
   ```

   ![systemctl enable wazuh-agent](screenshots/exercise-3/e3-08-systemctl-enable-agent.png)

9. Start the agent:

   ```bash
   sudo systemctl start wazuh-agent
   ```

   ![systemctl start wazuh-agent](screenshots/exercise-3/e3-09-systemctl-start-agent.png)

10. Confirm the agent is running:

    ```bash
    sudo systemctl status wazuh-agent
    ```

    The service is **active (running)**.

    ![systemctl status wazuh-agent](screenshots/exercise-3/e3-10-systemctl-status-agent.png)

> 🔎 **`enable` vs. `start`.** `start` runs the agent now; `enable` makes it come back automatically after a reboot. Both matter for a monitoring agent — an endpoint that stops reporting after a restart is a silent blind spot, so enabling it is what makes the coverage durable.

---

## Task 3 – Confirm Both Agents Reporting

11. Back in the dashboard, the agent summary now shows **Active (2)** — both endpoints connected.

    ![Dashboard – two agents active](screenshots/exercise-3/e3-11-dashboard-two-agents-active.png)

12. The agents list confirms both: **corp-win-svr-001** (Windows Server 2025) and **corp-ubuntu-001** (Ubuntu 22.04 LTS), each version 4.14.9 and **active** — cross-platform visibility under a single SIEM.

    ![Agents list – both agents](screenshots/exercise-3/e3-12-agents-list-both.png)

---

> ### 🎤 Stakeholder Takeaway
>
> "Our monitoring now spans both Windows and Linux from one console. The same platform that watches our Windows server is now watching our Ubuntu server too, using a package built for each system but reporting into one place. That matters because attackers don't respect platform boundaries, and neither can our visibility. With both endpoints live and healthy, we have a working, cross-platform security-monitoring capability — one dashboard, full coverage — that scales to every machine we choose to onboard next."

---

[← Previous: Exercise 2 – Deploy a Windows Agent](../exercise-2-deploy-a-windows-agent/README.md) | [Back to Lab Overview](../README.md)
