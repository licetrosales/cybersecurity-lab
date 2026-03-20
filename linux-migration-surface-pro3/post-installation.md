# Post-Installation Setup

## 1. Overview

This document describes the post-installation steps performed after the base Debian system setup on the Surface Pro 3.

The focus is on:
- minimal and controlled software installation
- secure configuration practices
- reproducibility of the environment
- maintaining a reduced attack surface

---

## 2. Objectives

- Install only essential software
- Prefer browser-based solutions over local applications
- Ensure secure authentication mechanisms (SSH)
- Maintain clear documentation of all system changes

---

## 3. Software Installation

### 3.1 Web Browser (Secondary)

#### Google Chrome

```bash
sudo apt install ./google-chrome-stable_current_amd64.deb
```
#### Purpose:

- Compatibility with specific web applications

#### Security Considerations:

- Closed-source software introduces trust dependency
- Used selectively and separated from primary browser usage

### 3.2 Document Viewer
#### Evince
```bash
sudo apt install evince
```

#### Purpose:
- Lightweight PDF viewing

#### Security Considerations:
- Minimal dependencies reduce attack surface

### 3.3 Email Client
#### Thunderbird
```bash
sudo apt install thunderbird
```

#### Purpose:

- Local email access as alternative to browser-based sessions

#### Security Considerations:

- Supports encryption (OpenPGP)
- Reduces reliance on persistent browser authentication

### 3.4 Development Environment
#### Git
```bash
sudo apt install git
```

Configuration (sanitized):
```bash
git config --global user.name "<USERNAME>"
git config --global user.email "<NOREPLY_EMAIL>"
```
#### Purpose:
- Version control
- Secure interaction with remote repositories

#### Python Environment
```bash
python3 --version
pip3 --version
```
#### Purpose:
- Scripting and automation
- Security tooling and analysis

#### Visual Studio Code
```bash
sudo apt install ./code_*.deb
```
#### Purpose:
- Lightweight development environment
- Integrated Git support

#### Security Considerations:
- Installed from vendor package
- Repository added for updates (trust boundary acknowledged)

#### Secure Authentication Setup
#### SSH Key Generation
```bash
ssh-keygen -t ed25519 -C "<NOREPLY_EMAIL>"
```
Key location:

```
~/.ssh/id_ed25519
```
#### SSH Agent Configuration
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```
#### Purpose:

- Secure key handling in memory
- Avoid repeated authentication prompts

#### GitHub Authentication (SSH)
```bash
cat ~/.ssh/id_ed25519.pub
ssh -T git@github.com
```
#### Outcome:
- Verified secure authentication without password usage

### Workspace Initialization
```bash
mkdir -p ~/projects
cd ~/projects
Repository Cloning (SSH)
git clone git@github.com:<USERNAME>/<REPOSITORY>.git
cd <REPOSITORY>
```
#### Security Consideration:
- SSH preferred over HTTPS to avoid credential exposure

#### Disk Space Verification
```bash
df -h
```
#### Observation:
- Sufficient available storage (>50GB)

#### Operational Relevance:
- Prevents system instability and logging failures
- Supports long-term lab and tooling usage

#### Browser-Based Workflow Strategy

To reduce local data exposure:
- Cloud storage accessed via browser only
- Note-taking tools used via web interface
- Email optionally accessed via browser

#### Benefits:
- Reduced local data persistence
- Lower risk in case of device compromise

#### Lightweight Application Launchers

Example:
```bash
firefox --new-window --name "web-app" https://example.com
```
#### Purpose:
- Simulate application separation
- Avoid installing full desktop clients

#### Lessons Learned
- Correct SSH key paths are critical for authentication
- The home directory (~) is central to user configuration
- chmod +x enables script execution
- Working directory context impacts file operations
- Minimal installations simplify system security management

#### Future Improvements
- Enable commit signing (GPG or SSH signing)
- Further harden SSH configuration
- Automate setup using scripts
- Periodically audit installed packages