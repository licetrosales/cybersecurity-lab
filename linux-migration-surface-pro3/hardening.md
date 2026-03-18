# System Hardening Documentation

## Linux Hardening – Debian 13 (Surface Pro 3)

---

## 1. Objective

Apply baseline security hardening measures to a fresh Debian 13 XFCE installation to improve system security, resilience, and maintainability.

---

## 2. Patch Management

### Configuration

System updates were applied and automatic updates enabled.

```bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
```
### Automatic Updates

The system is configured to receive updates regularly to ensure security patches are applied in a timely manner.

### Rationale

Keeping the system up to date reduces exposure to known vulnerabilities and ensures stability.

## 3. Firewall Configuration (UFW)
### Configuration Steps

```bash
sudo apt install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

### Logging

```bash
sudo ufw logging medium
Verification
sudo ufw status verbose
```

### Result

- Incoming traffic: denied by default
- Outgoing traffic: allowed
- Logging: enabled (medium level)
- Firewall enabled at system startup

### Rationale

A default-deny firewall policy reduces attack surface by blocking unsolicited incoming connections.

## 4. System Backup & Recovery (Timeshift)
### Installation

```bash 
sudo apt install timeshift
```

### Configuration

Timeshift was configured in RSYNC mode with the following settings:

- Snapshot location: system partition (/dev/sda2)
- Snapshot frequency: daily
- Retention policy: keep 3 snapshots
- Scheduled snapshots: enabled

### Exclusions

User directories were excluded to prevent unnecessary storage usage:

- /home excluded via Users configuration
- /root excluded
- Additional filter rules applied:
```
-/home/licetu/**
-/root/**
````

### First Snapshot

An initial system snapshot was created manually to establish a baseline recovery point.

### Purpose

- System recovery only (not a user data backup solution)
- Enables rollback after misconfiguration, failed updates, or system instability

### Rationale

Separating system snapshots from user data ensures efficient storage usage and faster recovery operations.

## 5. Logging and Monitoring
Firewall Logging

- UFW logging level set to: medium

### System Logs

- Default Debian logging mechanisms retained (journald, /var/log)

### Rationale

Logging enables visibility into system activity and supports troubleshooting and incident response.

## 6. Baseline Security Posture

After applying the above measures, the system has the following characteristics:

- Regular updates enabled
- Firewall active with restrictive inbound policy
- Logging enabled for network activity
- System snapshot capability configured
- User data excluded from system backups

## 7. Status

Hardening phase (initial baseline) completed successfully.

Next steps may include:

- User and privilege hardening
- SSH hardening (if remote access is used)
- Disk encryption (if required)
- Intrusion detection / monitoring tools
