# Migration Plan – Windows 10 to Linux

## Objective
Migrate a legacy system from **Windows 10 Pro** to a supported Linux distribution in order to mitigate security risks associated with **Windows 10 End of Life (EOL)**.

---

## System Details

| Component | Specification |
|----------|---------------|
| Device | Microsoft Surface Pro 3 |
| CPU | Intel Core i5-4300U |
| RAM | 4 GB |
| Storage | 119 GB SSD |
| Firmware | UEFI |

---

## Migration Strategy

The migration process follows a **four-phase approach**:

1. Assessment
2. Preparation
3. Installation
4. Post-install Hardening

---

## Phase 1 – System Assessment

Tasks:

- Identify hardware specifications
- Verify Linux compatibility
- Determine storage availability

Command used:

```bash
msinfo32
```

Key findings:

- 64-bit CPU supported
- UEFI firmware detected
- SSD available for installation

---

## Phase 2 – Preparation

Tasks:

- Backup important user data
-Download Debian Linux ISO
- Create bootable USB installatio n media

Tools used:

- Debian ISO
- Rufus

---

## Phase 3 – Installation

Tasks:

- Boot system from USB
- Configure disk partitions
- Install Linux operating system
- Create system user account

Selected operating system:

**Debian with XFCE desktop environment**

Reasons:

- Lightweight for older hardware
- Long-term stability
- Strong security community support

---

## Phase 4 – Post-Installation Hardening

Security configuration includes:

- System updates
- Firewall configuration
- Installation of security tools

Example commands:

```bash
sudo apt update
sudo apt upgrade
sudo apt install ufw wireshark
sudo ufw enable
```

## Validation

After installation verify:

- System boots successfully
- Network connectivity works
- Firewall is active
- System updates are functioning

## Success Criteria

Migration is considered successful when:

- Windows 10 is fully replaced
- Linux system operates normally
- Security updates are active
- Firewall protection is enabled

## Outcome

The system now operates on a supported Linux platform, reducing the risks associated with unsupported operating systems and enabling a secure environment for working, learning and experimentation.