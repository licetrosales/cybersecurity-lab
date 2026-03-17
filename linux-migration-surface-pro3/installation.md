# Installation Documentation

## Linux Migration – Surface Pro 3

---

## 1. Objective

Install Debian 13 (XFCE) on a Surface Pro 3, replacing the existing system and establishing a stable Linux environment.

---

## 2. Preparation

* Downloaded Debian 13 XFCE ISO
* Created bootable USB using Rufus

  * Mode: ISO Image Mode (recommended)
* Verified boot capability via UEFI

---

## 3. Boot and Installation

* Booted from USB device
* Selected **Graphical Install**
* Proceeded with standard Debian installer steps:

  * Language, region, keyboard configuration
  * User and password creation
  * Hostname assignment

---

## 4. Disk Partitioning

* Selected: **Erase disk**
* Automatic partitioning used
* Result:

  * Root filesystem created
  * EFI partition created automatically

> Note: Manual partitioning was considered for separate data partition but not implemented in this installation.

---

## 5. Bootloader Installation

* GRUB bootloader installed automatically to EFI partition
* No manual configuration performed during installation

### Observed Issue

* Initial boot dropped into GRUB command line (`grub>`)

### Investigation

* Verified available partitions using:

  ```
  ls
  ls (hd1,gpt1)
  ls (hd1,gpt2)
  ```
* Confirmed presence of Linux filesystem

### Resolution

* No manual GRUB repair required
* Issue resolved after multiple system reboots
* System booted normally afterward

> Conclusion: Likely transient boot/UEFI detection issue

---

## 6. First Boot

* System successfully booted into Debian XFCE
* User login functional
* Network initially not configured

---

## 7. Network Configuration

* Connected to WiFi using system network manager
* Retrieved WiFi credentials via router interface (FRITZ!Box)

---

## 8. Display Scaling Configuration

Due to high DPI display (Surface Pro 3), default scaling was insufficient.

### XFCE Adjustments

* Display scaling: adjusted via settings
* DPI set to: **160**
* Window manager font increased (approx. 12pt)
* Panel size increased (approx. 36–38 px)

---

## 9. Login Screen (LightDM) Scaling Fix

### Issue

* Login screen text too small

### Solution

Edited LightDM greeter configuration:

```
sudo nano /etc/lightdm/lightdm-gtk-greeter.conf
```

Added:

```
[greeter]
xft-dpi=160
xft-antialias=true
xft-hintstyle=hintfull
```

### Result

* Improved readability on login screen
* Consistent scaling with desktop environment

---

## 10. System Update

> (Optional: Can be moved to hardening phase depending on documentation strategy)

```
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
```

---

## 11. Theming and Usability Enhancements

* Theme: **Arc-Dark**
* Icons: **Papirus-Dark**
* Cursor theme: **Breeze Light**
* Cursor size: **38**

---

## 12. Bluetooth Configuration

### Objective

Enable Bluetooth functionality for external devices (e.g., mouse).

### Installation
```bash
sudo apt install bluetooth bluez blueman
```

### Service Configuration

Enabled and started the Bluetooth service:

```bash
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
```

### Device Pairing

* Opened **Bluetooth Manager (Blueman)**
* Scanned for available devices
* Connected to **Surface Mobile Mouse**

### Observations

* Device paired successfully and works reliably
* Warning message observed during setup:

```
Failed to get power levels, probably a LE device
```

* No functional impact
* Common for low-energy Bluetooth devices

### Result

Bluetooth functionality is operational and ready for use with external input devices.

---

## 13. Touchscreen Keyboard Configuration

### Objective

Enable on-screen keyboard for touchscreen-only usage (tablet mode).

### Installation
```bash
sudo apt install onboard
```

### Configuration

* Enabled **auto-show when editing text**
* Enabled **show always on visible workspace**
* Docking to screen edge was tested but **not used in final configuration**
* Selected layout: **Compact**
* Keyboard size adjusted via **manual resizing**

### Observations

* Keyboard functions correctly
* Automatic display works when interacting with input fields
* Manual resizing provides better usability than docking in this setup
* Limited advanced scaling options available in XFCE environment

### Decision

Onboard retained as a **baseline solution**:

* Stable and functional
* Sufficient for occasional touchscreen input
* Not fully optimized for high-DPI touchscreen usage
* Alternative keyboards identified for future evaluation


## 14. Observations

* EFI warning observed during boot:

  ```
  EFI stub: WARNING: Failed to measure data for event 1
  ```

  * No functional impact
  * System booted normally

---

## 15. Baseline Configuration (Post-Installation State)

The following represents the stable baseline after installation:

* OS: Debian 13 (XFCE)
* Boot: GRUB (EFI)
* Display scaling configured (DPI 160)
* Network: WiFi configured
* Bluetooth: configured (mouse connected)
* Touchscreen: functional with Onboard keyboard
* Theme: Arc-Dark + Papirus-Dark
* Cursor: Breeze Light (size 38)
* System updated to latest packages

This baseline serves as the reference state for further hardening and configuration.

---

## 16. Status

Installation phase completed successfully.

Next phase:
→ System hardening and security configuration
