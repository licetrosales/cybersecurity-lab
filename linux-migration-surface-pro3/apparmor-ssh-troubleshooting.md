# AppArmor SSH Profile – Configuration & Troubleshooting Guide
## 1. Objective

Secure the SSH service using AppArmor while maintaining full functionality and avoiding service lockout.

## 2. Initial Problem

After enabling AppArmor in enforce mode, SSH connections failed with errors such as:

- connection reset by peer
- `kex_exchange_identification failed`
- sshd-session failed: Permission denied

Cause:

Required permissions for SSH were missing in the AppArmor profile.
## 3. Root Causes Identified
- Missing execution rule for:
```
/usr/lib/openssh/sshd-session
```
- Missing capabilities (e.g., fsetid)
- Missing access to log files (/var/log/wtmp)
- Incomplete default profile
## 4. Safe Recovery Strategy

To avoid lockout:

### Step 1 — Switch to complain mode
```bash
sudo aa-complain /etc/apparmor.d/usr.sbin.sshd
```
This allows SSH to work while logging violations.

### Step 2 — Reproduce normal usage
- Connect via SSH
- Perform login/logout
- Trigger typical SSH activity
---
### Step 3 — Analyze logs
```bash
sudo journalctl -xe | grep apparmor
```
or:
```
sudo aa-logprof
```
### Step 4 — Use aa-logprof (interactive tuning)
```bash
sudo aa-logprof
```
Typical prompts:

#### Example 1: Missing binary execution
```
/usr/lib/openssh/sshd-auth
```
Choose:
```
(I)nherit
```
#### Example 2: Capability required
```
capability fsetid
```
Choose:
```
(A)llow
```
Example 3: File access
```
/var/log/wtmp.db
```
Choose:
```
(A)llow
```
### Step 5 — Save profile

At the end:
```
(S)ave changes
```
### Step 6 — Enforce profile
```
sudo aa-enforce /etc/apparmor.d/usr.sbin.sshd
```
### Step 7 — Restart SSH
```
sudo systemctl restart ssh
```
### Step 8 — Test access

From remote machine:
```
ssh user@<IP>
```
## 5. Important Issue Encountered
### Conflicting profiles

Error:
```
Conflicting profiles for /usr/sbin/sshd
```
Cause:

- Duplicate profile file (.bak)

Fix:
```
sudo mv /etc/apparmor.d/usr.sbin.sshd.bak /root/
```
## 6. Verification

Check status:
```bash
sudo aa-status
```
Expected:
- sshd listed
- running in enforce mode
## 7. Key Lessons Learned
- Always use complain mode first
- Never enforce blindly on critical services
- AppArmor profiles require real usage tuning
- aa-logprof is essential for safe policy creation
- Backup or duplicate profiles can break AppArmor
## 8. Final Result
- SSH successfully runs under AppArmor enforcement
- No connection failures
- Profile tailored to system behavior
- Increased system security through confinement
