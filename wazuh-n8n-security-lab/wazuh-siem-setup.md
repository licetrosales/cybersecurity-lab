# Wazuh SIEM Setup deployment on Windows (WSL2 + Ubuntu + Docker)

## Overview

This guide documents the deployment of a **Wazuh single-node SIEM stack** using:

* Windows 11 (host)
* WSL2 (Linux runtime)
* Ubuntu (Linux distribution)
* Docker Desktop (container platform)

The setup provides a **stable, Linux-native environment** for Wazuh avoiding architecture-related issues (e.g., ARM/amd64 incompatibilities).

The environment is built using:

- Windows 11 (host system)
- WSL2 (Linux virtualization layer)
- Ubuntu (Linux runtime)
- Docker Desktop (container platform)
- Wazuh (SIEM solution)

---

## Architecture

```
Windows 11
   └── WSL2 (Ubuntu)
         └── Docker (via Docker Desktop)
               └── Wazuh Stack
                        ├── Wazuh Manager
                        ├── Wazuh Indexer
                        └── Wazuh Dashboard
```

---

## Prerequisites

* Windows 11
* Admin privileges
* Internet connection

---

## 1. Install WSL2

Run **PowerShell as Administrator**:
```bash
wsl --install
```
On first launch:

* Set username
* Set password

---

## 2. Verify WSL Installation
```powershell
wsl -l -v
```
Expected output:
```
NAME      STATE    VERSION
Ubuntu    Running  2
```
## 3. Initialize Ubuntu

Start WSL:
```powershell
wsl
```
Create your Linux user:
```
Create a default Unix user account: <username>
```
## 4. Update System

Inside Ubuntu:
```bash
sudo apt update && sudo apt upgrade -y
```
## 5. Install Required Tools
```bash
sudo apt install -y curl git ca-certificates
```
## 6. Install Docker Desktop (Windows)

Download:

` https://docs.docker.com/desktop/install/windows-install/`

Run installer as Administrator

Configuration:
-  Use WSL 2 instead
  
## 7. Fix Docker Installation Issue (Permission Error)
### Problem

Docker installation failed due to:
```
C:\ProgramData\DockerDesktop must be owned by an elevated account
```
### Solution

Run PowerShell as Administrator:
```powershell
Remove-Item -Recurse -Force "C:\ProgramData\DockerDesktop"
```
Verify:
```powershell
Test-Path "C:\ProgramData\DockerDesktop"
```
Recreate and fix permissions:
```powershell
New-Item -ItemType Directory -Path "C:\ProgramData\DockerDesktop"
```
```powershell
icacls "C:\ProgramData\DockerDesktop" /inheritance:r
icacls "C:\ProgramData\DockerDesktop" /grant "SYSTEM:(OI)(CI)F"
icacls "C:\ProgramData\DockerDesktop" /grant "Administrators:(OI)(CI)F"
```
Verify:
```powershell
(Get-Acl "C:\ProgramData\DockerDesktop").Access | Format-List
```
Expected:
```
SYSTEM → FullControl
Administrators → FullControl
```
## 8. Verify Docker Installation

Inside WSL:
```bash
docker version
docker ps
```
Expected:
```
(empty container list)
```
---

## 9. Deploy Wazuh
### 9.1 Create Working Directory (WSL)

All project-related files should be stored inside the WSL Linux filesystem 
for optimal Docker performance.

Create project directory

```bash
mkdir -p ~/projects
cd ~/projects
```
Create working directory:
Verify location
```bash
pwd
```
Expected output:
```
/home/<your-username>/projects
```
### 9.2 Clone Wazuh Docker Repository

Clone the official Wazuh Docker repository (version 4.7.0):
```bash
git clone https://github.com/wazuh/wazuh-docker.git -b v4.7.0
cd wazuh-docker/single-node
```
Notes
- The -b v4.7.0 flag ensures a stable, tested version
- You may see a message about detached HEAD → this is expected


### 9.3 Start Wazuh Stack (Docker Compose)

Start all services in detached mode:
```bash
docker compose up -d
```
Expected behavior
- Docker pulls images:
   - wazuh-manager
   - wazuh-indexer
   - wazuh-dashboard
- Containers are created and started

### 9.4 Troubleshooting: Port Conflict (WSL/Docker Desktop)

During deployment, the following error may occur:
```
Error response from daemon: ports are not available
```
#### Root Cause
- WSL2 port forwarding conflict
- Docker Desktop unable to bind API port (55000/55001)

#### Solution
Edit the compose file:
```bash
nano docker-compose.yml
```
Locate and comment out the API port:
```
# - "55000:55000"
```
Save and exit.

Restart the stack:
```bash
docker compose down
docker compose up -d
```
### 9.5 Verify Running Containers

Check container status:
```bash
docker ps
```
Expected output

All services should be Up:
- wazuh-manager
- wazuh-indexer
- wazuh-dashboard

### 9.6 Verify Port Mappings

Expected ports:

| Service          | Host Port | Container Port |
| ---------------- | --------- | -------------- |
| Wazuh Dashboard  | 443       | 5601           |
| Wazuh Indexer    | 9200      | 9200           |
| Wazuh Manager    | 1514      | 1514           |

---

### 9.7 Access Dashboard

Open in browser:

```
https://localhost
```
Notes
- A certificate warning will appear (self-signed certificate)

### 9.8 Login to Dashboard

Default credentials:
```
Username: admin
Password: SecretPassword
```
### 9.9 Verify Deployment
After login:

- Dashboard loads successfully
- No agents connected (expected initial state)
- All services operational

## 9.10 Validation (Operational Check)

After deployment, the following checks were performed:

### Container Status
```bash
docker ps
```
All containers are running:

- wazuh-manager
- wazuh-indexer
- wazuh-dashboard

### Dashboard Access
- `URL: https://localhost`
- Login successful with default credentials
### Observations
- No agents connected (expected initial state)
- Docker volumes created for persistence
- Port conflict resolved by removing API port binding
### Conclusion
The Wazuh SIEM stack is fully operational and ready for agent integration.

## Next Steps

* Add agents (Windows, macOS, Linux)
* Trigger test alerts
* Integrate n8n for automation
* Implement alert-based workflows

---

## Notes

* This setup avoids ARM/amd64 compatibility issues
* WSL2 provides near-native Linux performance
* Suitable for local lab and learning environment

---

## Summary

This setup provides:

* Stable Wazuh deployment on Windows
* Full SIEM functionality via Docker
* Clean separation between host and container runtime

---

This environment is ready for detection, monitoring, and automation workflows.
