# Milestone 1: Network Scanning and Vulnerability Assessment

## 1. Overview

This milestone simulates a client-side vulnerability assessment commissioned by TechShield, a managed IT services provider, to identify and mitigate internal threats. The primary goal is to detect live hosts, enumerate services, and scan for vulnerabilities across a test lab environment.

---

## 2. Lab Infrastructure

### Virtual Machines (VMs)

| VM                  | Purpose                                                  |
|---------------------|----------------------------------------------------------|
| **Pentester**       | Kali Linux machine used for scanning and testing         |
| **Victim-Laptop**   | Host targeted during enumeration                         |
| **Application Server** | Runs DVWA and Mutillidae vulnerable apps             |

### Network Diagram

![Network Diagram](../assets/network-layout.png)
*Figure 1: Network layout showing Pentester, Victim, and App Server*

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

- `Netdiscover` – ARP-based discovery
- `Nmap` – Ping sweeps, port scanning, version detection
- `OpenVAS` – Vulnerability scanning and reporting

---
## 3 Network Discovery

### 3.1 Host Discovery via ARP (Netdiscover)

Executed on subnet `192.168.57.0/24`:

```bash
sudo netdiscover -r 192.168.57.0/24
```
Results:

5 live hosts detected

Scanning host (192.168.57.10) excluded by design


Figure 2: ARP probe result using Netdiscover
