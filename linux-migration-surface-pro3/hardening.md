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

---

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
```
### Verification
```bash
sudo ufw status verbose
```

### Result

- Incoming traffic: denied by default
- Outgoing traffic: allowed
- Logging: enabled (medium level)
- Firewall enabled at system startup

### Rationale

A default-deny firewall policy reduces attack surface by blocking unsolicited incoming connections.

---

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
-/home/username/**
-/root/**
```

### First Snapshot

An initial system snapshot was created manually to establish a baseline recovery point.

### Purpose

- System recovery only (not a user data backup solution)
- Enables rollback after misconfiguration, failed updates, or system instability

### Rationale

Separating system snapshots from user data ensures efficient storage usage and faster recovery operations.

---

## 5. Logging and Monitoring
Firewall Logging

- UFW logging level set to: medium

### System Logs

- Default Debian logging mechanisms retained (journald, /var/log)

### Rationale

Logging enables visibility into system activity and supports troubleshooting and incident response.

---

## 6. User & Privilege Hardening

### User Accounts

A secondary standard user account was created for non-administrative use.

- Primary user: `<ADMIN_USER>` (administrative user with sudo privileges)
- Secondary user: `<STANDARD_USER>` (standard user without sudo privileges)

User accounts were reviewed using:

```bash
cat /etc/passwd
```
To list human users (UID >= 1000):

```bash
awk -F: '$3 >= 1000 {print $1}' /etc/passwd
```
### Group Membership Review

User group memberships were inspected:

```bash
groups <ADMIN_USER>
groups <STANDARD_USER>
```

Results:

- <ADMIN_USER> belongs to administrative and device-related groups, including sudo
- <STANDARD_USER> has no sudo privileges

### Root Account Status

The root account status was verified:

```bash
sudo passwd -S root
```

Observed result indicated:

- root account locked (L)
- direct root login not possible

### Rationale

- User separation reduces risk of accidental or unauthorized administrative changes
- Limiting sudo access enforces the principle of least privilege
- A locked root account reduces exposure to direct privileged access

---

## 7. SSH Configuration & Hardening
### SSH Installation & Verification

OpenSSH server was installed and verified:

```bash
sudo apt install openssh-server
sudo systemctl status ssh
```

### Initial Firewall Adjustment for SSH

SSH access was initially allowed through the firewall to enable remote administration setup:

```bash
sudo ufw allow ssh
sudo ufw status verbose
```

This temporarily created a rule allowing SSH on port 22 from any source.

### Key-Based Authentication

SSH key pairs were generated on:

- MacBook
- Windows Lifebook

## MacBook Key Transfer

The key was copied using:

```bash
ssh-copy-id <ADMIN_USER>@<LOCAL_ID>
```

### Windows Key Transfer

On Windows PowerShell, the public key was transferred to the Surface Pro 3 using:

```bash
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh <ADMIN_USER>@<LOCAL_ID> "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

This command appends the Windows public key directly to the authorized_keys file of the target user.

### Verification

SSH login was tested successfully from both MacBook and Windows Lifebook:

```bash
ssh <ADMIN_USER>@<LOCAL_ID>
```

Results:

- login successful from both trusted devices
- key-based authentication works
- local key passphrase requested where configured

### SSH Server Hardening

The SSH server configuration was updated in:

```bash
sudo nano /etc/ssh/sshd_config
```

The following settings were added explicitly:

```
PasswordAuthentication no
PermitRootLogin no
PubkeyAuthentication yes
AllowUsers <ADMIN_USER>
```

### Apply Changes: Service Restart
```bash
sudo systemctl restart ssh
```

### Post-Change Validation

SSH access was re-tested from both trusted client devices after restarting the SSH service.

Results:

- SSH login remained functional
- password-based SSH login disabled
- only authorized key-based access allowed

### Final Firewall Restriction (LAN Only)

After SSH key access was confirmed functional, the initial broad SSH firewall rule was removed and replaced with a LAN-restricted rule.

Broad rule removed:

```bash
sudo ufw delete allow ssh
```

Restricted replacement rule applied:

```bash
sudo ufw allow from <LAN_SUBNET> to any port 22 proto tcp
sudo ufw status verbose
```

### Final Firewall Status

Final SSH-related firewall state:

- SSH allowed only from <LAN_SUBNET>
- no global Anywhere SSH rule remains

### Result

- SSH accessible only from trusted devices in the local network
- password authentication disabled
- direct root login disabled
- only explicitly allowed administrative user (<ADMIN_USER>) can connect remotely

### Rationale

- Reduces exposure of SSH service
- Prevents remote brute-force password attacks
- Restricts administrative access to trusted local systems
- Enforces strong authentication using SSH keys

---

## 8. Time Synchronization (NTP)
### Issue

System time was initially not synchronized automatically.

### Resolution

Time synchronization support was enabled:

```bash
sudo apt install systemd-timesyncd
sudo systemctl enable systemd-timesyncd
sudo systemctl start systemd-timesyncd
timedatectl
```

### Result

- time synchronization active
- system clock synchronized
- NTP service active
- timezone configured as Europe/Berlin

### Rationale

Correct system time is important for:

- accurate log timestamps
- security auditing
- certificate validation
- reliable scheduling and system behavior

---

## 9. Service Hardening (Attack Surface Reduction)

### Objective

Reduce system attack surface by identifying and disabling unnecessary services.

### Service Review

Running services were reviewed using:

```bash
systemctl list-units --type=service --state=running
```
### Disabled Services

The following services were identified as unnecessary based on system usage and were disabled:

#### ModemManager

```bash
sudo systemctl disable --now ModemManager
```

- Purpose: Mobile broadband (SIM/LTE connectivity)
- Decision: Not required (device uses WiFi only)

#### CUPS (Printing Services)

```bash
sudo systemctl disable --now cups
sudo systemctl disable --now cups-browsed
```
- Purpose: Printing and printer discovery
- Decision: Not required (no printer in use)

### Retained Services

The following services were kept due to functional requirements:

- NetworkManager → WiFi connectivity
- wpa_supplicant → wireless authentication
- bluetooth → wireless headphones
- ssh → remote administration
- systemd-* services → core system functionality
- cron, dbus, polkit → essential system services

### Optional Services (Not Modified)

avahi-daemon → retained (network discovery; may be disabled later if not required)

### Result

- Reduced number of running services (26 → 23)
- Lower system exposure to potential vulnerabilities
- Improved system performance and maintainability

### Rationale

Disabling unused services minimizes the attack surface and follows the principle of least functionality, reducing the risk of exploitation.

---

## 10 Kernel & Network Hardening

### Configuration

Kernel parameters were hardened using sysctl to improve network security and reduce attack surface.

#### Configuration file:

```bash
sudo nano /etc/sysctl.d/99-hardening.conf
```

### Applied settings:

```bash
# IP Spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP redirects (MITM protection)
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

# Disable sending redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Log suspicious packets
net.ipv4.conf.all.log_martians = 1

# Ignore bogus ICMP errors
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Disable source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# SYN flood protection
net.ipv4.tcp_syncookies = 1

# Disable core dumps (security hardening)
fs.suid_dumpable = 0
kernel.core_pattern = |/bin/false
```

### Apply Configuration

```bash
sudo sysctl --system
```

### Verification
```bash
sysctl net.ipv4.conf.all.rp_filter
sysctl net.ipv4.tcp_syncookies
```

### Result

- IP spoofing protection enabled
- ICMP redirect attacks mitigated
- Source routing disabled
- Suspicious packets logged
- SYN flood protection enabled
- Core dumps disabled at kernel level

### Rationale

These kernel-level protections:

- reduce exposure to network-based attacks
- prevent traffic manipulation (MITM, spoofing)
- improve system resilience against denial-of-service conditions
- protect sensitive memory from being written to disk


---

## 11. Resource Limits Hardening**

### Configuration

System-wide resource limits were configured to prevent core dump generation and reduce risk of sensitive data exposure.

### Configuration file:

```bash
sudo nano /etc/security/limits.conf
```

### Applied setting:

```bash
* hard core 0
```

### Verification

```bash
ulimit -c
```

### Result:

```
0
```
### Result

- Core dump generation disabled for all users
- No process can write memory dumps to disk

### Rationale

Disabling core dumps:

- prevents sensitive memory contents from being written to disk
- reduces risk of credential or data leakage
- limits forensic exposure in case of compromise

### Notes

This configuration works in conjunction with kernel-level settings:
```
fs.suid_dumpable = 0
kernel.core_pattern = |/bin/false
```

Together, these provide defense-in-depth against unintended memory disclosure.

---

## 12. Filesystem Hardening

### Objective

Strengthen filesystem security by restricting execution, limiting privilege escalation vectors, and enforcing proper permissions on shared and user directories.

---

### 12.1 `/tmp` Hardening

#### Current State

`/tmp` is mounted as a `tmpfs` (memory-backed filesystem), which is appropriate for temporary data.

#### Configuration

The `/tmp` mount options were hardened via:

```bash
sudo nano /etc/fstab
```
Modified entry:

```bash
tmpfs /tmp tmpfs defaults,noatime,noexec,nosuid,nodev,mode=1777 0 0
```

#### Applied Changes

```bash
sudo systemctl daemon-reexec
sudo mount -o remount /tmp
```

#### Verification

```bash
mount | grep /tmp
```

#### Result:
- noexec → prevents execution of binaries from /tmp
- nosuid → disables SUID/SGID privilege escalation
- nodev → prevents device file usage
- mode=1777 → ensures world-writable directory with sticky bit protection

#### Rationale

'/tmp' is a shared writable directory and a common target for attacks. These restrictions:

- prevent execution of malicious payloads
- reduce privilege escalation risks
- ensure safe multi-user usage via sticky bit

### 12.2 `/dev/shm` Hardening
#### Current State

'/dev/shm' is a shared memory filesystem ('tmpfs') used for inter-process communication.

#### Configuration

A dedicated secure mount entry was added:

```bash
sudo nano /etc/fstab
```
Added entry:

```bash
tmpfs /dev/shm tmpfs defaults,noexec,nosuid,nodev 0 0
```
#### Applied Changes

```bash
sudo systemctl daemon-reexec
sudo mount -o remount /dev/shm
```
#### Verification
mount | grep shm

#### Result:

- noexec → prevents execution from shared memory
- nosuid → disables privilege escalation
- nodev → blocks device file usage

#### Rationale

Shared memory can be abused for fileless or in-memory attacks. Hardening reduces:
- execution of malicious code from RAM
- exploitation of shared memory mechanisms

### 12.3 Home Directory Permissions
#### Verification
```bash
ls -ld /home/*
```

Observed:
```bash
drwx------ /home/<ADMIN_USER>
drwx------ /home/<STANDARD_USER>
```

#### Result

- user home directories are restricted to their owners
- no access for other users or groups

#### Rationale

Ensures user data confidentiality and enforces isolation between accounts.

### 12.4 Sticky Bit Verification (`/tmp`)
#### Verification
```bash
ls -ld /tmp
```

Observed:
```bash
drwxrwxrwt
```
#### Result

- sticky bit (t) is set
- users can only delete their own files

#### Rationale
Prevents users from interfering with other users’ files in shared directories.

### 12.5 Result

- `/tmp` hardened with execution and privilege restrictions
- `/dev/shm` secured against in-memory execution attacks
- user home directories properly isolated
- sticky bit enforced for safe shared directory usage

### 12.6 Rationale (Summary)

Filesystem hardening:

- reduces attack surface in shared writable locations
- mitigates privilege escalation vectors
- prevents execution of untrusted code
- enforces strong user isolation

---

## 13. Intrusion Prevention (Fail2Ban)

### Objective

Implement host-based intrusion prevention to detect and mitigate brute-force attacks against exposed services, particularly SSH.

---

### Installation

Fail2Ban was installed using:

```bash
sudo apt install fail2ban
```

### Service Enablement
Fail2Ban service was enabled and started:

```bash
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### Configuration
A local configuration file was created to override default settings:
```bash
sudo nano /etc/fail2ban/jail.local
```
#### Configuration Content
```bash
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 7
backend = systemd

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
```
### Configuration Explanation
- bantime = 1h
Offending IP addresses are blocked for 1 hour

- findtime = 10m  
Failed login attempts are counted within a 10-minute window

- maxretry = 7  
IP is banned after 7 failed authentication attempts

- backend = systemd  
Uses systemd journal for log monitoring

- [sshd] jail enabled   
Protects SSH service from brute-force attacks

### Service Restart

Configuration changes were applied:

```bash
sudo systemctl restart fail2ban
```
### Verification

Global status:
```bash
sudo fail2ban-client status
```
SSH jail status:
```bash
sudo fail2ban-client status sshd
```
Observed:

- SSH jail active
- No banned IPs at time of verification
- Monitoring system logs successfully

### Result
- Automatic detection of repeated failed SSH login attempts
- Dynamic blocking of malicious IP addresses via firewall rules
- Protection against brute-force and credential guessing attacks

### Security Context
This system already enforces:
- SSH key-based authentication only
- Disabled password authentication
- SSH access restricted to local network (LAN)

Fail2Ban adds an additional defensive layer:
- Detects suspicious behavior even within trusted networks
- Provides automated response to repeated failed access attempts

### Rationale

Fail2Ban enhances system security by:
- Reducing the risk of brute-force attacks
- Automating incident response
- Complementing firewall and SSH hardening
- Implementing defense-in-depth strategy

---

## 14. Shell Usability & Configuration (ZSH)
### Installation

```bash
sudo apt install zsh
chsh -s /bin/zsh
```
### Syntax Highlighting

```bash
sudo apt install zsh-syntax-highlighting
```
### Configuration

```bash
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```
### Verification

```bash
ls /usr/share/zsh-syntax-highlighting/
source ~/.zshrc
```

### Result

- Commands visually highlighted
- Invalid commands easier to detect

### Rationale

Improves operational security by reducing command errors.

---

## 15. Audit Logging (Auditd)

### Overview

Auditd provides detailed logging of system activity, including:

- File access and modifications
- Permission changes
- Privileged operations
- Authentication-related events

This enables detection, investigation, and forensic analysis.

---

### Installation

```bash
sudo apt install auditd audispd-plugins
sudo systemctl enable auditd
sudo systemctl start auditd
```

### Verify Service
sudo auditctl -s

Expected output:

- enabled 1 → auditing active
- failure 1 → system logs critical failures

### Configured Rules

Custom rules were added:
```bash
sudo nano /etc/audit/rules.d/hardening.rules
```
Identity Changes
```bash
## ================================
## Identity & Account Changes
## ================================
-w /etc/passwd -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/group -p wa -k identity

## ================================
## Privilege Escalation
## ================================
-w /etc/sudoers -p wa -k privilege
-w /etc/sudoers.d/ -p wa -k privilege

## ================================
## SSH Configuration Changes
## ================================
-w /etc/ssh/sshd_config -p wa -k ssh

## ================================
## Authentication Logs
## ================================
-w /var/log/auth.log -p wa -k auth

## ================================
## Kernel Module Activity
## ================================
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules

## ================================
## File Deletion Monitoring
## ================================
-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -k delete

## ================================
## Permission Changes
## ================================
-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -k perm_mod
```

### Load Rules
```bash
sudo augenrules --load
```
### Verification
List active rules:
```bash
sudo auditctl -l
```
### Testing
Test 1: File creation
```bash
touch testfile
```
Test 2: Permission change
```bash
chmod 777 testfile
```
Search logs:
```bash
sudo ausearch -k perm_mod
```
### Reporting
Generate summary:
```bash
sudo aureport
```
### Security Benefits

- Detect unauthorized file changes
- Monitor privilege escalation attempts
- Track system configuration modifications
- Provide forensic traceability

### Notes

- System users (e.g., dhcpcd) may appear in logs
- Auditd records both user and system activity
- Rules can impact performance if too broad

### Report Interpretation

The `aureport` command provides a high-level summary of system activity.

Key indicators:

- **failed logins / authentications**  
  Detect brute-force or unauthorized access attempts

- **anomaly events**  
  Indicate suspicious or unexpected system behavior

- **failed syscalls**  
  May indicate exploitation attempts or misconfigurations

- **number of users**  
  Includes both human and system users (e.g., services)

- **number of events**  
  Reflects overall system activity

---

### Baseline Observation

During initial hardening:

- No failed logins or authentication attempts
- No anomaly or integrity events detected
- All activity corresponds to administrative actions
- Audit rules successfully capture permission and file changes

This establishes a clean baseline for future monitoring.

---

## 16. Baseline Security Posture

After applying the above measures, the system has the following characteristics:

- Regular updates enabled
- Firewall active with restrictive inbound policy
- Firewall logging enabled
- Intrusion prevention via Fail2Ban (SSH protection)
- System snapshot capability configured (Timeshift)
- User data excluded from system backups

### Identity & Access Management

- Separation of administrative and standard users
- Limited sudo access (principle of least privilege)
- Root account locked
- SSH key-based authentication enforced
- SSH password authentication disabled
- Direct root login disabled
- SSH access restricted to local network (LAN only)

### Network Security

- Unnecessary services removed (e.g., CUPS, ModemManager)
- Kernel-level network hardening applied (sysctl)
  - IP spoofing protection enabled
  - ICMP redirects disabled
  - Source routing disabled
  - SYN flood protection enabled
  - Suspicious packet logging enabled

### System Hardening

- Core dumps disabled (prevents sensitive memory leaks)
- Resource limits enforced (`ulimit`, `/etc/security/limits.conf`)
- Reduced risk of privilege escalation via kernel protections
- SUID dumpability disabled (`fs.suid_dumpable = 0`)
  
### Filesystem Security

- `/tmp` mounted with:
  - `noexec`, `nosuid`, `nodev`
- `/dev/shm` mounted with:
  - `noexec`, `nosuid`, `nodev`
- Sticky bit enforced on shared directories (`/tmp`)
- Home directories restricted to owner access only
- Reduced risk of execution from temporary or shared locations

### Monitoring & Auditing

- Auditd enabled for system activity monitoring
- Key security-relevant files monitored:
  - `/etc/passwd`, `/etc/shadow`, `/etc/group`
  - `/etc/sudoers`, `/etc/sudoers.d`
  - `/etc/ssh/sshd_config`
  - `/var/log/auth.log`
- System call auditing enabled for:
  - Permission changes (`chmod`, `fchmod`)
  - File deletion (`unlink`, `rename`)
  - Kernel module operations
- Audit rules categorized using keys:
  - `identity`, `privilege`, `ssh`, `auth`, `modules`, `delete`, `perm_mod`
- Audit logs searchable via `ausearch` and summarized via `aureport`
- Baseline system activity established (no anomalies detected)

### Active Defense

- Fail2Ban configured for SSH protection
  - Bans IPs after repeated failed login attempts
  - Configured thresholds:
    - `maxretry = 7`
    - `findtime = 10m`
    - `bantime = 1h`
- Integrated with systemd journal for log monitoring

### System Reliability

- Time synchronization enabled (systemd-timesyncd, NTP)
- Consistent system clock for logging and auditing
- Reduced risk of log inconsistencies
  
### Usability Improvements

- Enhanced shell configuration (ZSH, syntax highlighting)
- Improved command visibility and error detection
- Better operational awareness during administration
  
---

## 17. Status

Hardening phase (initial baseline) completed successfully.

Next steps may include:

- Service hardening (disable unnecessary services)
- Intrusion detection (e.g., fail2ban)
- Advanced monitoring

### Anonymization Notice

All user-specific data such as usernames, IP addresses, and identifiers have been replaced with placeholders:

- `<ADMIN_USER>` → administrative user
- `<STANDARD_USER>` → non-privileged user
- `<LOCAL_IP>` → internal system IP address
- `<LAN_SUBNET>` → local network range
- `<EMAIL>` → user email address