# Release 2.2 - Hackintosh-HP-Z420-Z620-Z820-OpenCore (0.7.8)
(4/19/2022) V2.2

**1. Added support for three more CPUs models: 2643 V2, 2667 V2, 2687w V2**. 

These CPUs require special patched CpuDef table, by removing unused/out-of-order CPU definitions that cause Kernal panic during booting (KP: # of threads, but (#+1) registered from MADT ...). I have finally figured out how to properly patch them, used in conjunction with enabling "Drop Oem CpuDef". If you have one of these CPUs, use one of the provided config_xxx.plist files and rename it as config.plist.

**2. Updated all CPUPM files**: with full dual CPU supports.

**3. LAN driver default to IntelMausi.kext**. Dual port driver (AppleIntelE1000e.kext) may cause NVME booting issue in some configuration.

**Pre/Post-install**:

Please read the "Pre/Post-Install" instruction on the release note 1.0  below.  


# Release 2.1 - Hackintosh-HP-Z420-Z620-Z820-OpenCore (0.7.8)
(3/25/2022) V2.1

Added boot-chime (boot sound). Updated USBInjectAll.kext to support MacPro7,1 SYMBIOS (fixed USB ports disappearing issue), but MacPro6,1 still appears to be the optimal SYMBIOS for this platform (better CPU Power management). Removed TSC kext since it is no longer needed for this platform.

(3/4/2022) V2.0

For Z420/620/820 systems with Ivy-Bridge CPUs (V2 Xeons on motherboards with BIOS Boot Block date 2013), Big Sur and Monterey supported. Systems with V1 Xeons (BIOS Boot Block date 2011) should stay at 0.7.1. unless OC booting issues can be resolved (read below)

Finally took the effort to upgrade the OC to 0.7.8. Due to Secure Boot feature added, I was unable to boot up OC 0.7.2 and higher, for systems with Sandy-Bridge CPUs (i.e. V1 32nm Xeons, BIOS Boot Block date 2011). Either the Picker does not show up , or no macOS partitions show up. There is no issue, however, with systems that running Ivy-Bridge CPUs (V2 22nm Xeons, BIOS Boot Block date 2013).

**Monterey 12.2.1** - Can be upraded from Big Sur (tested on 11.6) or fresh installs. Same functionality as the Big Sur. Apart from upgrading to latest OC and kext's, I had to disable VoodooTSCSync.text since it causes kernal panic during booting (same result with CpuTSCSync.kext). I did not notice any performance hit without TSCSync (Geekbench 5 showed the same scores as the Big Sur with TSCSync). If you are upgrading to Monterey from Big Sur, make sure you disable VoodooTSCSync before rebooting.

**Big Sur 11.6** - Everything works, except Sleep mode and the on-board USB3 port (TI-chip not supported).

**Catalina 11.5.7** - Use my release 1.0 file (below) with OC 0.7.1.



# Release 1.0 - Hackintosh-HP-Z420-Z620-Z820-OpenCore (0.7.1)
(8/24/2021)

This is my OC 0.7.1 setup for HP Z420/620/820 workstations. It supports all three HP models. Tested for latest Catalina and Big Sur.

**Catalina 10.15.7** - Everthing works, except Sleep mode and some minor issue with USB3. On-board audio with AppleALC, full CPU Power Management. USB3 at full speed for attached storage device. Other USB3 attaching perepherals, however, is a hit-or-miss (leaving device connected during booting may help).

**Big Sur 11.5.2 (Update: 9/2/2021)**- Similar to Catalina, but USB3 ports is practically non-funcional. Also, CPU Power Management is not working with Sandy-Bridge CPUs (V1 version of Xeons). In this case, you need to disable loading SSDT_CPUPM.aml, until new pacthes are available. There is no issue, however, for Ivy-Bridge CPUs (V2 version of Xeons). In fact, my testing showed no patching is needed for Apple CPU Power Management (Kernal patch #7 & #8 below are not required). Leaving the two patches in config.plist does not appear to do any harm under Big Sur. So you could remove them, or leave in there if you want dual booting Catalina. For USB3 replacement, you could add a PCI-E card with internal 20-pin header, such as ones based on VLI chip with built-in macOS support (pletty on eBay for ~$13).

**Pre/Post-install:** 

Pre-Install: You must add your own Serial # & Board Info. I have removed the anonymous # for safety reason.

Post-Install: For full CPU power management, replace "SSDT-CPUPM.aml" (in ACPI folder) with one matching your CPU model. I have provided a few from my systems. Simply overwrite "SSDT-CPUPM.aml" file with an appropriate one. If you have a different CPU from mine, you need to run **ssdtPRGen** ([link](https://github.com/Piker-Alpha/ssdtPRGen.sh)) to create a new SSDT file (bilbo's "Z820 - High Sierra, the Great Guide" ([here](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)), an excellent resource for Z820 hacking). If you have a mismatched CPU (sometimes SSDT generated from another system won't work), you might experience booting issue (such as "Memory Error" KP). In this case, simply disable SSDT-CPUPM.aml from config.plist. macOs will run just fine, without CPU power management. Once up running, you can generate a correct SSDT specific for your CPU. 

**My systems:**

- Z820/Z620/Z420 (BIOS 3.96)
- Processors: 1620 v2, 2760 v1, 2650 v2, 2680 v2 (Single or Dual)
- SSD SATA drive or NvMe SSD on a PCI-E adapter (NvMe: SATA HD is needed to host OC loader)
- GTX 680 or Radeon 290/390X (Both are supported out of the box)
  
**Credits:**

- bilbo's "Z820 - High Sierra, the Great Guide" ([here](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)). Also many of the follow-up posts in the same forum. My build wouldn't possible without these guy's work.
- Dortania's OpenCore Install Guide ([Here](https://dortania.github.io/OpenCore-Install-Guide/))

**What I did differently:**

- Hot-patching of the IRQs conflicts: TMR(0), PIC(2), RTC0(8). 
- This patch is necessary for on-board audio to work with AppleALC. With this hot fix, all key patches can be done with SSDTs, resulting in a more flexable OC loader. 


**Included in this EFI folder:**

- **OC 0.7.1** base files (debug version)
- **ACPI folder:**
	- SSDT-EC.aml		- For Embedded Controller, via OC Guide
	- SSDT-HPET.aml		- IRQ patching. Created with SDDTTimes, via OC Guide.
	- SSDT-HDEF.aml		- for Realtek ALC262 audio injection (Imported from bilbo's DSDT patch)
	- SSDT-IMEI.aml		- for IMEI (imported from bilbo's DSDT patch)
	- SSDT-OTHERS.aml	- Misc items placed in here: "SMBus" fix via OC Guide. 
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
	- mXHCD.kext					- Old USB3 driver, works for TI-chip with Catalina (mostly), not with Big Sur.
	- USBInjectAll.kext
	- VoodooTSCSync.kext
	- AppleALC.kext
	
- ACPI Hot-Patching (config.plist - ROOT->ACPI->Patch)
	- "HPE _CRS to XCRS Rename"			- Part of the HPET IRQ fix, from OC Guide
	- "TMR IRQ 0 Fix"					- Fix TMR (0) IRQ
	- "PIC IRQ 2 Fix"					- Fix PIC(2) IRQ
	- "RTC0 IRQ 8 Fix"					- Fix RTC0(8) IRQ
	- "EUSB to EH01 Rename"				- USB rename
	- "USBE to EH02 Rename"				- USB rename

- Kernal patches (config.plist - ROOT->Kernal->Patch)
	- "Apple CPU Power Management Patch #7"		- "3E7538" -> "3E9090"
	- "Apple CPU Power Management Patch #8"		- "7511B9" -> "EB11B9"
	
	
**BIOS Setup**

Enable UEFI boot, set SATA to AHCI mode, Disable Vt-d, and enable "Legacy ACPI Tables".


Goodluck!
