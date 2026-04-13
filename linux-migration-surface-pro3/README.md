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

## Implementation Steps

### 1. System Assessment
Collected system information using: msinfo32


Confirmed compatibility:
- x64 processor
- UEFI firmware
- SSD storage

---

### 2. Data Protection
Performed backup of user data prior to migration.

---

### 3. Bootable Media Creation
Created installation media using:

- Debian ISO
- Rufus USB creation tool

---

### 4. Operating System Installation
Booted system from USB and installed Debian with XFCE desktop environment.

Configuration included:

- Disk partitioning
- User account creation
- Network configuration

---

### 5. System Hardening

Post-installation security configuration included:

- System update and patch management
- Firewall activation
- Installation of monitoring and security control

Example commands: 

Example commands:

```bash
# Update package index
sudo apt update

# Install security updates
sudo apt upgrade

# Install firewall and network analysis tool
sudo apt install ufw wireshark

# Enable firewall
sudo ufw enable
```

---


## Security Domain
- Endpoint Security
- System Hardening
- Risk Management
- Linux System Administration

---

## Skills Demonstrated
- Risk assessment
- Security-focused system migration
- Linux deployment and configuration
- System hardening
- Documentation of security controls


## Security Benefits

- Eliminates reliance on unsupported operating system
- Restores patch management capability
- Provides secure environment for cybersecurity labs
- Reduces attack surface compared to legacy Windows system

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
