# Milestone 1: Network Scanning and Vulnerability Assessment

## 1. Overview

This milestone focused on identifying live hosts in the network and performing service enumeration to detect potential vulnerabilities. The analysis was carried out on a controlled lab network simulating a small enterprise environment..

---

## 2. Environment Setup and Tools
The assessment was conducted within a virtualized lab environment consisting of multiple virtual machines representing various network roles (firewall/router, Windows client, Linux client). 


### Virtual Machines (VMs)

| VM                  | Purpose                                                  |
|---------------------|----------------------------------------------------------|
| **Pentester**       | Kali Linux machine used for scanning and testing         |
| **Victim-Laptop**   | Host targeted during enumeration                         |
| **Application Server** | Runs DVWA and Mutillidae vulnerable apps             |

### Network Diagram

![Network Diagram](../assets/network-layout.png)
**Figure 1:** Network layout showing Pentester, Victim, and App Server*

### Login Credentials
#### Virtual Machines

| VM             | Username | Password    |
|----------------|----------|-------------|
| Pentester      | kali     | kali        |
| Victim-Laptop  | Student  | P@ssw0rd    |

#### Web Applications

| App       | URL                          | Username | Password  |
|-----------|------------------------------|----------|-----------|
| OpenVAS   | `https://192.168.57.40`      | student  | P@ssw0rd  |
| DVWA      | `http://192.168.57.30/dvwa`  | admin    | password  |
| Mutillidae| `http://192.168.57.30/`      | —        | —         |

---

## Tools Used

- `Netdiscover` : ARP-based discovery
- `Nmap` : Ping sweeps, port scanning, version detection
- `OpenVAS` : Vulnerability scanning and reporting

---
## 3 Network Discovery

### 3.1 Host Discovery via ARP (Netdiscover)

Executed on subnet `192.168.57.0/24`:

```bash
sudo netdiscover -r 192.168.57.0/24
```
- **Results:**

  - 5 live hosts detected

  - Scanning host (192.168.57.10) excluded by design

![Figure 2](../assets/netdiscover-scan-output.png)
**Figure 2:** ARP probe result using Netdiscover

### 3.2 Cross-Verification Host Discovery using Nmap: Ping Sweep
To validate the results, an Nmap ping sweep was also performed:

```bash
nmap -sn 192.168.57.0/24
```
- `-sn` : Disables port scanning, enabling only ping-based discovery.

- **Results:**

  - 5 target hosts were confirmed.
  - The Pentester host (192.168.57.10) appeared.
  - Host 192.168.57.20, detected earlier via Netdiscover, was not listed in the Nmap results.

To ensure more comprehensive detection, an enhanced ping sweep was conducted using retry and timeout options.

**Enhanced Ping Sweep:**
```bash
sudo nmap -sn --max-retries 5 --host-timeout 30s 192.168.57.0/24
```
- `--max-retries 5`: Retries probes up to 5 times (default is 10).
- `--host-timeout 30s`: Allows slower or delayed hosts more time to respond.

- **Results:**

  - 6 total of 5 target hosts were confirmed, including: 192.168.57.20.
  - This result confirms that the host is reachable and responsive when given more time.

![Figure 3 ](../assets/namp-enhanced-ping-sweep-scan.png)
**Figure 3**: Nmap Enhanced Ping Sweep Scan Result

### 3.3 Summary of Detected Hosts

| Host IP         | Role             | Detected via   |
|----------------|------------------|----------------|
| 192.168.57.20  | Windows 7 Client | Nmap, Netdiscover |
| 192.168.57.30  | Linux Client     | Nmap, Netdiscover |
| 192.168.57.40  | Metasploitable 2 | Nmap, Netdiscover |
| 192.168.57.50  | Unknown Device   | Nmap, Netdiscover |
| 192.168.57.254 | Firewall/Gateway | Nmap, Netdiscover |

**Table 1**: Summary of Live Hosts
