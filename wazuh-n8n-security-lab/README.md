# Wazuh + n8n Lab Setup (Docker-based)

## Overview

This project implements a small security monitoring and automation setup using:

* Wazuh (SIEM)
* n8n (workflow automation)
* Multiple endpoints (macOS, Windows, Linux)

The focus is on collecting system events, generating alerts, and processing selected events through automation.

---
# Wazuh Home SOC Lab

## Overview
This project documents the implementation of a lightweight Home SOC (Security Operations Center) using:

- Wazuh SIEM
- Docker
- WSL2
- Windows 11
- macOS
- Debian Linux
- Raspberry Pi 5

The environment was built for cybersecurity learning, SIEM monitoring, endpoint visibility, and SOC operations practice.

---

# Architecture

## Infrastructure Components

| Component | Role |
|---|---|
| Wazuh Manager | Central SIEM management |
| Wazuh Indexer | Event indexing and storage |
| Wazuh Dashboard | Web visualization |
| Docker | Container runtime |
| WSL2 | Linux virtualization layer |

### Wazuh Home SOC Architecture

```text
                           ┌────────────────────────────┐
                           │ Windows 11 Host            │
                           │ Fujitsu Laptop             │
                           │ 192.168.178.51             │
                           │ WSL2 + Docker              │
                           └─────────────┬──────────────┘
                                         │
                    ┌────────────────────┼────────────────────┐
                    │                    │                    │
          ┌─────────▼─────────┐ ┌────────▼────────┐ ┌────────▼────────┐
          │ Wazuh Manager     │ │ Wazuh Indexer   │ │ Wazuh Dashboard │
          │ Port 1514 / 1515  │ │ Port 9200       │ │ HTTPS 443       │
          └─────────┬─────────┘ └─────────────────┘ └─────────────────┘
                    │
     ┌──────────────┼─────────────────────────────────────────────┐
     │              │                     │                       │
┌────▼─────┐ ┌──────▼──────┐ ┌────────────▼──────────┐ ┌─────────▼────────┐
│ macOS    │ │ Windows 11  │ │ Debian Linux          │ │ Raspberry Pi 5   │
│ mac-cli  │ │ win-cli-01  │ │ licet-surfacepro3     │ │ raspi-cli-01     │
│ Agent    │ │ Agent       │ │ Agent                 │ │ Sensor Node       │
└──────────┘ └─────────────┘ └───────────────────────┘ └──────────────────┘
```
---

# Monitored Endpoints

| Agent | OS | IP |
|---|---|---|
| mac-cli-01 | macOS | 192.168.178.55 |
| win-cli-01 | Windows 11 | 192.168.178.51 |
| licet-surfacepro3 | Debian Linux | 192.168.178.49 |
| raspi-cli-01 | Raspberry Pi OS | 192.168.178.67 |

---

# Installation Documentation

1. Wazuh SIEM installation
2. Wazuh agent deployment
3. Wazuh 4.7 → 4.14.5 migration
4. Linux endpoint onboarding
5. Raspberry Pi sensor integration
6. Troubleshooting and recovery

---

# Security Objectives

- Endpoint visibility
- Linux monitoring
- Windows event monitoring
- macOS telemetry
- SSH monitoring
- File integrity monitoring
- Vulnerability scanning
- Centralized log analysis

---

# Future Improvements

- Suricata IDS
- Zeek Network Monitoring
- Syslog centralization
- Docker monitoring
- Alert tuning
- Custom dashboards
- Active response rules

---

# Technologies

- Docker
- WSL2
- Wazuh
- OpenSearch
- Linux
- Debian
- Raspberry Pi
- macOS
- Windows 11

---

# Screenshots



---

# Author



---

## Architecture

| Component                                | Location              | Function                                      |
| ---------------------------------------- | --------------------- | --------------------------------------------- |
| Wazuh (Manager + OpenSearch + Dashboard) | MacBook (Docker)      | Central log collection, correlation, alerting |
| n8n                                      | Raspberry Pi (Docker) | Automation workflows                          |
| macOS                                    | MacBook               | Monitored endpoint                            |
| Windows 11                               | Fujitsu notebook      | Monitored endpoint                            |
| Debian Linux                             | Surface Pro           | Monitored endpoint                            |
| Raspberry Pi                             | Raspberry Pi 8 GB     | Automation host + optional monitored endpoint |
| Kali Linux VM                            | VMware Fusion         | Test system for event generation              |

---

## Environment

* Host (SIEM): macOS with Docker Desktop
* Automation host: Raspberry Pi 8 GB (Docker)
* Network: local LAN (FritzBox)
* Communication: internal IP-based (no public exposure)

---

## Deployment

### Wazuh (single-node, Docker on MacBook)

```bash id="w1kq2x"
git clone https://github.com/wazuh/wazuh-docker.git -b v4.7.0
cd wazuh-docker/single-node
docker-compose up -d
```

Access:

```text id="w2p9jd"
https://localhost
```

---

### n8n (Docker on Raspberry Pi)

```bash id="w3m8az"
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

Access:

```text id="w4t6gh"
http://<raspberry-pi-ip>:5678
```

---

## Agents

### macOS (local)

* Installed via `.pkg`
* Sends system events to Wazuh manager

### Windows 11

* Installed via `.msi`
* Configured with manager IP

### Debian (Surface Pro)

* Installed via `.deb`
* Integrated with:

  * Auditd
  * AIDE
  * Fail2Ban

### Raspberry Pi (optional)

* Can run Wazuh agent
* Useful for monitoring:

  * SSH access
  * system services
  * Docker activity (n8n container)

---

## Data Collection

Collected event types include:

* Authentication events (SSH, login attempts)
* File modifications (Auditd / AIDE)
* Privileged command execution (sudo)
* System and service logs

---

## Test Cases

Used to validate detection and alert flow:

### Failed login attempt

```bash id="w5k7pl"
ssh invaliduser@localhost
```

### File modification

```bash id="w6d2xz"
sudo nano /etc/passwd
```

### Privileged action

```bash id="w7r9vb"
sudo useradd testuser
```

These events generate alerts in the Wazuh dashboard.

---

## Automation (n8n)

n8n runs on the Raspberry Pi and processes selected events.

Typical workflow:

1. Receive event (via webhook or API)
2. Filter by rule or severity
3. Trigger action

Example actions:

* Send notification
* Execute script (e.g. block IP)
* Log or forward event

---

##  Integration Concept

```text id="w8x3lm"
Wazuh → Alert → Webhook/API → n8n → Action
```

This enables simple event-driven automation without additional infrastructure.

---

##  Constraints

* Limited RAM on some devices → Wazuh runs on MacBook
* Small number of endpoints → focus on functionality
* No VLAN / segmentation (FritzBox)
* Local-only setup (no external exposure)

---

##  Notes

* Raspberry Pi separates automation from SIEM workload
* Setup is intentionally small and test-focused
* Components can be redistributed later if needed

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
