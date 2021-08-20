# Hackintosh-HP-Z420-620-820-OpenCore
**(still under construction)**. 

This is my OC 0.7.1 setup for HP Z420/620/820 workstations. Works for Catalina (10.15.7, everthing works, except Sleep Mode) and Big Sur (11.5.1, Sleep/USB3 not working). 

All patching are done either via OC hot-patching or SSDT add-on's, so custom patching/loading of DSDT is not required (true OC way). Thus this loader can be used for all three HP models. For post-install, you may need to generate your own CPU specific SSDT to enable full CPU Power Management (Read below). Of course, you will also need to generate your own SMBIOS MacPro6,1/Serial #.

**My systems:**

- Z820/Z620/Z420 (BIOS 3.96), Xeon 2760 V1, 2650 V2, or 2680 V2 (Single or Dual)
- SSD SATA drive or NvMe SSD on PCI-E adapter (need a Sata HD installed for hosting EFI loader)
- GTX 680 or Radeon 290/390X graphics (Both are supported out of the box by macOS)
  
**Opencore/macOS:**

- OC 0.7.1
- Catalina 10.15.7 - Everything works, except Sleep. Audio via AppleALC. USB3 at full speed, for storage device.
- Big Sur 11.5.1 - Same as Catalina, except USB3 ports (storage device not mounting, but mouse/keyboard device works)

**Credits:**

- Dortania's OpenCore Install Guide ([Here](https://dortania.github.io/OpenCore-Install-Guide/))
- bilbo's "Z820 - High Sierra, the Great Guide" ([here](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)), and many of the follow-up contributions in the same forum. This was where my journey started two months ago! Learnt a lot from it.

**What I have done:**

- Hot-patching of the IRQs conflicts: TMR(0), PIC(2), RTC0(8). Previously, this fix was done with a fully patched DSDT (as shown in bilbo's guide). With this hot-patching, audio can be properly enabled via SSDT, and custom DSDT is no longer required, resulting in a loader not tied to a static machine/bios configuration, thus more compatible for all machine models and setups.
- Verified the two kernal patches for Apple CPU Power Management (Catalina/Big Sur), at least for this HP setup.

**How I did it?**

I stated from a clean OC 0.7.1, followed though OC Guide for High End Desktop. Then, added additional kext and SSDT's. Configured config.plist to include additional ACPI and kernal patchings, explained below. 

**Included in this EFI folder:**

- OC 0.7.1 base files (debug version)
- ACPI folder:
	- SSDT-EC.aml		- for Embedded Controller, manually created, via OC Guide
	- SSDT-HPET.aml		- IRQ patching. Created with SDDTTimes, via OC Guide. It also creates TMR(0) hot-patching fix. For this HP unit, I added patching PIC(2) and RTC0(8). 
	- SSDT-HDEF.aml		- for Realtek ALC262 audio injection (imported from bilbo's guide)
	- SSDT-IMEI.aml		- for IMEI, via OC Guide
	- SSDT-UIAC-ALL.aml	- USB2 port mapping (borrowed from bilbo's guide)
	- SSDT-CPUPM.aml	- CpuPM SDDT for proper CPU power management. Replace it (copied over) with one of the following  
	
	(The following are CPU specific SSDTs for proper CPU power management. Without them, macOS will still run but without loader - rename the matching file to SSDT-CPU.aml)
	- SSDT-2670.aml		- E5-2670 CPU file, created with ssdtPRGen (bilbo's guide and the same forum have good examples)
	- SSDT-2650V2.aml	- E5-2650v2 CPU, ...
	- SSDT-2680V2.aml	- E5-2680v2 CPU, ...
	- SSDT-1620v2.aml	- E5-1620v2 CPU
	
- Kexts folder:
	- Lilu.kext
	- WhateverGreen.kext
	- AppleMCEReporterDisabler.kext
	- VirtualSMC.kext
	- NVMeFix.kext						- NvMe driver (BIOS does not support direct booting. Need a Sata HD in the system to install OC)
	- AstekFusion2Family.kext			- SAS controller (Z820 only. Can be removed if not needed)
	- AstekFusion2Adapter.kext			- SAS controller (Z820 only. Can be removed if not needed)
	- AppleIntelE1000e.kext				- Intel LAN (supports two ports)
	- mXHCD.kext						- Old USB3 driver, works for TI-chip under Catalina. Not fully working for Big Sur.
	- USBInjectAll.kext					- Still needed?
	- VoodooTSCSync.kext
	- AppleALC.kext						- Audio driver
	
- ACPI Hot-Patching (config.plist - ROOT->ACPI->Patch)
	- "HPE _CRS to XCRS Rename"			- Part of the HPET IRQ fix from OC Guide
	- "TMR IRQ 0 Fix"					- Fix TMR (0) IRQ
	- "PIC IRQ 2 Fix"					- Fix PCI(2) IRQ
	- "RTC0 IRQ 8 Fix"					- Fix RTC0(8) IRQ
	- "EUSB to EH01 Rename"				- USB rename. Also required for USBInjectAll
	- "USBE to EH02 Rename"				- USB rename. Also required for USBInjectAll

- Kernal patches (config.plist - ROOT->Kernal->Patch)
	- "Apple CPU Power Management Patch #7"		- "3E7538" -> "3E9090"
	- "Apple CPU Power Management Patch #8"		- "7511B9" -> "EB11B9"
	
**BIOS Setup**

Enable UEFI boot, set SATA to AHCI mode, Disable Vt-d, and enable "Legacy ACPI Tables". You can visit bilbo's guide for additional information. In particularly,  with examples for ssdtPRGen 