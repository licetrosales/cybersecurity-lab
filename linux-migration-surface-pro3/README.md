# Cybersecurity Lab – Linux Migration Project

## Project Objective
Demonstrate a risk-based approach to endpoint security by mitigating the security risks associated with the **End of Life (EOL) of Windows 10** through migration to a supported Linux operating system.

This project documents system analysis, risk identification, mitigation planning, and secure system deployment.

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

## Overview
This project documents the migration of a **Microsoft Surface Pro 3** from **Windows 10 Pro (22H2)** to a Linux-based system in order to mitigate security risks associated with the **End of Life (EOL) of Windows 10 in October 2025**.

The objective is to demonstrate a **risk-based security approach** consistent with cybersecurity analyst practices and **CompTIA CySA+ principles**: identifying risks, assessing impact, and implementing mitigation controls.

---

## System Information

**Device:** Microsoft Surface Pro 3  
**CPU:** Intel Core i5-4300U  
**RAM:** 4 GB  
**Storage:** 119 GB SSD  
**Firmware:** UEFI  
**Previous OS:** Windows 10 Pro 22H2  

---

## Risk Identification

### Asset
Endpoint workstation used for cybersecurity learning and development.

### Risk
Operating system reaching **End of Support (EOL)**.

### Threat
Unpatched vulnerabilities due to discontinued vendor security updates.

### Impact
- Increased exposure to malware and exploitation
- Loss of vendor support
- Compliance and security posture degradation

### Likelihood
High – EOL date publicly defined by vendor.

---

## Mitigation Strategy

### Control Implemented
Migration to a supported Linux distribution.

### Selected Operating System
Debian with XFCE desktop environment.

### Rationale
- Long-term security updates
- Lightweight for legacy hardware
- Strong package management and security community
- Widely used base system for cybersecurity distributions

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
- Installation of monitoring and network analysis tools

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


---

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
- Virtual machines for penetration testing environments
- Host-based intrusion detection testing

---

## Author

Cybersecurity learning project focused on **risk mitigation, system security, and Linux platform adoption for security analysis workflows**.
