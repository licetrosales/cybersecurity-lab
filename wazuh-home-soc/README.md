# Wazuh Home SOC Lab

## Overview

This project documents the implementation of a lightweight Home SOC (Security Operations Center) built with Wazuh, Docker, and multiple monitored endpoints.

The lab was created for cybersecurity learning, SIEM administration practice, endpoint monitoring, and detection engineering fundamentals.

Current capabilities include:

- Centralized log collection
- Multi-platform endpoint monitoring
- Security event analysis
- File integrity monitoring
- Authentication event monitoring
- Basic alert generation and investigation

Planned future work includes automation workflows using n8n.

---

# Architecture

## Infrastructure Components

| Component | Purpose |
|---|---|
| Wazuh Manager | Centralized SIEM management |
| Wazuh Indexer | Event indexing and storage |
| Wazuh Dashboard | Web interface and visualization |
| Docker | Container runtime |
| WSL2 | Linux virtualization layer |

### Home SOC Architecture

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
│ Agent    │ │ Agent       │ │ Agent                 │ │ Sensor Node      │
└──────────┘ └─────────────┘ └───────────────────────┘ └──────────────────┘
```
---

## Monitored Endpoints

| Hostname | Operating System | Role |
|---|---|---|
| mac-cli-01 | macOS | Workstation endpoint |
| win-cli-01 | Windows 11 | Primary SIEM host |
| licet-surfacepro3 | Debian Linux | Linux monitored endpoint |
| raspi-cli-01 | Raspberry Pi OS | Sensor and monitoring node |


---
## Detection Capabilities

The environment currently monitors:

- SSH authentication events
- Failed login attempts
- Privileged command execution
- File integrity changes
- System and service logs
- Linux audit events
- Windows security events

Additional integrations include:

- Auditd
- AIDE
- Fail2Ban

---

## Example Test Cases

### Failed SSH Login

```bash
ssh invaliduser@localhost
```

### File Modification

```bash
sudo nano /etc/passwd
```

### Privileged Command Execution

```bash
sudo useradd testuser
```

These activities generate alerts visible in the Wazuh dashboard.

---
## Deployment Environment

| Component | Platform |
|---|---|
| Wazuh Stack | Docker on WSL2 |
| Endpoint Monitoring | Windows, macOS, Debian |
| Sensor Node | Raspberry Pi 5 |
| Network | Local LAN |

The lab is intentionally designed as a lightweight local environment focused on learning and experimentation.

---

## Planned Automation Integration

Future work will integrate n8n for basic security automation workflows.

Planned use cases include:

- Alert forwarding
- Severity-based filtering
- Automated notifications
- Simple active response actions
- Webhook-based event processing

Conceptual workflow:

```text
Wazuh → Alert → Webhook/API → n8n → Action
```

---

## Documentation

Detailed setup documentation is available in the following files:

| Document | Description |
|---|---|
| `wazuh-siem-setup.md` | Wazuh SIEM deployment |
| `wazuh-agent-installation.md` | Endpoint agent installation |
| `update-wazuh-version.md` | Wazuh version upgrade process |

---

## Technologies Used

- Wazuh
- Docker
- WSL2
- OpenSearch
- Linux
- Debian
- Raspberry Pi OS
- Windows 11
- macOS

---

## Learning Objectives

This lab was built to practice:

- SIEM deployment and administration
- Endpoint visibility
- Log analysis
- Detection engineering fundamentals
- Linux system administration
- Security monitoring workflows
- SOC investigation concepts

---

## Future Improvements

- n8n workflow automation
- Suricata IDS integration
- Zeek network monitoring
- Docker event monitoring
- Custom dashboards
- Alert tuning
- Active response rules

---

## Documentation

Detailed setup documentation:

- [Wazuh SIEM Installation](./wazuh-siem-setup.md)
- [Wazuh Agent Installation](./wazuh-agent-installation.md)
- [Wazuh Version Upgrade](./update-wazuh-version.md)
  
---
##  Next Steps

* Connect Wazuh alerts to n8n webhook
* Implement first automated response (e.g. block IP after repeated failures)
* Add filtering logic (rule ID, severity)
* Extend monitoring on Raspberry Pi (Docker + SSH events)

---

## 📎 Summary

This setup provides:

* Centralized log collection (Wazuh)
* Basic event detection across multiple systems
* Separate automation layer (n8n on Raspberry Pi)

The environment is designed to stay small, transparent, and easy to modify while still allowing end-to-end testing of detection and response workflows.
