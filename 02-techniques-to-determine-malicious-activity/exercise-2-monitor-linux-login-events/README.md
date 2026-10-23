# Exercise 2 – Monitor Login Events on Linux Devices

[← Back to Lab Overview](../README.md)

---

## Overview

This exercise demonstrates the application of Linux authentication monitoring and security log analysis to identify suspicious login activity and potential unauthorized access on a Rocky Linux server within the Polarized Systems SOC environment.

Using Linux utilities such as last, I examined user login history, failed authentication attempts, and system reboot records to identify unusual activity and potential security threats.

> **The objective is to understand some basics with monitoring logon events on a Linux server.**

## Devices

- **corp-rhel-001** – Rocky Linux 10 – login-monitoring target (192.168.20.4)
- **corp-dc-001** – Windows Server – source of the simulated SSH attack (192.168.20.2)

---

## Task 1 – Review Login and Reboot History

1. On **corp-rhel-001**, confirm the host with `hostnamectl` — a Rocky Linux 10 virtual machine.

   ```bash
   hostnamectl
   ```

   ![hostnamectl](screenshots/exercise-2/e2-01-rhel-hostnamectl.png)

2. List the login history, full width so no names are truncated:

   ```bash
   sudo last -w
   ```

   ![last -w](screenshots/exercise-2/e2-02-last-w.png)

   *Each row is a session: the account, the terminal, the source, and the start/stop time. `admin` sessions on `tty1` are local console logins; sessions on `pts/0` with an IP address are remote. The historical `redhat` logins from `192.168.140.1` show this host's earlier life — exactly the kind of leftover access an analyst reviews.*

> ### 🔎 How `last` works
> `last` reads **`/var/log/wtmp`**, the binary ledger the system appends to on every login, logout and reboot. The key tell in the output is the terminal column: **`tty`** entries are logins at the physical console, while **`pts/N`** entries (pseudo-terminals) are *remote* sessions — someone connecting over the network, almost always via SSH. Pairing a `pts` session with a source IP answers the first question of any access review: *who connected, and from where?*

3. Show just the reboot history:

   ```bash
   sudo last reboot
   ```

   ![last reboot](screenshots/exercise-2/e2-03-last-reboot.png)

   *Each line is a system boot. An unexpected reboot can mean a crash, maintenance — or an attacker forcing a restart, so an unexplained entry here is worth investigating.*

4. Show the login history again, this time resolving the **source IP** of every session:

   ```bash
   sudo last -w -i
   ```

   ![last -w -i](screenshots/exercise-2/e2-04-last-w-i.png)

   *The `-i` flag prints numeric IPs instead of hostnames. Local console logins show `0.0.0.0`; remote sessions show the real address they came from — the detail you need to decide whether a login was legitimate.*

---

## Task 2 – Simulate and Detect an SSH Brute-Force Attack

With a baseline of normal activity established, I generated an attack from **corp-dc-001** and confirmed it surfaced in the Linux records.

1. From **corp-dc-001**, attempt to SSH into the Rocky server with wrong passwords. After three failures OpenSSH refuses the connection:

   ```
   ssh admin@192.168.20.4
   ```

   ![SSH brute force](screenshots/exercise-2/e2-05-ssh-brute-force.png)

   *Three `Permission denied` responses, then the connection is closed — the server-side defense (`MaxAuthTries`) cutting off a password-guessing attempt.*

2. Back on **corp-rhel-001**, show the full timestamps of the most recent session with `last -F`:

   ```bash
   sudo last -F
   ```

   ![last -F remote session](screenshots/exercise-2/e2-06-last-F-remote-session.png)

   *`-F` prints complete login and logout times. The remote session from `192.168.20.2` is recorded to the second — precise enough to correlate against other logs during an investigation.*

3. Now SSH in from **corp-dc-001** with the **correct** password. The login succeeds, and the server's own login banner reports the attack:

   ```
   ssh admin@192.168.20.4
   ```

   ![SSH banner reports failed attempts](screenshots/exercise-2/e2-07-ssh-banner-failed-attempts.png)

   > **The system reports the attack itself:** *"Last failed login: Sun Oct 18 00:26:00 … from 192.168.20.2 … There were 3 failed login attempts since the last successful login."*

> ### 🔎 Why this is the critical finding
> This is the exact pattern a SOC analyst watches for: **a run of failed logins immediately followed by a success, all from the same source.** On its own, a successful login is unremarkable. Preceded by three failures from `192.168.20.2`, it reads as a password-guessing attack that *eventually worked* — the single most important sequence to catch, because it marks the moment prevention failed and the attacker got in. Linux surfaces it two ways at once: the login banner announces it to anyone who signs in, and the `last` records preserve it for investigation.

4. Confirm the intruder's session in the login history. The attacker — now using valid credentials from `192.168.20.2` — is **still logged in**:

   ```bash
   sudo last -w
   ```

   ![last -w shows the intruder](screenshots/exercise-2/e2-08-last-w-intruder.png)

   *A `pts/1` session from `192.168.20.2` marked **still logged in**: a remote user on the box right now. In a real incident this is where containment begins — verify the session is unauthorized, terminate it, rotate the credential, and investigate what the account did while connected.*

---

> ### 🎤 Stakeholder Takeaway
>
> "On the Linux side we showed that the server already keeps a complete record of everyone who logs in and where they came from — no extra software needed. We simulated an attacker guessing passwords over SSH, and the server captured all of it: three failed attempts, then a successful break-in from the same address, with the system even announcing the failed attempts at login. The lesson for the business is that this evidence is already being collected on every Linux server we run; the value is in reviewing it. A single command tells us whether anyone is on a server who shouldn't be, and from where — which is the first question we ask in any investigation."

---

[← Previous: Exercise 1 – Monitor Windows Event Logs](../exercise-1-monitor-windows-event-logs/README.md) | [Back to Lab Overview](../README.md)
