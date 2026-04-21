# Wazuh SIEM Setup deployment on Windows (WSL2 + Ubuntu + Docker)

## Overview

This guide documents the deployment of a **Wazuh single-node SIEM stack** using:

* Windows 11 (host)
* WSL2 (Linux runtime)
* Ubuntu (Linux distribution)
* Docker Desktop (container platform)

The setup provides a **stable, Linux-native environment** for Wazuh avoiding architecture-related issues (e.g., ARM/amd64 incompatibilities).

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

Open **PowerShell as Administrator**:

```bash
wsl --install
```

Reboot your system.

---

## 2. Install Debian

```bash
wsl --install -d Debian
```

On first launch:

* Set username
* Set password

---

## Verify Installation

```bash
wsl -l -v
```

Expected output:

```
Debian    Running    Version 2
```

---

## 3. Prepare Debian

Enter WSL:

```bash
wsl
```

Update system:

```bash
sudo apt update && sudo apt upgrade -y
```

Install required tools:

```bash
sudo apt install -y curl git ca-certificates
```

---

## 4. Install & Configure Docker

Install:

* Docker Desktop for Windows

### Enable WSL Integration

In Docker Desktop:

* Go to **Settings → Resources → WSL Integration**
* Enable **Debian**

---

## Verify Docker in Debian

```bash
docker ps
```

Expected:

* No error message
* Empty container list

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
