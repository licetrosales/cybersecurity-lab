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
