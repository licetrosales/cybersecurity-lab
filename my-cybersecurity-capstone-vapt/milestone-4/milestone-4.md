# Milestone 4 – Forensics, Report & Presentation Prep

## 1. Overview
This milestone focuses on performing forensic analysis of a suspicious disk image using Autopsy. Tasks included verifying file integrity with hashing, importing and analyzing the forensic image in Autopsy, identifying hidden images with suspicious file types, examining extension mismatches, and exporting digital evidence. The findings provide insight into potential data concealment tactics and improper file labeling.

## 2. Test Environment Setup 

Component             | Details                                             |
|----------------------|-----------------------------------------------------|
| Forensic Workstation | Kali Linux (Username: kali, Password: kali)        |
| Evidence Source      | 8-jpeg-search.dd (forensic image)                  |
| Tool Used            | Autopsy v2.24 (Digital Forensics Platform)         |

### Tools Used
- `md5sum` (hashing via terminal)
- Autopsy (forensic GUI analysis)
- File Manager (image location/export)
  
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

![Figure 1](../assets/md5sum-hash-8-jpeg-search.png)
**Figure 1:** Terminal showing the `md5sum` command and hash saved.


---

### 3.2 Autopsy Case Setup

**Objective:** Create a new case in Autopsy, verify hash, and prepare for forensic examination.

**Steps Taken:**
1. Launch Autopsy and create a new case.
2. Importe the `JPEG_Test_Host.dd` image.
3. Verify the MD5 hash in Autopsy matches the pre-calculated one.

**Results:**
- Case setup was successful.
- Autopsy confirmed the image hash matches: `deb20836198d94dafdfd921f8e15c7cc`

![Figure 2](../assets/autopsy-case-host-image-setup.png)
**Figure 2:** Autopsy interface showing case creation.

![Figure 3](../assets/autopsy-hash-validation.png)
**Figure:3** Hash verification screen in Autopsy.

---
Identify Suspicious Files – Extension Mismatches

**Objective:** Detect files with misleading extensions.

**Steps Taken:**
- Navigated to the "Extension Mismatch" category in Autopsy.
- Cross-referenced MIME types, metadata, and file previews.
- Verified file type by checking content signature and metadata.

**Results:**
Seven files were flagged. Six were confirmed JPEGs with incorrect extensions. One was a text file mislabeled as a JPG. Two deleted files were fully recovered and verified.

**Figure 4:** Metadata and MIME mismatch for file2.dat

---


