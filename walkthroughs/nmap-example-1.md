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
### Step 2: TCP Connect + Service Version Detection

```bash
nmap -sT -sV scanme.nmap.org
```

- `-sT`: TCP Connect scan (full 3-way handshake)
- `-sV`: Service/version detection

---
### Step 3: Verbose Output

```bash
nmap -sT -sV -v scanme.nmap.org
```

- `-v`: Enable verbose mode for detailed output

---### Step 4: Export Results to XML

```bash
nmap -v -oX Nmap-XMLReport scanme.nmap.org
```

- `-v`: Verbose scan output
- `-oX`: Output to XML format
- `Nmap-XMLReport`: File name for the saved output

To view the saved output:

```bash
more Nmap-XMLReport
```

---
## Summary of Commands

| Task                           | Command                                                |
|--------------------------------|--------------------------------------------------------|
| Basic scan                     | `nmap scanme.nmap.org`                                 |
| TCP connect + service scan     | `nmap -sT -sV scanme.nmap.org`                         |
| Verbose mode                   | `nmap -sT -sV -v scanme.nmap.org`                      |
| Output scan to XML             | `nmap -v -oX Nmap-XMLReport scanme.nmap.org`          |
| View XML output                | `more Nmap-XMLReport`                                  |

---