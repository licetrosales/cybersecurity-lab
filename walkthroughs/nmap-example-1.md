# Nmap Network Scans and Configurations

This walkthroughs demonstrates foundational Nmap scanning techniques on the authorized testing domain `scanme.nmap.org`. The goal is to identify public-facing services using different Nmap scan types and output formats.

---
# 1. Obtain Permission

**Target:** `scanme.nmap.org`  
This domain is maintained by the Nmap project and explicitly allows scanning for educational purposes. [Read the terms here](https://nmap.org/).

---
## 2. Plan the Scan

- **Objective:** Identify public-facing services that could be used in an intrusion attempt
- **Target:** `scanme.nmap.org`
- **Scope:** Black-box test – no internal knowledge or credentials
- **Scan Techniques Used:**
  - **TCP Connect Scan**: Detects open TCP ports (`-sT`)
  - **Service/Version Detection**: Identifies services and their versions (`-sV`)

---
## 3. Implementation Steps & Commands

### Step 1: Basic (Unconfigured) Scan

```bash
nmap scanme.nmap.org
```

Performs a default scan with no additional options.

---
