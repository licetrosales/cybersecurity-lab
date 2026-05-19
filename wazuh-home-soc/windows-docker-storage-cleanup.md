# Docker WSL2 Storage Maintenance

## 1 Overview

This document describes storage cleanup, Docker maintenance, and VHDX compaction operations performed on the Wazuh Home SOC lab environment hosted on Windows 11 with Docker Desktop and WSL2.

The maintenance activities were performed to reclaim disk space, remove unused Docker artifacts, and optimize the Docker virtual disk used by WSL2.

The procedures documented include:

* Windows disk cleanup
* Duplicate file review
* Docker image cleanup
* Docker storage analysis
* Hibernate removal
* WSL2 shutdown operations
* Docker VHDX compaction
* Post-maintenance validation

---

# Initial Problem

## Observation

The Windows host system began experiencing low available disk space.

Initial analysis using WizTree identified:

* High Docker storage consumption
* Large WSL2 virtual disk files (`.vhdx`)
* Unused Docker images
* Temporary Windows update files
* Duplicate archived files

---

# Environment

| Component | Platform |
|---|---|
| Host OS | Windows 11 |
| Virtualization | WSL2 |
| Container Runtime | Docker Desktop |
| SIEM Platform | Wazuh 4.14.5 |
| Analysis Tool | WizTree |

---

# Disk Usage Investigation

## WizTree Analysis

WizTree was used to identify large files and storage consumption patterns.

Key observations included:

* Docker virtual disks consuming significant storage
* Duplicate ZIP and PDF files
* Large temporary Windows update files
* Multiple outdated Docker images

Example Docker virtual disk:

```text
docker_data.vhdx
```
# Windows Disk Cleanup
## Disk Cleanup Utility

Windows Disk Cleanup was executed with administrative privileges.

The following cleanup categories were removed:

- Windows Update Cleanup
- Delivery Optimization Files
- Temporary Files
- Recycle Bin contents
- Temporary Internet Files
- Upgrade log files

# Hibernate Removal
Hibernate support was disabled to remove the hibernation file (hiberfil.sys).

Command executed:
```powershell
powercfg /h off
```
This reclaimed additional disk space on the Windows host.

---

