# Milestone 1: Network Scanning and Vulnerability Assessment

## Objective

The goal of Milestone 1 is to simulate a real-world vulnerability assessment on a target network. This involves discovering active hosts, enumerating open ports and services, identifying software versions, and performing vulnerability scans using industry-standard tools.

This forms the **initial reconnaissance and vulnerability discovery phase** of a full-scope VAPT engagement.

---

## Tools Used

- `Netdiscover` – for ARP-based host discovery
- `Nmap` – for ping sweeps, port scanning, and service enumeration
- `OpenVAS (Greenbone Security Assistant)` – for vulnerability scanning and reporting

---

## Activities Performed

### Network Discovery

- **ARP Scan with Netdiscover**: Identified live hosts in the internal lab network.
- **Optional Verification with Nmap**: Cross-verified host availability using ping sweeps.

### Port, Service, and Version Enumeration

Performed detailed Nmap scans on multiple hosts to enumerate:
- Open TCP/UDP ports
- Running services and versions
- Potential operating systems and fingerprints

Example targets:
- `192.168.57.20`
- `192.168.57.30`
- `192.168.57.40`
- And others

### Vulnerability Scanning

- Configured and launched scans using **OpenVAS**
- Generated detailed reports with CVSS scores and vulnerability descriptions

---

## Deliverables

- Nmap scan logs and `.xml`/`.gnmap` output files
- Screenshots or exports of OpenVAS vulnerability findings
- Summary of discovered hosts, open ports, and potential exposures
- Recommendations based on identified risks

---

## Key Learning Outcomes

- Gained hands-on experience with **network reconnaissance**
- Learned how to **enumerate and analyze network services**
- Used **vulnerability scanners** to map exposures to CVEs
- Identified how attackers might move from discovery to exploitation

---
