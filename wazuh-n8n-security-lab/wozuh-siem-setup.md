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

## 5. Deploy Wazuh

Create working directory:

```bash
mkdir -p ~/projects
cd ~/projects
```

Clone repository:

```bash
git clone https://github.com/wazuh/wazuh-docker.git -b v4.7.0
cd wazuh-docker/single-node
```

---

## 6. Generate Certificates

```bash
docker compose -f generate-indexer-certs.yml run --rm generator
```

---

## 7. Start Wazuh

```bash
docker compose up -d
```

---

## 🔍 Verify Containers

```bash
docker ps
```

Expected containers:

* wazuh-manager
* wazuh-indexer
* wazuh-dashboard

---

## 8. Access Dashboard

Open in browser:

```
https://localhost
```

### SSL Warning

You will see:

```
Your connection is not private
```

This is expected due to self-signed certificates.

Proceed via:

```
Advanced → Proceed to localhost
```

---

## Default Credentials

Typical default:

```
Username: admin
Password: SecretPassword
```

---

## Troubleshooting

### Docker not working in WSL

Check:

```bash
docker ps
```

If error:

* Ensure WSL integration is enabled in Docker Desktop

---

### Wazuh API not available

Check logs:

```bash
docker compose logs -f
```

Wait 2–5 minutes after initial startup.

---

### Containers not starting

Restart:

```bash
docker compose down
docker compose up -d
```

---

## Next Steps

* Add agents (macOS, Windows, Linux)
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
