# Risk Assessment – Windows 10 End-of-Life

## Overview
This document assesses the cybersecurity risks associated with continuing to operate a system running **Windows 10** after its official **End of Life (EOL) in October 2025**.

The system analyzed is a **Microsoft Surface Pro 3** used as a workstation for learning and lab activities.

---

## Asset Identification

| Asset | Description |
|------|-------------|
| Endpoint workstation | Microsoft Surface Pro 3 |
| Operating System | Windows 10 Pro 22H2 |
| Usage | Cybersecurity learning environment |

---

## Threat Identification

| Threat | Description |
|------|-------------|
| Unpatched vulnerabilities | Lack of security updates after vendor support ends |
| Malware infection | Increased exposure due to unsupported software |
| Privilege escalation | Exploitation of unpatched OS vulnerabilities |
| System compromise | Attackers exploiting known vulnerabilities |

---

## Vulnerability

Primary vulnerability identified:

**Operating system reaching End of Support (EOL).**

After EOL:
- No security patches
- No vulnerability fixes
- No vendor support

---

## Risk Analysis

| Risk Factor | Assessment |
|-------------|------------|
| Likelihood | High |
| Impact | Medium to High |
| Risk Level | High |

---

## Potential Impact

- System compromise
- Data exposure
- Malware infection
- Reduced system security posture
- Increased attack surface

---

## Risk Mitigation Strategy

Primary mitigation:

**Migration from Windows 10 to a supported Linux operating system.**

Benefits:

- Active security updates
- Reduced attack surface
- Secure environment for cybersecurity labs
- Long-term system usability

---

## Selected Mitigation

| Control | Description |
|-------|-------------|
| OS Replacement | Replace Windows 10 with Debian Linux |
| System Hardening | Enable firewall and update management |
| Monitoring | Install network analysis tools |

---

## Residual Risk

After migration:

| Risk | Status |
|----|----|
| Unsupported OS | Eliminated |
| Patch management | Restored |
| System compromise risk | Reduced |

---

## Conclusion

Migrating the system to a supported Linux distribution significantly reduces the security risks associated with operating an unsupported operating system and aligns with **best practices for system lifecycle management and endpoint security**.