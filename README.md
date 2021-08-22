# Hackintosh-HP-Z420-620-820-OpenCore

This is my OC 0.7.1 setup for HP Z420/620/820 workstations. It supports all three HP models. Tested for latest Catalina and Big Sur.

Catalina 10.15.7 - Everthing works, except Sleep mode and some minor issue with USB3. USB3 at full speed for attached storage device. Other USB3 attaching perepherals, however, is a hit-and-miss.

Big Sur 11.5.1 - Similar to Catalina, but USB3 is practically non-funcional. You would need to add a compatible USB3 card.

**Post-install:** 

1. Update the Serial #. The one in this EFI folder is anonymous #, for install only. DO NOT USE it with your Apple ID!
2. For full CPU power management, replace "SSDT-CPUPM.aml" (in ACPI folder) with one matching your CPU model. I have provided a few from my systems. Simply overwrite "SSDT-CPUPM.aml" file with an appropriate one. If you have a different CPU from mine, you need to run **ssdtPRGen** ([link](https://github.com/Piker-Alpha/ssdtPRGen.sh)) to create a new SSDT file (check out bilbo's "Z820 - High Sierra, the Great Guide" ([here](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)), an excellent resource for Z820 hacking). If you have mismatched CPU, you might experience booting issue. In this case, simply disable SSDT-CPUPM.aml. macOs will run just fine, without full CPU management. Once up running, you can generate a correct SSDT specific to your CPU. 

**My systems:**

- Z820/Z620/Z420 (BIOS 3.96)
- Processors: 1620 v2, 2760 v1, 2650 v2, 2680 v2 (Single or Dual)
- SSD SATA drive or NvMe SSD on a PCI-E adapter (NvMe: SATA HD is needed to host OC loader)
- GTX 680 or Radeon 290/390X (Both are supported out of the box)
  
**Credits:**

- bilbo's "Z820 - High Sierra, the Great Guide" ([here](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)). Also many of the follow-up posts in the same forum. My build wouldn't possible without these guy's work.
- Dortania's OpenCore Install Guide ([Here](https://dortania.github.io/OpenCore-Install-Guide/))

**What I did differently (not claiming to be the 1st):**

- Hot-patching of the IRQs conflicts: TMR(0), PIC(2), RTC0(8). 
- This patch is necessary for on-board audio to work with AppleALC. With this hot fix, all key patches can be done with SSDTs, resulting in a more flexable OC loader. 


**Included in this EFI folder:**

- **OC 0.7.1** base files (debug version)
- **ACPI folder:**
	- SSDT-EC.aml		- For Embedded Controller, via OC Guide
	- SSDT-HPET.aml		- IRQ patching. Created with SDDTTimes, via OC Guide.
	- SSDT-HDEF.aml		- for Realtek ALC262 audio injection (Imported from bilbo's DSDT patch)
	- SSDT-IMEI.aml		- for IMEI (imported from bilbo's DSDT patch)
	- SDDT-OTHERS.aml	- Misc items placed in here: "SMBus" fix via OC Guide. 
	- SSDT-UIAC-ALL.aml	- USB2 port mapping for HP ZX20's (from bilbo's guide)
	
	- SSDT-CPUPM.aml	- Custom CPU SSDT for proper CPU power management. Replace this file with one that matches your CPU model (I have included a few models below). You need to create a new one if your CPU is different. bilbo's guide also has good coverage on this topic, including special instructions for 26X3 & 26X7 CPU variants.

	The following are a few CPU SSDTs I created for my systems: 
	- SSDT-2670.aml		- E5-2670 CPU, Single or Dual
	- SSDT-2650V2.aml	- E5-2650v2 CPU, ...
	- SSDT-2680V2.aml	- E5-2680v2 CPU, ...
	- SSDT-1620v2.aml	- E5-1620v2 CPU

	
- **Kexts folder:**
	- Lilu.kext
	- WhateverGreen.kext
	- AppleMCEReporterDisabler.kext
	- VirtualSMC.kext
	- NVMeFix.kext	
	- AstekFusion2Family.kext			- Z820 SAS controller
	- AstekFusion2Adapter.kext			- Z820 SAS controller
	- AppleIntelE1000e.kext				- Intel LANs (supports two ports)
	- mXHCD.kext						- Old USB3 driver, works for TI-chip with Catalina (mostly), not with Big Sur.
	- USBInjectAll.kext
	- VoodooTSCSync.kext
	- AppleALC.kext
	
- ACPI Hot-Patching (config.plist - ROOT->ACPI->Patch)
	- "HPE _CRS to XCRS Rename"			- Part of the HPET IRQ fix, from OC Guide
	- "TMR IRQ 0 Fix"					- Fix TMR (0) IRQ
	- "PIC IRQ 2 Fix"					- Fix PCI(2) IRQ
	- "RTC0 IRQ 8 Fix"					- Fix RTC0(8) IRQ
	- "EUSB to EH01 Rename"				- USB rename
	- "USBE to EH02 Rename"				- USB rename

- Kernal patches (config.plist - ROOT->Kernal->Patch)
	- "Apple CPU Power Management Patch #7"		- "3E7538" -> "3E9090"
	- "Apple CPU Power Management Patch #8"		- "7511B9" -> "EB11B9"
	
	
**BIOS Setup**

Enable UEFI boot, set SATA to AHCI mode, Disable Vt-d, and enable "Legacy ACPI Tables".


Goodluck!

