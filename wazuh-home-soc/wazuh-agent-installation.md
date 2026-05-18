# Wazuh Agent Installation and Enrollment

## Overview

This document describes the installation, enrollment, and validation of Wazuh agents across multiple operating systems within the Home SOC lab environment.

The environment was intentionally designed as a heterogeneous endpoint lab to simulate real-world SOC visibility across multiple operating systems.

Monitored endpoints include:

* Windows 11
* macOS
* Debian Linux
* Raspberry Pi OS

The objective of the deployment is to provide centralized endpoint monitoring, log collection, and security event visibility through the Wazuh SIEM platform.

---

# Agent Naming Convention

To maintain consistency across monitored assets, the following hostname convention is used:

```text
<os>-<role>-<id>
```

Examples:

| Hostname     | Description                  |
| ------------ | ---------------------------- |
| win-cli-01   | Windows workstation          |
| mac-cli-01   | macOS workstation            |
| linux-cli-01 | Debian Linux endpoint        |
| raspi-cli-01 | Raspberry Pi monitoring node |

This naming convention improves:

* asset management,
* dashboard readability,
* alert correlation,
* endpoint identification.

---

# Wazuh Manager Information

| Component                | Value         |
| ------------------------ | ------------- |
| Wazuh Manager Address    | `192.168.X.X` |
| Agent Communication Port | `1514/tcp`    |
| Agent Enrollment Port    | `1515/tcp`    |

---

# Windows Agent Deployment

## 1. Download the Agent

Download the official Wazuh Windows agent installer:

```powershell
Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.14.5-1.msi -OutFile "$env:TEMP\wazuh-agent.msi"
```

---

## 2. Install the Agent

Silent installation:

```powershell
msiexec.exe /i "$env:TEMP\wazuh-agent.msi" /qn
```

Alternative GUI installation:

* Launch the installer manually
* Accept the license agreement
* Complete the installation wizard

---

## 3. Register the Agent

Navigate to the installation directory:

```powershell
cd "C:\Program Files (x86)\ossec-agent"
```

Register the endpoint with the manager:

```powershell
.\agent-auth.exe -m 192.168.X.X -A win-cli-01
```

Expected output:

```text
INFO: Valid key received
```
The lab uses manual agent enrollment via `agent-auth` to better understand Wazuh agent registration workflows during learning and troubleshooting exercises.

---

## 4. Start the Agent Service

Start the Wazuh service:

```powershell
Start-Service WazuhSvc
```

Verify service status:

```powershell
Get-Service WazuhSvc
```

Expected result:

```text
Status   Name        DisplayName
------   ----        -----------
Running  WazuhSvc    Wazuh
```

---

## 5. Validate Connectivity

Verify connectivity to the manager:

```powershell
Test-NetConnection 192.168.X.X -Port 1514
```

Expected result:

```text
TcpTestSucceeded : True
```

---

## 6. Verify Logs

Inspect the agent log:

```powershell
Get-Content "C:\Program Files (x86)\ossec-agent\logs\ossec.log" -Tail 20
```

Expected output:

```text
Connected to manager
```

---

# macOS Agent Deployment

## 1. Download the Agent

Download the macOS package:

```bash
curl -O https://packages.wazuh.com/4.x/macos/wazuh-agent-4.14.5-1.pkg
```

---

## 2. Install the Agent

Install the package:

```bash
sudo installer -pkg wazuh-agent-4.14.5-1.pkg -target /
```

---

## 3. Configure the Manager Address

Edit the configuration file:

```bash
sudo nano /Library/Ossec/etc/ossec.conf
```

Update the manager section:

```xml
<client>
  <server>
    <address>192.168.X.X</address>
    <port>1514</port>
    <protocol>tcp</protocol>
  </server>
</client>
```

---

## 4. Register the Agent

Register the endpoint:

```bash
sudo /Library/Ossec/bin/agent-auth -m 192.168.X.X -A mac-cli-01
```

Expected result:

```text
INFO: Valid key received
```

---

## 5. Start the Agent

Start the Wazuh agent:

```bash
sudo /Library/Ossec/bin/wazuh-control start
```

Verify status:

```bash
sudo /Library/Ossec/bin/wazuh-control status
```

Expected result:

```text
wazuh-agentd is running...
```

---

## 6. Validate Connectivity

Verify manager connectivity:

```bash
nc -zv 192.168.X.X 1514
nc -zv 192.168.X.X 1515
```

Expected result:

```text
succeeded!
```

---

# Debian Linux Agent Deployment

## 1. Install Required Packages

Update the system:

```bash
sudo apt update && sudo apt upgrade -y
```

Install dependencies:

```bash
sudo apt install curl apt-transport-https lsb-release gnupg2 -y
```

---

## 2. Add the Wazuh Repository

Import the GPG key:

```bash
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -
```

Add the repository:

```bash
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list
```

Update package lists:

```bash
sudo apt update
```

---

## 3. Install the Agent

Install the Wazuh agent:

```bash
sudo apt install wazuh-agent -y
```

---

## 4. Configure the Manager Address

Edit the configuration file:

```bash
sudo nano /var/ossec/etc/ossec.conf
```

Update the manager section:

```xml
<client>
  <server>
    <address>192.168.X.X</address>
    <port>1514</port>
    <protocol>tcp</protocol>
  </server>
</client>
```

---

## 5. Register the Agent

Register the endpoint:

```bash
sudo /var/ossec/bin/agent-auth -m 192.168.X.X -A linux-cli-01
```

Expected result:

```text
INFO: Valid key received
```

---

## 6. Start the Agent

Enable and start the service:

```bash
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

Verify status:

```bash
sudo systemctl status wazuh-agent
```

Expected result:

```text
active (running)
```

---

# Raspberry Pi Agent Deployment

## Overview

The Raspberry Pi node was deployed as a lightweight monitoring and sensor system running Raspberry Pi OS.

The endpoint forwards logs and security events to the centralized Wazuh manager.

---

## 1. Update the System

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. Install the Wazuh Agent

Install required packages:

```bash
sudo apt install curl gnupg2 apt-transport-https -y
```

Import the Wazuh repository key:

```bash
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo apt-key add -
```

Add the repository:

```bash
echo "deb https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list
```

Install the agent:

```bash
sudo apt update
sudo apt install wazuh-agent -y
```

---

## 3. Configure the Agent

Edit the configuration file:

```bash
sudo nano /var/ossec/etc/ossec.conf
```

Update the manager section:

```xml
<client>
  <server>
    <address>192.168.X.X</address>
    <port>1514</port>
    <protocol>tcp</protocol>
  </server>
</client>
```

---

## 4. Register the Agent

Register the Raspberry Pi endpoint:

```bash
sudo /var/ossec/bin/agent-auth -m 192.168.X.X -A raspi-cli-01
```

---

## 5. Start the Agent

Enable and start the service:

```bash
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

Verify status:

```bash
sudo systemctl status wazuh-agent
```

---

# Common Troubleshooting

## Service Does Not Start

### Possible Causes

* Agent not registered
* Missing client key
* Incorrect manager address
* Existing OSSEC installation conflict

### Resolution

Re-register the endpoint and restart the service.

---

## Duplicate Agent Name

### Error

```text
Duplicate agent name
```

### Cause

An existing agent entry already exists in the Wazuh manager database.

### Resolution

Remove the previous agent record:

```bash
docker exec -it single-node-wazuh.manager-1 /var/ossec/bin/manage_agents
```

Re-register the endpoint using the standardized naming convention.

---

## Connectivity Issues

Verify connectivity to the manager.

### Windows

```powershell
Test-NetConnection 192.168.X.X -Port 1514
```

### Linux / macOS

```bash
nc -zv 192.168.X.X 1514
```

---

## WSL2 Networking Considerations

The Wazuh manager runs inside Docker containers hosted within Ubuntu on WSL2.

Because WSL2 uses virtual networking and NAT, endpoints must communicate using the Windows host IP address rather than the internal WSL2 IP address.

Expected architecture:

```text
Windows Host → WSL2 → Docker → Wazuh Manager
```

---

# Operational Validation

After onboarding, the environment successfully reported:

* Active endpoint agents
* Centralized log forwarding
* Authentication events
* File integrity monitoring events
* Linux audit events
* Windows security events

Dashboard validation confirmed all monitored endpoints as operational.

---

# Lessons Learned

Key operational observations during endpoint onboarding:

* Standardized naming improves SIEM asset management
* Connectivity validation simplifies troubleshooting
* WSL2 networking impacts endpoint communication paths
* Multi-platform monitoring increases environment realism
* Structured onboarding improves operational consistency

---

# Technologies Used

* Wazuh Agents
* Windows 11
* macOS
* Debian Linux
* Raspberry Pi OS
* Docker
* WSL2

---

# Status

* Windows endpoint operational
* macOS endpoint operational
* Debian Linux endpoint operational
* Raspberry Pi monitoring active
* Multi-platform log forwarding functional
* Dashboard visibility confirmed

