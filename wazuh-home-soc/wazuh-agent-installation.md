# Wazuh Agent Installation and Enrollment

## Overview

This document describes the installation, enrollment, and validation of Wazuh agents across multiple operating systems within the Home SOC lab environment.

The monitored endpoints include:

* Windows 11
* macOS
* Debian Linux
* Raspberry Pi OS

The goal of the deployment is to provide centralized endpoint visibility and security event monitoring through the Wazuh SIEM platform.

---

# Agent Naming Convention

To maintain consistency across monitored assets, the following hostname convention is used:

```text
<os>-<role>-<id>
```

Examples:

| Hostname     | Description              |
| ------------ | ------------------------ |
| win-cli-01   | Windows workstation      |
| mac-cli-01   | macOS workstation        |
| linux-cli-01 | Debian Linux endpoint    |
| raspi-cli-01 | Raspberry Pi sensor node |

This naming standard simplifies:

* asset identification,
* dashboard visibility,
* alert correlation,
* endpoint management.

---

# Wazuh Manager Information

| Component                | Value         |
| ------------------------ | ------------- |
| Wazuh Manager Address    | `192.168.X.X` |
| Agent Communication Port | `1514/tcp`    |
| Enrollment Port          | `1515/tcp`    |

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

* Launch the `.msi` installer
* Accept the license agreement
* Complete the installation wizard

---

## 3. Register the Agent

Navigate to the installation directory:

```powershell
cd "C:\Program Files (x86)\ossec-agent"
```

Register the endpoint with the Wazuh manager:

```powershell
.\agent-auth.exe -m 192.168.X.X -A win-cli-01
```

Expected output:

```text
INFO: Valid key received
```

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

Expected output:

```text
Status   Name        DisplayName
------   ----        -----------
Running  WazuhSvc    Wazuh
```

---

## 5. Validate Connectivity

Verify network connectivity to the manager:

```powershell
Test-NetConnection 192.168.X.X -Port 1514
```

Expected result:

```text
TcpTestSucceeded : True
```

---

## 6. Verify Agent Registration

Check the generated client key:

```powershell
Get-Content "C:\Program Files (x86)\ossec-agent\client.keys"
```

Example output:

```text
001 win-cli-01 any <redacted_key>
```

---

## 7. Verify Logs

Inspect the agent log:

```powershell
Get-Content "C:\Program Files (x86)\ossec-agent\logs\ossec.log" -Tail 20
```

Expected result:

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

Edit the agent configuration:

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

Register the endpoint with the manager:

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

Expected output:

```text
wazuh-agentd is running...
```

---

## 6. Validate Connectivity

Verify connectivity to the manager:

```bash
nc -zv 192.168.X.X 1514
nc -zv 192.168.X.X 1515
```

Expected result:

```text
succeeded!
```

---

## 7. Verify Dashboard Registration

After successful enrollment:

* Endpoint visible in the Wazuh dashboard
* Agent status displayed as `Active`
* Logs successfully forwarded to the SIEM

---

# Common Troubleshooting

## Service Does Not Start

### Possible Causes

* Agent not registered
* Missing client key
* Incorrect manager IP
* Existing OSSEC installation conflict

### Resolution

Re-register the agent:

```powershell
.\agent-auth.exe -m 192.168.X.X -A win-cli-01
```

Restart the service:

```powershell
Restart-Service WazuhSvc
```

---

## Duplicate Agent Name

### Error

```text
Duplicate agent name
```

### Cause

An existing agent record already exists in the manager database.

### Resolution

Remove the old agent entry from the manager:

```bash
docker exec -it single-node-wazuh.manager-1 /var/ossec/bin/manage_agents
```

Re-register the endpoint using the standardized naming convention.

---

## Connectivity Issues

Verify manager connectivity:

### Windows

```powershell
Test-NetConnection 192.168.X.X -Port 1514
```

### macOS / Linux

```bash
nc -zv 192.168.X.X 1514
```

---

## WSL2 Networking Considerations

The Wazuh manager runs inside Docker containers hosted within Ubuntu on WSL2.

Because WSL2 uses virtual networking and NAT, endpoints must communicate using the Windows host IP address rather than the internal WSL2 IP.

Expected behavior:

```text
Windows Host → WSL2 → Docker → Wazuh Manager
```

---

# Operational Validation

After onboarding, the environment successfully reported:

* Active endpoint agents
* Multi-platform log collection
* Authentication events
* File integrity monitoring events
* System log visibility

The Wazuh dashboard confirmed all connected agents as operational.

---

# Lessons Learned

Key operational observations during endpoint onboarding:

* Consistent naming improves SIEM visibility and asset management
* Manual enrollment may be required in some environments
* WSL2 networking affects endpoint communication paths
* Connectivity validation simplifies troubleshooting
* Structured onboarding improves deployment reliability

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

* Windows agent operational
* macOS agent operational
* Linux endpoint monitoring active
* Dashboard visibility confirmed
* Endpoint log forwarding functional
