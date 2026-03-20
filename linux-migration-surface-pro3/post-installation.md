# Post-Installation Setup

## 1. Overview

This document describes the post-installation steps performed after the base Debian system setup on the Surface Pro 3.

The focus is on:
- minimal and controlled software installation
- secure configuration practices
- reproducibility of the environment
- maintaining a reduced attack surface
- hardware compatibility and usability optimization
- secure configuration practices
- reproducibility of the environment
- maintaining a reduced attack surface
- hardware compatibility and usability optimization
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

---

## 4. Hardware Configuration: Touchscreen & Auto-Rotation

### Objective

Enable tablet-mode usability on the Surface Pro 3 by ensuring:

- automatic screen rotation
- correct touchscreen alignment in all orientations

### Problem Identification

During regular usage, the device did not behave correctly in tablet scenarios:

- screen rotation was not automatically applied
- touchscreen input became misaligned after manual rotation

This limited usability for touch-based interaction and portrait-oriented tasks.

#### Investigation

The following observations were made:

```bash
monitor-sensor
```
- orientation events were correctly detected (normal, right-up, etc.)

```bash
sudo dmesg | grep -i touch
```
- touchscreen hardware was recognized by the system

#### Conclusion:

- hardware support was present
- issue was caused by missing integration between display rotation and input mapping

### Surface Kernel

A Surface-specific kernel was installed to improve hardware compatibility.

#### Observation:
- touchscreen support existed prior to installation
- however, the Surface kernel provides more consistent driver behavior and is recommended for this device

#### Implementation
#### Display Rotation
```bash
xrandr --output eDP-1 --rotate <orientation>
```
#### Touchscreen Mapping
```bash 
xinput set-prop "NTRG0001:01 1B96:1B05" "Coordinate Transformation Matrix" ...
```
#### Automation Script

A script was created to:
- listen to orientation changes via monitor-sensor
- rotate the display dynamically
- remap touchscreen input accordingly

Script location:
```
scripts/touchscreen-rotation-surf-kernel.sh
```
#### Key Debugging Insight

An initial implementation error used:
```bash
DISPLAY="eDP-1"
```
This overwrote the X11 display variable and caused:
- Can't open display
- failure of xrandr and xinput

Fix:
```bash
OUTPUT="eDP-1"
```

#### Result
- automatic screen rotation functional
- touchscreen input correctly aligned
- tablet-mode usability restored

#### Security Considerations
- solution uses minimal additional software
- relies on standard Linux utilities (xrandr, xinput)
- no additional services or daemons introduced
- script execution remains user-controlled (not system-wide)


## 5. Lessons Learned
- Correct SSH key paths are critical for authentication
- The home directory (~) is central to user configuration
- chmod +x enables script execution
- Working directory context impacts file operations
- Minimal installations simplify system security management


### Hardware & System Integration
- Kernel changes (e.g., Surface kernel) improve compatibility but may not fully solve usability issues
- Input devices and display rotation must be explicitly synchronized
- X11 environment variables (e.g., DISPLAY) are critical for graphical command execution
- Debugging requires combining multiple tools (`xinput`, `xrandr`, `dmesg`, `monitor-sensor`)
## 6. Future Improvements

- Enable commit signing (GPG or SSH signing)
- Further harden SSH configuration
- Automate setup using scripts
- Periodically audit installed packages

### System & Hardware Enhancements

- Integrate rotation script safely into autostart with delay handling
- Add logging to the rotation script for debugging and monitoring
- Generalize the script for reuse across different devices
- Evaluate Wayland compatibility for improved input handling
- Explore udev or systemd-based alternatives for event-driven input handling