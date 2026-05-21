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
## Agent Enrollment Issues
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
