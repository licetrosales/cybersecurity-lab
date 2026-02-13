# External Enumeration Lab – Nmap Basic Scan

## 1. Executive Overview

This assessment demonstrates foundational external reconnaissance techniques using Nmap against an authorized testing target. The objective was to identify publicly exposed TCP services and evaluate how different scan configurations impact information discovery and reporting output.

The engagement focused strictly on enumeration activities. No exploitation was performed.

---

## 2. Scope & Authorization
- **Target:** `scanme.nmap.org`
- **Assessment Type:** Black-box test external reconnaissance
- **Authorization:** Publicly permitted by the Nmap project
- **Testing Phase:** Enumeration

---

## 3. Objective

Identify externally exposed TCP services and analyze how scan configurations influence visibility, detail level, and reporting structure.

---

## 4. Methodology

The following phased approach was used:

1. Baseline port discovery
2. TCP Connect scan
3. Service/version detection
4. Verbose output analysis
5. Export scan results for documentation

This methodology mirrors the reconnaissance phase of a structured penetration test.

---

## 5. Technical Execution

### 5.1 Baseline Scan

```bash
nmap scanme.nmap.org
```

Purpose:  
Establish a baseline view of open TCP ports using default Nmap behavior.

Observation:  
Nmap identified publicly accessible services using its default scan configuration.

Impact:  
Defines the initial external attack surface.

---

### 5.2 TCP Connect + Version Detection

```bash
nmap -sT -sV scanme.nmap.org
```

Parameters:
- `-sT` → Performs a full TCP three-way handshake (TCP Connect scan)
- `-sV` → Enables service and version detection

Purpose:  
Gather detailed information about running services.

Observation:  
Service version information was disclosed for identified open ports.

Impact:  
Version detection enables vulnerability research and targeted attack planning.

---

### 5.3 Verbose Mode

```bash
nmap -sT -sV -v scanme.nmap.org
```

Parameter:
- `-v` → Enables verbose output

Purpose:  
Provide more detailed runtime feedback during scanning.

Impact:  
Improves visibility into scan progress and enhances analysis capability.

---

### 5.4 Export Results to XML

```bash
nmap -v -oX Nmap-XMLReport scanme.nmap.org
```

Parameters:
- `-oX` → Outputs results in XML format
- `Nmap-XMLReport` → Output file name

Purpose:  
Generate structured output for documentation and automation.

To view the file:

```bash
more Nmap-XMLReport
```

Impact:  
XML output can be integrated into vulnerability management platforms and professional reporting workflows.

---

## 6. Findings

| Port | Service | Exposure | Risk Consideration |
|------|---------|----------|-------------------|
| 22   | SSH     | Publicly accessible | Potential brute-force target |
| 80   | HTTP    | Publicly accessible | Web attack surface |

---

## 7. Security Considerations

- Publicly exposed SSH services increase brute-force and credential-stuffing risk.
- Service version disclosure may assist attackers in vulnerability mapping.
- Proper firewall segmentation reduces unnecessary exposure.
- Structured scan output improves incident documentation and audit readiness.

---

## 8. Lessons Learned

- Default scans provide limited detail.
- Service/version detection significantly enhances reconnaissance.
- Output formatting is critical for professional reporting.
- Enumeration is a foundational phase before exploitation.

---


