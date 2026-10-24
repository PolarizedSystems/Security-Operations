# Exercise 1 – Analyze Resource Utilization

[← Back to Lab Overview](../README.md)

---

## Overview

This exercise demonstrates the use of system resource monitoring and performance analysis to identify abnormal activity and potential security threats across Windows and Linux environments.

Using Microsoft Sysinternals Process Explorer and Linux utilities such as top and htop, I examined running processes, CPU utilization, memory consumption, and overall system performance.

Monitoring these resources provides valuable insight into performance anomalies, unauthorized processes, and suspicious system behavior.

The objective is to develop practical experience in system administration, resource monitoring, performance troubleshooting, and security analysis within the Polarized Systems SOC environment.

## Devices

- **corp-win-svr-001** – Windows Server – member server – Process Explorer (192.168.20.7)
- **corp-rhel-001** – Rocky Linux 10 – `top` / `htop` (192.168.20.4)

---

## Task 1 – Monitor Windows Resource Utilization with Process Explorer

Process Explorer is a free Microsoft Sysinternals tool and the professional upgrade to Task Manager — it shows the full process tree, the handles and DLLs each process holds, and deep per-resource telemetry.

1. On **corp-win-svr-001**, open the downloaded Process Explorer folder.

   ![Process Explorer folder](screenshots/exercise-1/e1-01-open-process-explorer-folder.png)

2. Run the 64-bit executable, **procexp64.exe**.

   ![Select procexp64](screenshots/exercise-1/e1-02-select-procexp64.png)

3. Accept the Sysinternals license agreement on first launch.

   ![License agreement](screenshots/exercise-1/e1-03-license-agreement.png)

4. The main view lists every process with its CPU, private bytes, working set and PID, color-coded by type. The process **tree** (indentation) shows parent/child relationships — a key tell, since malware often launches from an unexpected parent.

   ![Process Explorer processes](screenshots/exercise-1/e1-04-process-explorer-processes.png)

5. Open **View → System Information → Summary** for an at-a-glance dashboard of CPU, commit, physical memory, I/O, network and disk.

   > **Analyst note — NetBIOS name:** the **Host** field here reads `CORP-WIN-SVR-00`, while the server's actual name is `corp-win-svr-001`. The full name is 16 characters, but a legacy **NetBIOS** computer name is capped at **15**, so Windows truncates the last character. DNS and Active Directory use the full `corp-win-svr-001`; only the legacy NetBIOS label is shortened. It's a good reminder to keep hostnames at 15 characters or fewer to avoid this mismatch in production.

   ![System Information summary](screenshots/exercise-1/e1-05-system-information-summary.png)

6. Review the **CPU** tab — overall utilization, context-switch and interrupt deltas, and the topology (2 cores / 2 logical processors).

   ![System Information CPU](screenshots/exercise-1/e1-06-system-information-cpu.png)

7. Review the **Memory** tab — commit charge, physical memory, paging lists and kernel memory. A steadily climbing commit charge with no matching workload is a classic sign of a leak or staged data.

   ![System Information memory](screenshots/exercise-1/e1-07-system-information-memory.png)

8. Review the **I/O** tab — read/write/other deltas across disk and network. A spike here with no legitimate cause can indicate data exfiltration or a flood.

   ![System Information I/O](screenshots/exercise-1/e1-08-system-information-io.png)

9. Review the **Devices** tab — per-device disk, network adapter and GPU activity, with identities and utilization, then click **OK**.

   ![System Information devices](screenshots/exercise-1/e1-09-system-information-devices.png)

10. Close Process Explorer.

    ![Close Process Explorer](screenshots/exercise-1/e1-10-close-process-explorer.png)

> ### 🔎 What to watch for
> Process Explorer turns "the server feels slow" into specifics: *which* process, consuming *which* resource, launched by *which* parent. In an investigation the high-value signals are an unfamiliar process consuming heavy CPU, a process whose parent doesn't make sense (e.g. a shell spawned by a browser), and network I/O that doesn't match the server's job.

---

## Task 2 – Monitor Linux Resource Utilization with top and htop

I monitored the Linux server over SSH, the way an analyst reaches a headless server.

11. On **corp-win-svr-001**, open **Terminal (Admin)**.

    ![Open Terminal (Admin)](screenshots/exercise-1/e1-11-open-terminal-admin.png)

12. SSH into the Rocky Linux server:

    ```bash
    ssh admin@192.168.20.4
    ```

    ![SSH to corp-rhel-001](screenshots/exercise-1/e1-12-ssh-to-rhel.png)

13. Run `top`, limiting it to a fixed number of refreshes:

    ```bash
    top -n 10
    ```

    ![top -n 10 command](screenshots/exercise-1/e1-13-top-n10-command.png)

14. `top` shows live process activity sorted by resource use, with a header summarizing load average, tasks, CPU and memory.

    *The header is the quick read: **load average** shows how busy the CPU queue is, and the task/CPU/memory lines summarize the whole system at a glance.*

    ![top -n 10 output](screenshots/exercise-1/e1-14-top-n10-output.png)

15. Run `top` again in its continuous (interactive) mode:

    ```bash
    top
    ```

    ![top command](screenshots/exercise-1/e1-15-top-command.png)

16. The display refreshes in place, updating process stats in real time.

    ![top output](screenshots/exercise-1/e1-16-top-output.png)

17. Inside `top`, press **z** to colorize the output, which makes running processes and resource columns easier to scan.

    ![top colorized](screenshots/exercise-1/e1-17-top-colorized.png)

18. The colorized view highlights active processes against idle ones. Press **q** to quit `top`.

    ![top colorized full](screenshots/exercise-1/e1-18-top-colorized-full.png)

19. For a richer, interactive view I installed **htop**. On Rocky Linux htop lives in the **EPEL** repository, so I added that first:

    ```bash
    sudo dnf install epel-release
    ```

    ![Install EPEL command](screenshots/exercise-1/e1-19-install-epel-command.png)

20. EPEL (Extra Packages for Enterprise Linux) installs successfully.

    > **Enterprise note:** EPEL is a trusted, community-maintained repository of extra packages for RHEL-family systems. Adding a repository is a deliberate, auditable step — in production you control which repositories a server trusts so you only install vetted software.

    ![EPEL installed](screenshots/exercise-1/e1-20-epel-installed.png)

21. Install htop from EPEL:

    ```bash
    sudo dnf install htop -y
    ```

    ![Install htop command](screenshots/exercise-1/e1-21-install-htop-command.png)

22. htop and its dependencies install and complete.

    ![htop installed](screenshots/exercise-1/e1-22-htop-installed.png)

23. Launch htop:

    ```bash
    htop
    ```

    ![htop command](screenshots/exercise-1/e1-23-htop-command.png)

24. htop shows per-core meters, a memory/swap gauge and a scrollable, sortable process list, with function keys along the bottom.

    ![htop running](screenshots/exercise-1/e1-24-htop-running.png)

25. Press **F6** to sort the process list by a chosen column (CPU, memory, etc.).

    ![htop sort by](screenshots/exercise-1/e1-25-htop-sort-by.png)

26. Press **F10** to quit htop.

    ![htop quit](screenshots/exercise-1/e1-26-htop-quit.png)

27. Type `exit` to close the SSH session and return to the Windows terminal.

    ![Exit SSH](screenshots/exercise-1/e1-27-exit-ssh.png)

---

> "We can see exactly how our servers are behaving, on both Windows and Linux. On Windows, Process Explorer shows every running process, what it's using, and what launched it so an unfamiliar program chewing up CPU or sending unexpected network traffic stands out immediately. On Linux, the same visibility comes built in with a single command. Once we know what normal looks like, abnormal becomes obvious, and that's usually our first clue that something's wrong."

---

[← Back to Lab Overview](../README.md) | [Next: Exercise 2 – Analyze Account & Group Management →](../exercise-2-analyze-account-and-group-management/README.md)
