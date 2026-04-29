# Wazuh Agent Installation and Enrollment 
## 1 Windows Agent 
The first endpoint agent was installed on a Windows 11 client system.

Agent Information

* **Agent name:** `win-client-01`
* **Wazuh Manager address:** `192.168.X.X` *(replace with your internal IP range or leave masked)*

---
## 1.1 Download and Install the Agent

Download the Wazuh agent installer:

```powershell
Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.7.0-1.msi -OutFile "$env:TEMP\wazuh-agent.msi"
```

Install the agent silently:

```powershell
msiexec.exe /i "$env:TEMP\wazuh-agent.msi" /qn
```

### Alternative (GUI installation)

* Run the `.msi` installer manually
* Accept the license agreement
* Click **Install**
* Finish setup

---

### Verification

Check installation directory:

```powershell
Test-Path "C:\Program Files (x86)\ossec-agent"
```

Expected result:

```text
True
```
---

## 1.2 Agent Registration
### Agent Authentication Note

If the agent is not automatically registered during installation,
use `agent-auth.exe` to manually enroll the agent.

This step ensures the agent receives a valid authentication key
from the Wazuh manager before starting the service.

Navigate to the agent installation directory:

```powershell
cd "C:\Program Files (x86)\ossec-agent"
```

Register the agent with the Wazuh manager:

```powershell
.\agent-auth.exe -m 192.168.X.X -A win-client-01
```

**Expected output:**

```text
INFO: Valid key received
```

---

## 1.3 Start the Agent Service
### If service is stopped:
```powershell
Start-Service WazuhSvc
```
### If it fails:
```powershell
Get-Service WazuhSvc
```

**Expected result:**

```text
Status   Name        DisplayName
------   ----        -----------
Running  WazuhSvc    Wazuh
```
### Note:
In some cases, the service does not start automatically after installation.
Manual start may be required.

---

## 1.4 Connectivity Validation

Verify network connectivity to the manager:

```powershell
Test-NetConnection 192.168.X.X -Port 1514
```

**Expected result:**

```text
TcpTestSucceeded : True
```

---

## 1.5 Agent Key Verification

```powershell
Get-Content "C:\Program Files (x86)\ossec-agent\client.keys"
```

**Expected output:**

```text
001 win-client-01 any <redacted_key>
```

---
### Common Issue

Service does not start

Cause:
- Agent not registered (missing key)
- Previous OSSEC installation conflict
- Service installed but not initialized

Fix:
- Run agent-auth.exe manually
- Verify client.keys exists
- Restart service

### Configuration Note

The agent will not connect if the manager IP is incorrect.

Verify the configuration file:

C:\Program Files (x86)\ossec-agent\ossec.conf

Example:

<address>192.168.X.X</address>

## 1.6 Log Verification
```powershell
Get-Content "C:\Program Files (x86)\ossec-agent\logs\ossec.log" -Tail 20
```
Expected:
```
Connected to manager
```
---

## 1.7 Dashboard Verification

In the Wazuh web interface:

* Total agents: `1`
* Active agents: `1`
* Disconnected agents: `0`

---
# ## 2 macOS Agent (MacBook)

The second endpoint agent was installed on a macOS client system (MacBook).

---

## 2.1 Agent Information

- **Agent name:** `mac-cli-01`
- **Wazuh Manager address:** `192.168.XX.XX`

---

## 2.2 Download and Install the Agent

Download the macOS agent package:

```bash
curl -O https://packages.wazuh.com/4.x/macos/wazuh-agent-4.7.0-1.pkg
```
Install the package:
```bash
sudo installer -pkg wazuh-agent-4.7.0-1.pkg -target /
```
---

## 2.3 Configure Manager

Edit the agent configuration file:
```bash
sudo nano /Library/Ossec/etc/ossec.conf
```
Update the manager address:
```
<client>
  <server>
    <address>192.168.XX.XX</address>
    <port>1514</port>
    <protocol>tcp</protocol>
  </server>
</client>
```
## 2.4 Agent Registration (Manual Enrollment)

Register the agent with the Wazuh manager:
```bash
sudo /Library/Ossec/bin/agent-auth -m 192.168.XX.XX -A mac-cli-01
```
Expected output:
```
INFO: Valid key received
```
## 2.5 Start and Verify Agent

Start the agent:
```bash
sudo /Library/Ossec/bin/wazuh-control start
```
Check status:
```bash
sudo /Library/Ossec/bin/wazuh-control status
```
Expected:
```
wazuh-agentd is running...
```
## 2.6 Connectivity Verification

Verify connectivity from macOS to the manager:
```bash
nc -zv 192.168.XX.XX 1514
nc -zv 192.168.XX.XX 1515
```
Expected:
```
succeeded!
```
## 2.7 Dashboard Verification

In Wazuh Dashboard:

* Total agents: `2`
* Active agents: `2`
* Status: `Active`

---

### Naming Convention 

```
<os>-<role>-<device-id>
```

Examples:

* `win-cli-01`
* `linux-server-01`
* `raspi-sensor-01`
* `mac-cli-01`

## Next Steps

* Add agents (macOS, Linux)
* Trigger test alerts
* Integrate n8n for automation
* Implement alert-based workflows

---
