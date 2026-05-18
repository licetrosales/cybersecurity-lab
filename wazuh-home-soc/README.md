# Wazuh Home SOC Lab

## Overview

This project documents the implementation of a lightweight Home SOC (Security Operations Center) environment using Wazuh, Docker, WSL2, and multiple monitored endpoints.

The lab was built to practice:

- SIEM deployment and administration
- Endpoint monitoring
- Detection engineering fundamentals
- Log analysis and investigation
- Linux system administration
- Multi-platform security monitoring
- Basic SOC workflows

The environment simulates a small security monitoring infrastructure with centralized log collection and endpoint visibility across Windows, macOS, Debian Linux, and Raspberry Pi systems.

---

# Architecture

## Infrastructure Stack

| Component | Purpose |
|---|---|
| Wazuh Manager | Centralized SIEM management |
| Wazuh Indexer | Event indexing and storage |
| Wazuh Dashboard | Visualization and investigation interface |
| Docker | Container runtime |
| WSL2 | Linux virtualization layer on Windows |

---

## Lab Architecture

```text
                           ┌────────────────────────────┐
                           │ Windows 11 Host            │
                           │ WSL2 + Docker              │
                           └─────────────┬──────────────┘
                                         │
                    ┌────────────────────┼────────────────────┐
                    │                    │                    │
          ┌─────────▼─────────┐ ┌────────▼────────┐ ┌────────▼────────┐
          │ Wazuh Manager     │ │ Wazuh Indexer   │ │ Wazuh Dashboard │
          └─────────┬─────────┘ └─────────────────┘ └─────────────────┘
                    │
     ┌──────────────┼─────────────────────────────────────────────┐
     │              │                     │                       │
┌────▼─────┐ ┌──────▼──────┐ ┌────────────▼──────────┐ ┌─────────▼────────┐
│ macOS    │ │ Windows 11  │ │ Debian Linux          │ │ Raspberry Pi 5   │
│ Endpoint │ │ Endpoint    │ │ Endpoint              │ │ Sensor Node      │
└──────────┘ └─────────────┘ └───────────────────────┘ └──────────────────┘
```

---

# Monitored Endpoints

| Hostname | Operating System | Role |
|---|---|---|
| mac-cli-01 | macOS | Workstation endpoint |
| win-cli-01 | Windows 11 | Primary workstation |
| linux-cli-01 | Debian Linux | Monitored Linux endpoint |
| raspi-cli-01 | Raspberry Pi OS | Sensor node |

---

# Detection Capabilities

The environment currently monitors:

- Authentication events
- Failed login attempts
- Privileged command execution
- File integrity changes
- System and service logs
- Linux audit events
- Windows security events

Additional integrations:

- Auditd
- AIDE
- Fail2Ban

---

# Example Security Events

## Failed SSH Login

```bash
ssh invaliduser@localhost
```

## File Integrity Change

```bash
sudo nano /etc/passwd
```

## Privileged Command Execution

```bash
sudo useradd testuser
```

These activities generate alerts visible in the Wazuh dashboard for investigation and analysis.

---

# Deployment Environment

| Component | Platform |
|---|---|
| Wazuh Stack | Docker on WSL2 |
| Endpoint Monitoring | Windows, macOS, Debian Linux |
| Sensor Node | Raspberry Pi 5 |
| Network | Local LAN |

The lab is intentionally designed as a lightweight local SOC environment focused on practical learning and experimentation.

---

# Documentation

Detailed implementation and operational documentation is available in the following files:

| Document | Description |
|---|---|
| `wazuh-siem-setup.md` | Wazuh SIEM deployment and infrastructure setup |
| `wazuh-agent-installation.md` | Endpoint agent installation and enrollment |
| `update-wazuh-version.md` | Wazuh stack upgrade and troubleshooting process |

---

# Technologies Used

- Wazuh
- Docker
- WSL2
- Ubuntu
- Linux
- Debian
- Raspberry Pi OS
- Windows 11
- macOS

---

# Learning Objectives

This project was built to strengthen practical skills in:

- SIEM deployment
- Endpoint visibility
- Detection engineering
- Security monitoring
- Log analysis
- Infrastructure troubleshooting
- Multi-platform administration
- SOC operational workflows

---

# Future Improvements

Planned future enhancements include:

- n8n workflow automation
- Suricata IDS integration
- Zeek network monitoring
- Docker event monitoring
- Custom dashboards
- Alert tuning
- Active response rules
- Automated alert forwarding

---

# Key Lessons Learned

- Version compatibility between manager and agents is critical
- WSL2 networking introduces additional routing considerations
- Structured troubleshooting and validation improve deployment reliability
- Standardized endpoint naming simplifies asset management
- Containerized SIEM deployments provide flexible local lab environments

---

# Status

- Wazuh stack operational
- Multi-platform agents connected
- Dashboard functional
- Endpoint monitoring active
- Upgrade to Wazuh 4.14.5 completed successfully

---

## Author

Cybersecurity learning project focused on practical SOC operations, SIEM administration, endpoint monitoring, and detection engineering.

## Missing SEcurity Hardening Disclaimer

This environment is intended for learning and local lab usage only and is not hardened for production deployment.
