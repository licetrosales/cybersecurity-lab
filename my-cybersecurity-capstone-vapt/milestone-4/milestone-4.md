# Milestone 4 – Forensics, Report & Presentation Prep

## 1. Overview
This milestone focuses on performing forensic analysis of a suspicious disk image using Autopsy. Tasks included verifying file integrity with hashing, importing and analyzing the forensic image in Autopsy, identifying hidden images with suspicious file types, examining extension mismatches, and exporting digital evidence. The findings provide insight into potential data concealment tactics and improper file labeling.

## 2. Environment Setup and Tools

- **Forensic Workstation:** Kali Linux
- **Tool Used:** Autopsy (Digital Forensics Platform)
- **Evidence Source:** 8-jpeg-search.dd forensic image

---

## 3. Evidence Collection and Analysis

### 3.1 Hashing & Integrity Check

**Objective:** Generate and store an MD5 hash of the forensic image to verify data integrity throughout the investigation.

**Steps Taken:**
1. Generated MD5 hash using `md5sum`:
   ```bash
   md5sum JPEG_Test_Host.dd > image_hash.txt
   ```
2. Saved hash output in the `Hashes/` directory.

**Results:**
- MD5 hash: `deb20836198d94dafdfd921f8e15c7cc`

**Screenshot to include:**
- Terminal showing the `md5sum` command and hash saved.

---
