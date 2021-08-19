# Hackintosh-HP-Z420-620-820-OpenCore
**(still under construction)**. 

This is my OC 0.7.1 setup for HP Z420/620/820 workstations. Works for Catalina (10.15.7, everthing works, except Sleep) and Big Sur (11.5.1, similar to Catalina, except on-board USB3). 

All patching are done either via OC hot-patching or SSDT add-on's, so custom patching/loading of DSDT is not required (true OC way). Thus this loader can be used for all three HP models. For post-install, you may need to generate your own CPU specific SSDT to enable full CPU Power Management (See below for detail). Of course, you will also need to generate your own SMBIOS MacPro6,1/Serial #.

**My systems:**

- Z820/Z620/Z420 (BIOS 3.96), Xeon 2760 V1, 2650 V2, or 2680 V2 (Single or Dual)
- SSD SATA drive or NvMe SSD on PCI-E adapter (need a Sata HD installed for hosting EFI loader)
- GTX 680 or Radeon 290/390X graphics (Both are supported out of the box by macOS)
  
**Opencore/macOS:**

- OC 0.7.1
- Catalina 10.15.7 - Everything works, except Sleep. Audio via AppleALC. USB3 at full speed, for storage device.
- Big Sur 11.5.1 - Same as Catalina, except USB3 (storage device not mounting, but mouse/keyboard device works)

**Credits:**

- Dortania's OpenCore Install Guide ([Here](https://dortania.github.io/OpenCore-Install-Guide/))
- bilbo's "Z820 - High Sierra, the Great Guide" ([here](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)), and many of the follow-up contributions in the same forum.

**What I have done:**

- Hot-patching of the IRQs conflicts: TMR(0), PIC(2), RTC0(8). Previously, this was done with a patched DSDT (bilbo's method). Without this fix, the on-board audio will not work. Now with hot-patching, audio can be enabled through SSDT, and custom DSDT is no longer required. The OC loader is not tied to a static machine/bios configuration, thus more compatible.
- Verified the single kernal patch required for Apple CPU Power Management (Catalina/Big Sur), at least for this HP setup.

How I did it?

I stated from a clean OC 0.7.1, followed though OC Guide for High End Desktop. Then, added additional kext (copied from a working ) and SSDT's. Configured config.plist to include additional ACPI and kernal patchings, explained below. 

**Included in this EFI folder:**

- OC 0.7.1 base files (debug version)
- ACPI folder:
	- SSDT-EC.aml		- for Embedded Controller, manually created, via OC Guide
	- SSDT-HPET.aml		- IRQ patching. Created with SDDTTime, via OC Guide.
	- SSDT-HDEF.aml		- for Realtek ALC262 audio injection (imported from bilbo's guide)
	- SSDT-IMEI.aml		- for IMEI, via OC Guide
	- SSDT-UIAC-ALL.aml	- USB2 port mapping (from bilbo's guide)
	- SSDT-UNC.aml		- probably not needed, via OC Guide
	- SSDT-DTGP.aml		- required to enable custom device injection
	
	(CPU specific - rename the matching file to SSDT-CPU.aml)
	- SSDT-2670.aml		- E5-2670 CPU file, created with ssdtPRGen (see bilbo's guide)
	- SSDT-2650V2.aml	- E5-2650v2 CPU, ...
	- SSDT-2680V2.aml	- E5-2680v2 CPU, ...
	
- Kexts folder:
	- AppleALC.kext
	- AppleMCEReporterDisabler.kext
	- AstekFusion2Adapter.kext			SAS controller (Z820 only)
	- AstekFusion2Family.kext			SAS controller (Z820 only)
	- IntelMausi.kext					Ethernet LAN
	- Lilu.kext
	- mXHCD.kext						USB3 driver, works for TI-chip under Catalina
	- USBInjectAll.kext					Still needed?
	- VirtualSMC.kext
	- VoodooTSCSync.kext				Need to modify info.plist 
	- WhateverGreen.kext
	
- ACPI Hot-Patching (config.plist - ROOT->ACPI->Patch)
	- "HPE _CRS to XCRS Rename"			Part of the HPET IRQ fix
	- "TMR IRQ 0 Fix"
	- "PIC IRQ 2 Fix"
	- "RTC0 IRQ 8 Fix"
	- "EUSB to EH01 Rename"
	- "USBE to EH02 Rename"

- Kernal patches (config.plist - ROOT->)
	- "Apple CPU Power Management Patch #7"		Z420
	- "Apple CPU Power Management Patch #8"		Z620/820
	


My journey started with bilbo's guide, as newbie two months ago. Even though the guide was written for Clover/High Sierra, many of the patching can be transferred to newer macOS setup. Apart from helpful insights, one key point I leant from bilbo's guide is to gain an understanding of the important ACPI fixes required for this HP system, though his collection of patches used to create the final DSDT. Inspired by this guide, many have attempted and reported back with success for Catalina (using Clover) and couple of couple of succes in the above forum finWith fully patched DSDT, success were reported in the above forum for Catalina (fully working) with Clover, as well as Big Sur (missing USB3).  Though many of the fixes, such as sytax errors, are handled by Opencore automatically now, I gained a good understanding of what the key ACPI patches are for this HP system, such as missing audio and IRQ conflict fix. This helped me finally created this OC loader. People inspired by the guide had reported some success with Catalina/Big Sur (visit who followed bilbo's guide had reported success, with additional tweeking, on Catalina, using Clover. One user (A couple of success with Opencore (in the forum, to obtain full working setup's either with Clover or OpenCore. They were all required to load a fully patched DSDT. Otherwise, ob-board audio will not work. 