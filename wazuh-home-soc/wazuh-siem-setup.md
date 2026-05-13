# Wazuh SIEM Setup

## Overview

This document describes the deployment of a single-node Wazuh SIEM environment using:

* Windows 11
* WSL2
* Ubuntu
* Docker Desktop
* Wazuh 4.14.5

The environment was designed as a lightweight Home SOC lab for security monitoring, log analysis, endpoint visibility, and detection engineering practice.

The deployment uses Docker containers running inside Ubuntu on WSL2 to provide a Linux-native environment while maintaining compatibility with Windows-based infrastructure.

---

# Architecture

## Infrastructure Stack

```text
Windows 11 Host
   └── WSL2 (Ubuntu)
         └── Docker Desktop
               └── Wazuh Stack
                     ├── Wazuh Manager
                     ├── Wazuh Indexer
                     └── Wazuh Dashboard
```

---

# Prerequisites

Before deployment, ensure the following requirements are available:

* Windows 11
* Administrative privileges
* Stable internet connection
* Virtualization enabled in BIOS
* Docker Desktop compatible with WSL2

---

# Environment Preparation

## 1. Install WSL2

Open PowerShell as Administrator:

```powershell
wsl --install
```

Restart the system if prompted.

Verify the installation:

```powershell
wsl -l -v
```

Expected output:

```text
NAME      STATE    VERSION
Ubuntu    Running  2
```

---

## 2. Initialize Ubuntu

Launch Ubuntu from the Start Menu or run:

```powershell
wsl
```

Create the Linux user account and password.

Update the system:

```bash
sudo apt update && sudo apt upgrade -y
```

Install required packages:

```bash
sudo apt install -y curl git ca-certificates
```

---

## 3. Install Docker Desktop

Download Docker Desktop for Windows:

https://docs.docker.com/desktop/install/windows-install/

During installation:

* Enable WSL2 integration
* Use WSL2 as the backend engine

After installation, verify Docker inside Ubuntu:

```bash
docker version
docker ps
```

Expected result:

```text
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
```

---

# Wazuh Deployment

## 1. Create Working Directory

Inside Ubuntu:

```bash
mkdir -p ~/projects
cd ~/projects
```

Verify the location:

```bash
pwd
```

Example output:

```text
/home/<user>/projects
```

---

## 2. Clone the Wazuh Docker Repository

Clone the official Wazuh Docker repository:

```bash
git clone https://github.com/wazuh/wazuh-docker.git -b v4.14.5
```

Navigate to the single-node deployment:

```bash
cd wazuh-docker/single-node
```

---

## 3. Start the Wazuh Stack

Deploy the environment:

```bash
docker compose up -d
```

The following containers are created:

* wazuh-manager
* wazuh-indexer
* wazuh-dashboard

---

# Networking and Port Considerations

## WSL2 Networking Architecture

The Wazuh environment runs inside Docker containers hosted within Ubuntu on WSL2.

```text
Windows Host
   └── WSL2 Virtual Network
         └── Docker Network
               └── Wazuh Containers
```

Because WSL2 uses NAT and virtual network adapters, external endpoints communicate through the Windows host IP address rather than the internal WSL2 address.

---

## Common Port Conflict Issue

During deployment, Docker may fail with:

```text
Error response from daemon: ports are not available
```

### Cause

Port conflicts between:

* WSL2
* Docker Desktop
* existing Windows services

---

## Resolution

Edit the Docker Compose file:

```bash
nano docker-compose.yml
```

Comment out the API port mapping if necessary:

```yaml
# - "55000:55000"
```

Restart the stack:

```bash
docker compose down
docker compose up -d
```

---

# Validation

## Verify Running Containers

Check container status:

```bash
docker ps
```

Expected containers:

* wazuh-manager
* wazuh-indexer
* wazuh-dashboard

---

## Verify Dashboard Access

Open the dashboard in a browser:

```text
https://localhost
```

A browser certificate warning is expected because the deployment uses self-signed certificates.

---

## Default Credentials

```text
Username: admin
Password: SecretPassword
```

---

## Verify Cluster Health

Run:

```bash
curl -k -u admin:SecretPassword https://localhost:9200/_cluster/health?pretty
```

Expected result:

```json
"status" : "green"
```

---

# Operational Validation

After deployment, the following checks were completed successfully:

* Containers running correctly
* Dashboard accessible
* OpenSearch cluster healthy
* Docker volumes created for persistence
* WSL2 networking functional
* SIEM services operational

At this stage, no agents are connected yet. Endpoint onboarding is documented separately in:

```text
wazuh-agent-installation.md
```

---

# Lessons Learned

Key operational observations from the deployment:

* WSL2 networking introduces additional routing considerations
* Docker port conflicts can affect Wazuh service exposure
* Version consistency between stack components is critical
* Containerized deployments simplify reproducibility and maintenance
* Structured validation improves troubleshooting efficiency

---

# Technologies Used

* Wazuh
* Docker
* Docker Compose
* WSL2
* Ubuntu
* Windows 11
* OpenSearch

---

# Status

* Wazuh stack deployed successfully
* Dashboard operational
* OpenSearch cluster healthy
* Environment ready for endpoint onboarding

