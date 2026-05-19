# Docker WSL2 Storage Maintenance

## Overview

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

# Docker Cleanup
## Review Existing Images

Docker Desktop was used to review existing images, containers, and volumes.

Unused and outdated images were identified.

Example obsolete image:
```text
wazuh/wazuh-certs-generator:0.0.1
```
## Remove Unused Images

Unused images were removed manually through Docker Desktop.

Only images confirmed as unused were deleted.

Active Wazuh images remained intact:

- wazuh-manager
- wazuh-indexer
- wazuh-dashboard

---

# Docker Storage Analysis
## Docker Disk Usage

Docker storage usage was reviewed using:
```bash
docker system df
```
The analysis confirmed:

- Multiple inactive containers
- Reclaimable image space
- Persistent Docker volumes in use

---
# WSL2 and Docker VHDX Compaction
## Problem

Although unused Docker images and files had been removed, the Docker virtual disk (`docker_data.vhdx`) did not automatically shrink.

## Root Cause

WSL2 virtual disks dynamically expand but do not automatically compact after file deletion.

Manual compaction is required.

# Compaction Procedure
## 1. Shut Down WSL2

PowerShell was opened as Administrator.

WSL2 was stopped using:
```bash
wsl --shutdown
```
## 2. Locate Docker Virtual Disk

Docker storage location:
```text
C:\Users\<user>\AppData\Local\Docker\wsl\disk\
```
Verify the VHDX file:
```bash
ls
```
Expected result:
```text
docker_data.vhdx
```
## 3. Compact the Virtual Disk

The virtual disk was compacted using:
```powershel
Optimize-VHD -Path "C:\Users\<user>\AppData\Local\Docker\wsl\disk\docker_data.vhdx" -Mode
Full
```
# Issue Encountered
## Error

Initial compaction failed with:
```text
The process cannot access the file because it is being used by another process.
```
## Cause

Docker Desktop background processes were still using the virtual disk.

## Resolution

Docker Desktop processes were terminated using Task Manager.

After Docker shutdown, the compaction operation completed successfully.


