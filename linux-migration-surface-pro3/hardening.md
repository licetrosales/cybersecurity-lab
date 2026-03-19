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

- Primary user: `username` (administrative user with sudo privileges)
- Secondary user: standard user without sudo privileges

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
groups username
groups guest
```

Results:

- username belongs to administrative and device-related groups, including sudo
- guest has no sudo privileges

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
ssh-copy-id username@192.168.xxx.xxx
```

### Windows Key Transfer

On Windows PowerShell, the public key was transferred to the Surface Pro 3 using:

```bash
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh username@192.168.xxx.xxx "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

This command appends the Windows public key directly to the authorized_keys file of the target user.

### Verification

SSH login was tested successfully from both MacBook and Windows Lifebook:

```bash
ssh usernameu@192.168.xxx.xxx
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
AllowUsers username
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
sudo ufw allow from 192.168.178.0/24 to any port 22 proto tcp
sudo ufw status verbose
```

### Final Firewall Status

Final SSH-related firewall state:

- SSH allowed only from 192.168.178.0/24
- no global Anywhere SSH rule remains

### Result

- SSH accessible only from trusted devices in the local network
- password authentication disabled
- direct root login disabled
- only explicitly allowed administrative user (username) can connect remotely

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

## 9. Shell Usability & Configuration (ZSH)
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

## 10. Baseline Security Posture

After applying the above measures, the system has the following characteristics:

- Regular updates enabled
- Firewall active with restrictive inbound policy
- Logging enabled for network activity
- System snapshot capability configured
- User data excluded from system backups
- separation of administrative and standard users
- locked root account
- SSH key-based authentication from trusted devices
- disabled SSH password authentication
- disabled direct root login
- SSH access restricted to the local network
- Time synchronization enabled (via NTP)
- firewall enforcing least-privilege access
- improved shell usability

---

## 11. Status

Hardening phase (initial baseline) completed successfully.

Next steps may include:

- Service hardening (disable unnecessary services)
- Intrusion detection (e.g., fail2ban)
- Disk encryption (if required)
- Advanced monitoring
