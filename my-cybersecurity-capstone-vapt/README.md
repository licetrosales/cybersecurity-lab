# Capstone Project: Vulnerability Assessment & Penetration Testing (VAPT) with Digital Forensics

## Executive Summary

This capstone project simulates a full-scope Vulnerability Assessment and Penetration Testing (VAPT) engagement for a small enterprise network. The assessment followed a structured security lifecycle:

1. Network reconnaissance and vulnerability assessment  
2. Web application security testing  
3. Exploitation and credential attacks  
4. Digital forensic analysis and evidence validation  

The engagement successfully identified critical vulnerabilities, including remote code execution via MS17-010 (EternalBlue), SQL injection, stored XSS, insecure file uploads, password reuse, and extension-based data obfuscation techniques.

All findings were consolidated into a formal VAPT report with risk classification, remediation recommendations, and an executive-level security roadmap. A technical presentation was also prepared to communicate findings to stakeholders.

---

## Project Overview

This project demonstrates end-to-end offensive security workflow execution within a controlled enterprise lab environment.

The scope included:

- Network discovery and service enumeration  
- Vulnerability scanning and validation  
- Web application exploitation  
- Windows exploitation and credential harvesting  
- Online and offline password cracking  
- Digital forensic evidence collection and analysis  
- Professional VAPT reporting  

Deliverables included:

- `Final_VAPT_Report.pdf`
- 15-minute technical presentation
- Structured milestone documentation
- Exported forensic artifacts

---

## Lab Environment

### Infrastructure

- Kali Linux (Pentester workstation)
- Windows 7 SP1 (Vulnerable client)
- Metasploitable / Application server (DVWA)
- Virtualized firewall/gateway

### Tools & Technologies

**Network & Enumeration**
- Netdiscover
- Nmap
- Greenbone Security Assistant (OpenVAS)

**Exploitation & Post-Exploitation**
- Metasploit Framework
- msfvenom
- Hydra
- John the Ripper
- smbclient / rpcclient

**Web Security Testing**
- DVWA (Damn Vulnerable Web Application)
- Manual payload crafting

**Digital Forensics**
- Autopsy
- md5sum
- NTLM hash extraction
- Evidence export and documentation

---

# Milestone 1 – Network Vulnerability Assessment

### Activities

- ARP-based host discovery
- Nmap service and OS fingerprinting
- SMB enumeration
- MS17-010 detection
- Credentialed vulnerability scanning with OpenVAS

### Key Findings

- Multiple exposed SMB services (ports 135, 139, 445)
- Confirmed MS17-010 (EternalBlue) vulnerability
- SMB message signing disabled
- End-of-Life operating system (Windows 7)

### Risk Impact

The Windows host was vulnerable to remote code execution and ransomware-class exploits due to unpatched SMB services.

---

# Milestone 2 – Web Application Security Testing

### Vulnerabilities Exploited

- SQL Injection (authentication bypass and enumeration)
- Stored Cross-Site Scripting (XSS)
- Unrestricted file upload
- Remote Code Execution (PHP webshell)
- Reverse shell via Metasploit payload

### Security Insights

Testing across different security levels demonstrated the effectiveness of:

- Input validation
- Output encoding
- File type restrictions
- Secure configuration controls

---

# Milestone 3 – Windows Exploitation & Password Attacks

### Exploitation

- EternalBlue exploitation via Metasploit
- SYSTEM-level access obtained

### Credential Attacks

- User enumeration
- Custom wordlist creation
- SMB brute-force using Hydra
- NTLM hash extraction
- Offline cracking using John the Ripper

### Critical Findings

- Password reuse across privileged accounts
- Weak password policy enforcement
- Successful credential validation via SMB and RPC

---

# Milestone 4 – Digital Forensics & Evidence Analysis

### Forensic Process

- MD5 hash verification of forensic image
- Autopsy case setup and validation
- File type mismatch detection
- Deleted file recovery
- Identification of disguised archive files
- Alternate Data Stream (ADS) discovery

### Key Findings

- Hidden JPEG files recovered
- Extension spoofing identified
- Evidence structured and exported following forensic best practices

---

# Skills Demonstrated

- Vulnerability assessment methodology
- Manual exploitation techniques
- Credential harvesting and validation
- Password cracking (online and offline)
- Digital forensic analysis
- Risk classification and remediation planning
- Professional security reporting

---

# Final Deliverables

- Comprehensive VAPT Report (PDF)
- Technical Presentation (15 minutes)
- Structured milestone documentation

---
# References

1. Nmap Project. *Nmap Reference Guide.*  
   https://nmap.org/book/man.html

2. FIRST. *Common Vulnerability Scoring System (CVSS) v3.1 Specification.*
   https://www.first.org/cvss/specification-document

3. Greenbone Networks. *Greenbone / OpenVAS Documentation.*  
   https://docs.greenbone.net/

4. OWASP. *OWASP Web Security Testing Guide.*
   https://owasp.org/www-project-web-security-testing-guide/

5. OWASP. *SQL Injection Prevention Cheat Sheet.*
   https://owasp.org/www-community/attacks/SQL_Injection
 
6. Open Web Application Security Project (OWASP). *OWASP Top 10 – Web Application Security Risks.*  
   https://owasp.org/www-project-top-ten/

7. MITRE. (2017). *CVE-2017-0144 – Windows SMB Remote Code Execution Vulnerability.*  
   https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0144

8. Rapid7. *Metasploit Framework Documentation.*  
   https://docs.rapid7.com/metasploit/

9. Offensive Security. *Kali Linux Tools Documentation.*  
   https://tools.kali.org/

10. Microsoft. (2017). *Microsoft Security Bulletin MS17-010 – Critical.*  
   https://docs.microsoft.com/en-us/security-updates/securitybulletins/2017/ms17-010

11. THC Hydra Project. *Hydra – Fast Network Logon Cracker.*  
   https://github.com/vanhauser-thc/thc-hydra

12. Openwall. *John the Ripper Documentation.*  
   https://www.openwall.com/john/

13. Samba Project. *smbclient and rpcclient Documentation.*  
   https://www.samba.org/samba/docs/

14. Microsoft. *Password Policy Best Practices.*  
https://learn.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/password-policy

15. NIST. (2017). *Digital Identity Guidelines (SP 800-63B).*  
https://pages.nist.gov/800-63-3/sp800-63b.html

16. Sleuth Kit. *Autopsy Forensic Browser Documentation.*  
    https://www.sleuthkit.org/autopsy/docs/

17. Carrier, B. *File System Forensic Analysis.* Addison-Wesley.

18. National Institute of Standards and Technology (NIST). *Guide to Integrating Forensic Techniques into Incident Response (SP 800-86).*  
https://csrc.nist.gov/publications/detail/sp/800-86/final


   
---
