# Troubleshooting
This document centralizes troubleshooting cases encountered during the Home SOC Lab deployment, upgrade, and endpoint onboarding process.

Each case follows the same structure:

- Issue
- Symptoms
- Cause
- Resolution
- Validation
- Lesson learned

---

## Networking Issues

### Agent Cannot Reach Wazuh Manager

#### Issue

An endpoint could not communicate with the Wazuh manager.

#### Symptoms

The agent did not appear as active in the dashboard.

Connectivity tests failed:

```bash
nc -zv 192.168.X.X 1514
```
or on Windows:
```bash
Test-NetConnection 192.168.X.X -Port 1514
```
#### Cause

The Wazuh manager runs inside Docker containers hosted on Ubuntu through WSL2.
Because WSL2 uses virtual networking and NAT, external endpoints must connect to the Windows host LAN IP address, not the internal WSL2 IP address.

#### Resolution

Use the Windows host IP address as the Wazuh manager address:
```text
192.168.X.X
```
Confirm that the required ports are reachable:
```text
1514/tcp - Agent communication
1515/tcp - Agent enrollment
```
#### Validation

Run a connectivity test from the endpoint:
```text
nc -zv 192.168.X.X 1514
nc -zv 192.168.X.X 1515
```
Expected result:
```text
succeeded!
```
#### Lesson Learned

In WSL2-based deployments, understanding the difference between the Windows host IP and the internal WSL2 IP is critical for endpoint connectivity.

---

## Agent Enrollment Issues
### Duplicate Agent Name

#### Issue

During agent enrollment, the Wazuh manager rejected the registration because an agent with the same name already existed.

#### Symptoms

```text
Duplicate agent name
```
#### Cause

The endpoint had previously been registered in the Wazuh manager database.
Because Wazuh does not allow duplicate agent names, the new enrollment attempt failed.

#### Resolution

Remove the existing agent entry from the Wazuh manager:
```bash
docker exec -it single-node-wazuh.manager-1 /var/ossec/bin/manage_agents
```
Then re-register the endpoint using the standardized naming convention:
```bash
sudo /var/ossec/bin/agent-auth -m 192.168.X.X -A linux-cli-01
```
Restart the agent service:
```bash
sudo systemctl restart wazuh-agent
```
#### Validation

Verify that the agent appears as active in the Wazuh dashboard.

#### Lesson Learned

Standardized endpoint naming improves asset management, but old agent records must be removed before re-enrollment.

---
## Agent Service Does Not Start

### Issue

The Wazuh agent service failed to start after installation or re-enrollment.

### Symptoms

```text
wazuh-agent.service failed
```
or:
```text
wazuh-agentd is not running
```
#### Cause

Possible causes included:

- the agent was not registered,
- the client key was missing,
- the manager address was incorrect,
- an old OSSEC/Wazuh installation conflicted with the new setup.

#### Resolution

Check the agent configuration:
```bash
sudo nano /var/ossec/etc/ossec.conf
```
Verify the manager address:
```XML
<client>
  <server>
    <address>192.168.X.X</address>
    <port>1514</port>
    <protocol>tcp</protocol>
  </server>
</client>
```
Re-register the agent:
```bash
sudo /var/ossec/bin/agent-auth -m 192.168.X.X -A linux-cli-01
```
Restart the service:
```bash 
sudo systemctl restart wazuh-agent
```
#### Validation

Check service status:
```bash
sudo systemctl status wazuh-agent
```

Expected result:
```text
active (running)
```
#### Lesson Learned

Agent startup problems are often related to registration or configuration issues, so checking the client key and manager address should be part of the first troubleshooting steps.

---


## Version Compatibility Issues
## Certificate and SSL Issues
## Dashboard and Indexer Issues
## Service and Startup Issues
## Naming and Asset Management Issues

## Docker CLI Not Recognized After WSL Shutdown

### Issue

After running:

```powershell
wsl --shutdown
```

the Docker CLI was no longer recognized in PowerShell:

```text
docker : The term 'docker' is not recognized...
```

### Root Cause

The Docker CLI binary path was missing from the Windows system PATH environment variable.

Docker Desktop was installed and running correctly, but PowerShell could not locate `docker.exe`.

### Resolution

Added the Docker CLI binary directory to the system PATH permanently:

```powershell
$dockerPath = "C:\Program Files\Docker\Docker\resources\bin"

[Environment]::SetEnvironmentVariable(
  "Path",
  [Environment]::GetEnvironmentVariable("Path", "Machine") + ";$dockerPath",
  "Machine"
)
```

### Verification

```powershell
docker --version
```

or

```powershell
where.exe docker
```

### Result

Docker CLI functionality restored successfully after reopening PowerShell.
