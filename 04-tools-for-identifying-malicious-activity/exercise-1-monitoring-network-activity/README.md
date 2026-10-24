# Exercise 1 – Monitoring Network Activity

[← Back to Lab Overview](../README.md)

---

## Overview

As a Information Systems Specialist, monitoring and analyzing network traffic is essential for identifying suspicious activity, detecting potential security threats, and maintaining visibility across enterprise networks.

This exercise demonstrates the use of Wireshark and tcpdump to capture and examine network traffic, providing practical experience with network monitoring and packet analysis techniques.

This exercise focuses on three primary activities:

- **Wireshark Configuration:** Customize the Wireshark application to support network traffic monitoring and analysis.

- **Wireshark Packet Capture:** Capture network traffic using Wireshark to examine network communications and investigate potentially malicious activity.

- **tcpdump Packet Capture:** Utilize tcpdump to capture network traffic through a command-line interface.

The objective of this exercise was to develop practical experience in network traffic monitoring, packet capture, network analysis, and security investigation, demonstrating how these techniques support threat detection and network security operations.

## Devices

- **soc-kali-001** – Kali Linux – Wireshark and tcpdump (192.168.40.5)
- **corp-wks-001** – Windows 11 – traffic generation (192.168.30.3)

---

## Task 1 – Capture Live Traffic with Wireshark

1. On **soc-kali-001**, open a terminal.

   ![Open terminal](screenshots/exercise-1/e1-01-open-terminal.png)

2. Launch Wireshark with root privileges so it can access the network interfaces:

   ```bash
   sudo wireshark
   ```

   ![sudo wireshark](screenshots/exercise-1/e1-02-sudo-wireshark.png)

3. On the welcome screen, the interfaces are listed with a live sparkline of their activity. Double-click **`eth0`** to start capturing.

   ![Wireshark welcome – eth0](screenshots/exercise-1/e1-03-wireshark-welcome-eth0.png)

4. To generate traffic to capture, open **Firefox**.

   ![Open Firefox](screenshots/exercise-1/e1-04-open-firefox.png)

5. Browsing to a site produces real traffic across the interface.

   ![Generate traffic](screenshots/exercise-1/e1-05-generate-traffic-firefox.png)

6. Wireshark fills with packets — TCP, TLS and ARP — each row a single packet with its source, destination, protocol and summary.

   ![Capturing on eth0](screenshots/exercise-1/e1-06-capturing-eth0.png)

---

## Task 2 – Customize Wireshark for Threat Hunting

The default columns show the destination IP but not the destination **port**, and the timestamp format is awkward. Both are worth fixing before you hunt.

7. Right-click the **No.** column header and choose **Column Preferences**.

   ![Column Preferences](screenshots/exercise-1/e1-07-column-preferences.png)

8. The Columns preferences list every displayed column and its type.

   ![Columns preferences](screenshots/exercise-1/e1-08-columns-preferences.png)

9. Click the **+** button to add a new column.

   ![Add a column](screenshots/exercise-1/e1-09-add-column.png)

10. Name the new column **Dest Address**.

    ![Dest Address added](screenshots/exercise-1/e1-10-dest-address-added.png)

11. Set its **Type** to **Dest addr (unresolved)** so it shows the raw IP rather than a resolved hostname.

    ![Dest addr (unresolved)](screenshots/exercise-1/e1-11-dest-addr-unresolved.png)

12. The Dest Address column type is now set.

    ![Dest Address type set](screenshots/exercise-1/e1-12-dest-address-type-set.png)

13. Add a second column, **Dest Port**.

    ![Dest Port added](screenshots/exercise-1/e1-13-dest-port-added.png)

14. Set its type to **Dest port (unresolved)**.

    ![Dest port (unresolved)](screenshots/exercise-1/e1-14-dest-port-unresolved.png)

15. The type dropdown offers dozens of fields Wireshark can display as a column.

    ![Column type list](screenshots/exercise-1/e1-15-column-type-list.png)

> ### 🔎 Why Dest Address and Dest Port
> The **port** is often the most telling field in a packet, and the default layout buries it. Adding **Dest Address** and **Dest Port** as columns puts the two questions an analyst scans first — *where is this going, and to what service* — right in the packet list. Traffic to **443** (HTTPS) is routine; a stream to an odd high port like **4444** is the kind of thing malware uses to reach its command-and-control server. Surfacing the port as a column means that stands out instead of hiding inside each packet.

16. Both custom columns now appear in the list.

    ![Columns configured](screenshots/exercise-1/e1-16-columns-configured.png)

17. Click **Apply**, then **OK**.

    ![Apply columns](screenshots/exercise-1/e1-17-apply-columns.png)

18. Change the timestamp format with **View → Time Display Format → Seconds**.

    > ### 🔎 Why "Seconds"
    > A readable, consistent time column is how you spot **beaconing** — malware checking in with its C2 server at a fixed interval (every 30s, every 60s). When the interval between packets to the same destination is easy to read, that machine-like rhythm is obvious. Messy timestamps hide it.

    ![Time Display Format – Seconds](screenshots/exercise-1/e1-18-time-display-seconds.png)

---

## Task 3 – Isolate Traffic with Display Filters

With the view tuned, display filters narrow a noisy capture down to exactly the conversation you care about.

19. Filter for HTTPS traffic on port 443:

    ```
    tcp.port == 443 || udp.port == 443
    ```

    ![Filter tcp.port 443](screenshots/exercise-1/e1-19-filter-tcp-443.png)

20. The capture now shows only port-443 traffic, with the Dest Port column confirming each match.

    ![Filtered 443 result](screenshots/exercise-1/e1-20-filter-tcp-443-result.png)

21. Combine conditions to find a specific host reaching a specific service — here, traffic involving a workstation on SMB port 445:

    ```
    ip.addr == 192.168.30.3 && tcp.port == 445
    ```

    ![Filter host and port](screenshots/exercise-1/e1-21-filter-ip-and-port.png)

22. Filter by an entire subnet to see all traffic to or from the Security Operations network:

    ```
    ip.addr == 192.168.40.0/24
    ```

    > ### 🔎 Match the filter to your own network
    > A filter only returns results if it matches addresses that are actually on the wire. The CIDR here, `192.168.40.0/24`, is the Polarized Systems SOC subnet; filtering for a subnet the lab environment doesn't use returns nothing. Always build filters around your real addressing — the server subnet (`192.168.20.0/24`), the workstation subnet (`192.168.30.0/24`) or the SOC subnet (`192.168.40.0/24`) — not a textbook example.

    ![Filter subnet](screenshots/exercise-1/e1-22-filter-subnet.png)

23. Click a column header to sort — here by **Source** — to group a talker's traffic together.

    ![Sort by Source](screenshots/exercise-1/e1-23-sort-by-source.png)

24. Sort by **Protocol** to group traffic by type.

    ![Sort by Protocol](screenshots/exercise-1/e1-24-sort-by-protocol.png)

25. Close the capture when the analysis is done.

    ![Close capture](screenshots/exercise-1/e1-25-close-capture.png)

26. Wireshark prompts to save the captured packets — click **Save**.

    ![Save prompt](screenshots/exercise-1/e1-26-save-prompt.png)

27. Save the capture as **Polarized Network Traffic Capture** in `.pcapng` format for later analysis or evidence.

    ![Save capture](screenshots/exercise-1/e1-27-save-capture.png)

---

## Task 4 – Capture from the Command Line with tcpdump

Wireshark is a GUI tool; real servers are usually headless, so analysts also capture with **tcpdump** over SSH.

28. Confirm the host with `hostnamectl` — the Kali analysis box.

    ```bash
    hostnamectl
    ```

    ![hostnamectl](screenshots/exercise-1/e1-28-hostnamectl.png)

29. Bring the system up to date before working:

    ```bash
    sudo apt update && sudo apt upgrade
    ```

    ![apt update](screenshots/exercise-1/e1-29-apt-update.png)

30. Check the tcpdump version:

    ```bash
    tcpdump --version
    ```

    ![tcpdump version](screenshots/exercise-1/e1-30-tcpdump-version.png)

31. List the interfaces tcpdump can capture on:

    ```bash
    sudo tcpdump --list-interfaces
    ```

    ![tcpdump interfaces](screenshots/exercise-1/e1-31-tcpdump-interfaces.png)

### Capture ICMP traffic

32. On **corp-wks-001**, open **Command Prompt**.

    ![Open Command Prompt](screenshots/exercise-1/e1-32-windows-command-prompt.png)

33. Generate continuous ICMP traffic toward the Kali box:

    ```
    ping 192.168.40.5 -t
    ```

    ![Ping Kali](screenshots/exercise-1/e1-33-ping-kali.png)

34. On **soc-kali-001**, capture exactly 10 ICMP packets to a file:

    ```bash
    sudo tcpdump -n icmp -c 10 -vv -w icmptraffic.pcap
    ```

    > ### 🔎 Reading the tcpdump flags
    > `-n` skips DNS lookups (faster, raw IPs) · `icmp` filters to ping traffic · `-c 10` stops after 10 packets · `-vv` is extra-verbose output · `-w icmptraffic.pcap` writes the capture to a file instead of the screen. The `-w` file is the key to the real workflow: **capture on the server with tcpdump, then open the `.pcap` in Wireshark on your workstation.**

    ![tcpdump ICMP](screenshots/exercise-1/e1-34-tcpdump-icmp.png)

35. Confirm the capture file was written:

    ```bash
    ls
    ```

    ![ls icmptraffic.pcap](screenshots/exercise-1/e1-35-ls-icmp-pcap.png)

36. Open the saved capture in Wireshark:

    ```bash
    sudo wireshark icmptraffic.pcap
    ```

    ![Open ICMP pcap](screenshots/exercise-1/e1-36-open-icmp-pcap.png)

37. The capture shows the ICMP echo requests and replies between `192.168.30.3` (the workstation) and `192.168.40.5` (Kali).

    ![ICMP in Wireshark](screenshots/exercise-1/e1-37-icmp-in-wireshark.png)

### Capture HTTP traffic

38. Back in the Kali terminal.

    ![Open terminal again](screenshots/exercise-1/e1-38-open-terminal-again.png)

39. Capture traffic on **port 80** (HTTP) to a file:

    ```bash
    sudo tcpdump -i eth0 -nn -v port 80 -w httptraffic.pcap
    ```

    ![tcpdump HTTP](screenshots/exercise-1/e1-39-tcpdump-http.png)

40. Generate plain HTTP traffic with `curl` against a guaranteed-HTTP site:

    ```bash
    curl -4 -v --connect-timeout 10 http://neverssl.com/
    ```

    *`neverssl.com` serves over plain HTTP (port 80) by design, so it reliably produces the traffic the filter is watching for — most sites would redirect to HTTPS on 443.*

    ![curl neverssl](screenshots/exercise-1/e1-40-curl-neverssl.png)

41. Stop the capture with **Ctrl+C**; tcpdump reports the packets written to the file.

    ![HTTP captured](screenshots/exercise-1/e1-41-tcpdump-http-captured.png)

42. Open the HTTP capture in Wireshark:

    ```bash
    sudo wireshark httptraffic.pcap
    ```

    ![Open HTTP pcap](screenshots/exercise-1/e1-42-open-http-pcap.png)

43. The capture shows the TCP handshake and the HTTP request/response to the web server on port 80.

    ![HTTP in Wireshark](screenshots/exercise-1/e1-43-http-in-wireshark.png)

44. On the workstation, **Ctrl+C** stops the ping and prints the statistics for the ICMP traffic generated.

    ![Ping statistics](screenshots/exercise-1/e1-44-ping-statistics.png)

> ### 🔎 Wireshark vs. tcpdump
> **Wireshark** is the GUI for *analysis*. It displays columns, filters, and protocol decoding. **tcpdump** is the lightweight command-line tool for *capture* on enterprise Linux systems where only terminal access is available. Tcpdump output can be exported to a `.pcap` file then opened within Wireshark where you can comfortably anaylze the network capture. 

---

>
> "We can see and record exactly what's crossing our network. Using free, industry-standard tools, we captured live traffic, arranged it so that unusual destinations and services stand out, and filtered it down to specific conversations. We also showed we can do this on a server with no screen and save the evidence to a file for later review."

---

[← Back to Lab Overview](../README.md) | [Next: Exercise 2 – Validating Domain Names & IP Addresses →](../exercise-2-validating-domains-and-ips/README.md)
