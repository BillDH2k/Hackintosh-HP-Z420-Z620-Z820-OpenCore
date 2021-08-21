# Hackintosh-HP-Z420-620-820-OpenCore
**(still under construction)**. 

This is my OC 0.7.1 setup for HP Z420/620/820 workstations. Tested for Catalina (latest 10.15.7, everthing works, except Sleep Mode) and Big Sur (latest 11.5.1, except Sleep/USB3). 

This loader can be used for all three HP models. All fixes are done via hot-patching or SSDT's, thus no need for a patched DSDT, resulting in a more compatible loader. 

For **post-install:** enable full CPU power management, by enabling this CPU specific SSDT, "SSDT-CPUPM.aml", via config.plist (ACPI->Add section, find entry for SSDT-CPUPM.aml, change "Enabled" key value to "True"). You amy need to generate your own CPU SSDT if your CPU model is different from the ones I used (read more below). Of course, you will also need to generate your own SMBIOS MacPro6,1/Serial #.

**My systems:**

- Z820/Z620/Z420 (BIOS 3.96)
- Processors: 1620 V2, 2760 V1, 2650 V2, 2680 V2 (Single or Dual)
- SSD SATA drive or NvMe SSD on a PCI-E adapter (NvMe: SATA HD is needed to host OC loader)
- GTX 680 or Radeon 290/390X (Both are supported out of the box)
  
**Opencore/macOS:**

- OC 0.7.1
- Catalina 10.15.7 - Everything works, except Sleep. Audio via AppleALC. USB3 at full speed.
- Big Sur 11.5.1 - Same as above, except USB3 ports (storage device will not mount)

**Credits:**

- Dortania's OpenCore Install Guide ([Here](https://dortania.github.io/OpenCore-Install-Guide/))
- bilbo's "Z820 - High Sierra, the Great Guide" ([here](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)), and many of the follow-up contributions in the same forum. My build would be be possible without those guy's work.

**What I have done:**

- Hot-patching of the IRQs conflicts: TMR(0), PIC(2), RTC0(8). 
- Without this fix, on-board audio will not work with AppleALC. Finally, all key fixes can be done via SSDT, resulting in a loader not tied to a specific machine/BIOS/setup configuration. 


**How I did it?**

I started from a clean OC 0.7.1, followed though OC Guide for High End Desktop. Then, added additional kext and SSDT's, as well as ACPI and kernal patchings. The key content of my EFI folder is shown below. 

**Included in this EFI folder:**

- **OC 0.7.1** base files (debug version)
- **ACPI folder:**
	- SSDT-EC.aml		- For Embedded Controller, via OC Guide
	- SSDT-HPET.aml		- IRQ patching. Created with SDDTTimes, via OC Guide.
	- SSDT-HDEF.aml		- for Realtek ALC262 audio injection (Imported from bilbo's DSDT patch)
	- SSDT-IMEI.aml		- for IMEI (imported from bilbo's DSDT patch)
	- SDDT-OTHERS.aml	- Misc items placed in here: "SMBus" fix via OC Guide. 
	- SSDT-UIAC-ALL.aml	- USB2 port mapping (from bilbo's guide)
	
	- SSDT-CPUPM.aml	- Custom CPU SSDT for proper CPU power management, unique for each CPU model. Currently not enabled. So your initial install does not have full CPU PM. You can enable this SSDT via config.plist (ACPI->Add, find "SDDT-CPUPM.aml" entry, change "Enabled" key to "True"). Before enable it, replace this SSDT with one that matches your CPU. I have provided a few models below. If your CPU is different, you need to generate one, using ssdtPRGen (bilbo's [guide](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/) has good coverage on this, including special instructions for E5-26X7 variants CPUs).
	
	(The following are CPU PM SSDTs I created for my systems. You may use the one that matches your CPU to replace SSDT-CPUPM.aml above.)
	- SSDT-2670.aml		- E5-2670 CPU, Single or Dual
	- SSDT-2650V2.aml	- E5-2650v2 CPU, ...
	- SSDT-2680V2.aml	- E5-2680v2 CPU, ...
	- SSDT-1620v2.aml	- E5-1620v2 CPU
	
- **Kexts folder:**
	- Lilu.kext
	- WhateverGreen.kext
	- AppleMCEReporterDisabler.kext
	- VirtualSMC.kext
	- NVMeFix.kext						- NvMe driver (BIOS does not support direct booting. Need a Sata HD installed to host OC)
	- AstekFusion2Family.kext			- SAS controller (Z820 only. Can be removed if not needed)
	- AstekFusion2Adapter.kext			- SAS controller (Z820 only. Can be removed if not needed)
	- AppleIntelE1000e.kext				- Intel LANs (supports two ports)
	- mXHCD.kext						- Old USB3 driver, works for TI-chip under Catalina. Not fully working under Big Sur.
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

Enable UEFI boot, set SATA to AHCI mode, Disable Vt-d, and enable "Legacy ACPI Tables".


Goodluck!

