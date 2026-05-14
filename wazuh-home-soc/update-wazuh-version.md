# Wazuh Stack Upgrade and Maintenance

## Overview

This document describes the upgrade and maintenance operations performed on the Wazuh Home SOC lab environment.

The procedures documented include:

* Wazuh stack upgrade from version 4.7 to 4.14.5
* SSL certificate regeneration
* Agent re-enrollment
* Endpoint naming standardization
* Post-upgrade validation
* Operational troubleshooting

The environment runs as a Docker-based deployment hosted inside Ubuntu on WSL2.

---

# Initial Environment

## Infrastructure

| Component       | Platform       |
| --------------- | -------------- |
| Wazuh Manager   | Docker         |
| Wazuh Indexer   | Docker         |
| Wazuh Dashboard | Docker         |
| Host System     | Windows 11     |
| Linux Runtime   | Ubuntu on WSL2 |

---

## Initial Stack Version

```text id="9m5e3u"
Wazuh 4.7
```

---

## Network Architecture

The Wazuh stack runs inside Docker containers hosted within Ubuntu on WSL2.

```text id="v2k55x"
Windows Host
   └── WSL2
         └── Docker
               └── Wazuh Stack
```

Because WSL2 uses virtual networking and NAT, monitored endpoints communicate through the Windows host IP address rather than the internal WSL2 IP address.

Example addressing:

| Type             | Example       |
| ---------------- | ------------- |
| Windows Host IP  | `192.168.X.X` |
| Internal WSL2 IP | `172.23.X.X`  |

---

# Upgrade Motivation

## Issue Encountered

After deploying additional agents, the following compatibility issue occurred:

```text id="v8o2rl"
ERROR: Agent version must be lower or equal to manager version
```

---

## Root Cause

The Wazuh manager was running an outdated version:

```text id="t04k4m"
Wazuh 4.7
```

Newly installed agents used a newer release version, resulting in version incompatibility between manager and agents.

---

# Upgrade Procedure

## 1. Update Docker Images

Edit the Docker Compose configuration:

```bash id="91hxg9"
nano docker-compose.yml
```

Update all Wazuh image versions:

```yaml id="3upwyu"
image: wazuh/wazuh-manager:4.14.5
image: wazuh/wazuh-indexer:4.14.5
image: wazuh/wazuh-dashboard:4.14.5
```

---

## 2. Stop Existing Containers

```bash id="myv4m8"
docker compose down
```

---

## 3. Pull Updated Images

```bash id="6cjlwm"
docker compose pull
```

---

## 4. Deploy Updated Stack

```bash id="sjmtcf"
docker compose up -d
```

---

# SSL Certificate Regeneration

## Issue Encountered

After the upgrade, the indexer generated SSL-related errors.

### Example Errors

```text id="m1yjlwm"
unable to verify the first certificate
SSLHandshakeException (bad_certificate)
```

---

## Root Cause

Existing certificates were generated using the previous stack version and were no longer compatible after the upgrade.

---

## Resolution

### 1. Remove Existing Certificates

```bash id="q6l9ba"
sudo rm -rf config/wazuh_indexer_ssl_certs
```

---

### 2. Generate New Certificates

```bash id="lkq78g"
docker compose -f generate-indexer-certs.yml run --rm generator
```

---

### 3. Restart the Stack

```bash id="knzjlwm"
docker compose down
docker compose up -d
```

---

# Agent Re-Enrollment

## Overview

Following the stack upgrade, some agents required re-enrollment to restore communication with the updated manager.

Affected endpoints included:

* Windows 11
* macOS
* Debian Linux
* Raspberry Pi OS

---

## Re-Enrollment Procedure

Example command:

```bash id="r4cjlwm"
sudo /Library/Ossec/bin/agent-auth -m 192.168.X.X -A mac-cli-01
```

Restart the agent service after enrollment.

---

# Endpoint Naming Standardization

## Initial Observation

The macOS endpoint initially appeared in the Wazuh dashboard using the system hostname:

```text id="5i2jlwm"
MacBookPro.fritz.box
```

This naming behavior originated from the default macOS hostname configuration.

---

## Standardization Goal

To improve consistency across monitored assets, all endpoints were renamed using the following convention:

```text id="ohoyt3"
<os>-<role>-<id>
```

Examples:

* win-cli-01
* mac-cli-01
* linux-cli-01
* raspi-cli-01

---

## Limitation

Wazuh does not support renaming existing agents directly.

---

## Resolution

### 1. Remove Existing Agent Entry

```bash id="tljlwm"
docker exec -it single-node-wazuh.manager-1 /var/ossec/bin/manage_agents
```

---

### 2. Re-Register the Endpoint

```bash id="mjlwm"
sudo /Library/Ossec/bin/agent-auth -m 192.168.X.X -A mac-cli-01
```

---

### 3. Restart the Agent

```bash id="4jlwm"
sudo /Library/Ossec/bin/wazuh-control restart
```

---

# Validation

## Verify Container Status

```bash id="6jlwm"
docker ps
```

Expected containers:

* wazuh-manager
* wazuh-indexer
* wazuh-dashboard

---

## Verify Cluster Health

```bash id="7jlwm"
curl -k -u admin:SecretPassword https://localhost:9200/_cluster/health?pretty
```

Expected result:

```json id="8jlwm"
"status" : "green"
```

---

## Dashboard Validation

Successful validation confirmed:

* Active agents connected
* Dashboard operational
* Log forwarding functional
* Endpoint visibility restored
* Multi-platform monitoring operational

---

# Troubleshooting Summary

| Issue                  | Cause                    | Resolution                   |
| ---------------------- | ------------------------ | ---------------------------- |
| Agent version mismatch | Outdated manager version | Upgrade Wazuh stack          |
| SSL certificate errors | Legacy certificates      | Regenerate certificates      |
| Dashboard unavailable  | Indexer unhealthy        | Verify cluster health        |
| Port conflicts         | WSL2 / Docker networking | Adjust exposed ports         |
| Duplicate agent names  | Existing agent records   | Remove and re-register agent |

---

# Lessons Learned

Key operational observations during the upgrade process:

* Version compatibility between manager and agents is critical
* Certificate regeneration may be required after major upgrades
* Standardized naming improves SIEM asset management
* WSL2 networking introduces additional troubleshooting considerations
* Structured validation improves operational reliability

---

# Technologies Used

* Wazuh
* Docker
* Docker Compose
* WSL2
* Ubuntu
* OpenSearch
* Windows 11
* macOS
* Debian Linux
* Raspberry Pi OS

---

# Status

* Wazuh stack upgraded successfully
* SSL certificates regenerated
* Endpoint communication restored
* Multi-platform monitoring operational
* Dashboard fully functional
