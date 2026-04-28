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

```powershell
Start-Service WazuhSvc
Get-Service WazuhSvc
```

**Expected result:**

```text
Status   Name        DisplayName
------   ----        -----------
Running  WazuhSvc    Wazuh
```

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
- Wrong manager IP in ossec.conf

Fix:
- Update <address> field
- Restart service

### Configuration Note

The agent will not connect if the manager IP is incorrect.

Verify the configuration file:

C:\Program Files (x86)\ossec-agent\ossec.conf

Example:

<address>192.168.X.X</address>
----

## 1.6 Dashboard Verification

In the Wazuh web interface:

* Total agents: `1`
* Active agents: `1`
* Disconnected agents: `0`

---

### Naming Convention (Recommended)

```
<os>-<role>-<device-id>
```

Examples:

* `win-client-01`
* `linux-server-01`
* `raspi-sensor-01`
* `mac-client-01`

## Next Steps

* Add agents (macOS, Linux)
* Trigger test alerts
* Integrate n8n for automation
* Implement alert-based workflows

---
