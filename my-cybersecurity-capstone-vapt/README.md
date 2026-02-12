# Capstone Project: Vulnerability Assessment on TechShield's Network Infrastructure

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
## 6. References

1. Microsoft. (2017). *Microsoft Security Bulletin MS17-010 – Critical*.  
   https://docs.microsoft.com/en-us/security-updates/securitybulletins/2017/ms17-010

2. Rapid7. *Metasploit Framework Documentation*.  
   https://docs.rapid7.com/metasploit/

3. Offensive Security. *Kali Linux Tools Documentation*.  
   https://tools.kali.org/

4. THC Hydra. *Hydra – A fast and flexible login cracker*.  
   https://github.com/vanhauser-thc/thc-hydra

5. Openwall. *John the Ripper Password Cracker*.  
   https://www.openwall.com/john/

6. MITRE. *CVE-2017-0144 – Windows SMB Remote Code Execution Vulnerability (EternalBlue)*.  
   https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0144

7. Samba Project. *smbclient and rpcclient Tools*.  
   https://www.samba.org/samba/docs/

8. Sleuthkit.org. *Autopsy Forensic Browser Documentation*.   
   https://www.sleuthkit.org/autopsy/docs/user-docs/

   
---
