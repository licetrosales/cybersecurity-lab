# Cybersecurity Lab – Linux Hardening & Migration Project

## Project Objective
This project demonstrates a risk-based approach to endpoint security by mitigating the risks associated with the End of Life (EOL) of Windows 10 through migration to a hardened Linux system.

The goal is to transform a legacy device into a secure, monitored, and resilient endpoint using industry-aligned cybersecurity practices.

---

## Overview
This project documents the migration of a **Microsoft Surface Pro 3** from **Windows 10 Pro (22H2)** to a hardened **Debian Linux (XFCE) system**. 

It follows a structured cybersecurity workflow:

- Identify risk (EOL system)
- Assess impact and likelihood
- Implement mitigation controls
- Apply system hardening and monitoring

The result is a defense-in-depth security architecture that reduces attack surface, improves visibility, and enables secure system operation.

---

## System Information

**Device:** Microsoft Surface Pro 3  
**CPU:** Intel Core i5-4300U  
**RAM:** 4 GB  
**Storage:** 119 GB SSD  
**Firmware:** UEFI  
**Previous OS:** Windows 10 Pro 22H2  
**Current OS:** Debian (XFCE)
---

## Risk Identification

### Asset
Endpoint system used for cybersecurity learning and development.

### Risk
Operating system reaching **End of Support (EOL)**.

### Threat
Unpatched vulnerabilities due to discontinued vendor security updates.

### Impact
- Increased exposure to malware and exploitation
- Loss of vendor support
- Degraded security posture

### Likelihood
High (publicly defined EOL timeline)

---

## Mitigation Strategy

### Control Implemented
Migration to a supported Linux distribution with applied system hardening.

### Selected Operating System
Debian with XFCE desktop environment.

### Rationale
- Long-term security updates
- Lightweight for legacy hardware
- Strong package management and security community
- Widely used base system 

---
## Security Architecture (Defense-in-Depth)

This system implements a layered security model:

### Prevention
- UFW firewall (default deny inbound)
- SSH hardening (key-based authentication, no root login, LAN restriction)
- Kernel hardening (sysctl – anti-spoofing, SYN flood protection)
- Filesystem hardening (/tmp, /dev/shm with noexec, nosuid, nodev)
- Service minimization (disabled unnecessary services)
- AppArmor (Mandatory Access Control for SSH)

### Detection
- Auditd for system activity monitoring (privileged actions, file changes, authentication)
- AIDE for file integrity monitoring with baseline management
  
### Response
- Fail2Ban for automated blocking of suspicious login attempts

This layered approach reduces attack surface, increases visibility, and enables faster response to security events.

---
## Implementation Summary

### 1. System Migration
- Created bootable installation media
- Installed Debian XFCE
- Configured disk partitions and users
### 2. Data Protection
- Backed up user data before migration
### 3. System Hardening
- Applied network, kernel, and filesystem hardening
- Configured secure authentication (SSH keys only)
- Enforced least privilege (user separation)
### 4. Monitoring & Defense
- Enabled logging (journald, UFW)
- Configured Auditd (security-relevant events)
- Implemented AIDE (file integrity monitoring)
- Deployed Fail2Ban (intrusion prevention)

Full technical implementation: **hardening.md**

---

## Security Domain
- Endpoint Security
- System Hardening
- Risk Management
- Linux System Administration

---

## Skills Demonstrated
- Risk-based security decision making (EOL mitigation)
- Linux system hardening (network, kernel, filesystem)
- Identity & access management (SSH, privilege separation)
- Host-based intrusion detection & prevention (Auditd, AIDE, Fail2Ban)
- Mandatory Access Control (AppArmor)
- Security monitoring and log analysis
- Secure system deployment and configuration
- Technical documentation of security controls


## Security Benefits

- Eliminates reliance on unsupported operating system
- Restores patch management capability
- Reduces attack surface through system hardening
- Implements monitoring and detection mechanisms
- Enables secure environment for cybersecurity labs

---

## Lessons Learned

- Legacy hardware can remain operational through lightweight Linux distributions
- Risk-based decision making improves system lifecycle management
- Linux environments provide strong flexibility for security tooling and experimentation

---

## Future Improvements

Planned enhancements:

- Installation of security monitoring tools
- Network traffic analysis lab setup
- Host-based intrusion detection testing

---

## Note

Cybersecurity learning project focused on **risk mitigation, system security, and Linux platform adoption for security analysis workflows**.
