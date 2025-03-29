# OpenCore EFI for HP Z420-Z620-Z820 (0.9.7)

**(2/12/2024) Release 3.4**

- Added Sonona/Ventura support.

# About this EFI

**1. macOS support**

- **Catalina/Big Sur/Monterey:**
	- Native support (Recommended. Recommend release V3.3 EFI for Monterey or below)
	
- **Ventura/Sonoma:**
	- Root patching with OCLP is required to enable graphic hardware acceleration. Check [OCLP page](https://github.com/dortania/OpenCore-Legacy-Patcher "GitHub - dortania/OpenCore-Legacy-Patcher") for other limitations. 
	- Please follow the **step-by-step instruction** below.
#

**2. Supported Hardware**

- HP Z420/Z620/Z820 (BIOS 3.96, all motherboard revisions)
- CPUs: E5-1600/2600 V1 Xeon's (Sandy-Bridge) or V2 Xeon's (Ivy-Bridge)
- Required BIOS Settings: Enable UEFI boot, set SATA to AHCI mode, Disable Vt-d, and enable "Legacy ACPI Tables".

# 

**3. What Works**:

- CPU Power Management (all processor models)
- On-board Audio (Front/Back Jacks, internal speaker)
- USB2 ports, Ethernet, On-Board SAS (Z820 only)
- USB3 (Catalina only)

**What Not Work**:

- Sleep/Wake (Must disable from macOS, System Preference->Energy Saver->Prevent computer from sleeping)
- USB3 ports not working under Big Sur or higher (no driver support).
- **Z820 DUAL CPU Boot Issue (Sonoma/Ventura):** random lockup defore reaching desktop. Solution: stay with Monterey. No issue with single CPU. **Z620 DUAL CPU**, however, works fine, except it may occationally experience lockup during booting. Reboot again normally works. Recommend to remove 2nd CPU card temporarily during Sonoma/Ventura install.

#

# 4. EFI Folder

**4.1 EFI with OC 0.9.7**:

- Support Catalina - Sonoma (14.3.1 tested).
- SUMBIOS: MacPro7,1 (default) or iMacPro1,1. MacPro6,1 is supported up to Monterey.

**4.2 Choose the Correct config.plist**:

- For Sandy-bridge CPUs (V1 Xeon's), use **config_SandyCPUs.plist** (rename it to config.plist).
- For Ivy-bridge CPUs (V2 Xeon's), use **config_IvyCPUs.plist** (rename it to config.plist).
- If you have 2643V2, 2667V2, or 2687w V2 CPUs, use the corresponding customized c**onfig_26XXV2.plist**.
- Choose the correct CPU PM file that matches your CPU (e.g. SSDT_2650V2.aml, for 2650V2 CPU):
	- You may either overwrite SSDT_CPUPM.aml file with your matching PM file, or
	- Modify config.list (ACPI->Add section) to pick the right CPU PM file
	- If your CPU is not listed, ~~try SSDT_CPUPM.am (default, currently as 2670V1),~~ disable use of any PM file. Once install is completed, generate your own (see Post-Install), for optimal power management.

**4.3 For Catalina/Big Sur/Monterey:**

- Just use the renamed config.plist, with the correct CPU PM file.

**4.4 For Sonoma/Ventura:**

- Follow **Sonoma/Ventura step-by-step instruction** below.

#

**5. Other Installation Note:**

- Network LAN driver choice: For Z420 (Single LAN port), use **IntelMausi.kext**. For Z620/Z820 (Dual LAN ports), use **AppleIntelE1000e.kext**. Otherwise, you might experience random system lock up, especially true if NvMe SSD (via PCI-E adapter) is used.
- Currently AppleIntelE1000e.kext is enabled by default in the config.list.

#

# 6. Pre/Post-Install

- You must generate and add your own Serial # & Board ID to config.plist

- For full CPU power management, replace "SSDT-CPUPM.aml" (in ACPI folder) with one matching your CPU model. I have provided a few in the ACPI folder. Simply overwrite "SSDT-CPUPM.aml" with an appropriate file. If you have a different CPU not listed, you need to run **ssdtPRGen** ([link](https://github.com/Piker-Alpha/ssdtPRGen.sh)) to create a new SSDT file. Additional instruction can be found here: bilbo's "Z820 - High Sierra, the Great Guide" (step #29) ([link](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)). If you have a mismatched CPU, you might experience booting issue. In this case, simply disable SSDT-CPUPM.aml from config.plist. macOs will run without CPU power management. Once up running, you can generate a correct SSDT file specific to your CPU.



# 7. Sonoma/Ventura step-by-step instruction

The steps outlined below were tailored from the excellent [instruction guide](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Ivy_Bridge.md) written by [5T33Z0](https://github.com/5T33Z0).

**Step 1.** Pick the correct config.plist templatye (section 4.2 above)

- Use the correct CPU PM file.
- Verify that this EFI works with your current Monterey/Big Sur setup (if you have one installed), with full CPU power management (use Intel Power Gadget tool).

	
**Step 2.** Modify the boot-args (to disable the video card hardware acceleration)

- boot-args:  config.plist->Root->NVRAM->7C436110-AB2A-4BBB-A880-FE41995C9F82->boot-args
- Add the following flags to the boot-args:
	- "-amd_no_dgpu_accel" &nbsp;&nbsp;&nbsp;&nbsp; if you have an AMD/Radeon card
	- “nv_disable=1” &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if you have an nVidia Kepler card
- optional:
	- "revpatch=sbvmm" &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for Sonoma 14.3 only. Not needed for 14.2, or 14.3.1 (my own testing). Otherwise, you may encounter "Software Update Error” after 1st reboot. If you encounter this error, just do a restart (or reboot) and the install should complete succesfully, except that the boot partition would end up as “Sonoma - Data” (you could rename it later).

**Step 3.** Install Sonoma/ventura (latest version recommended)

- Reboot with the modified boot-args from Step 2. Make sure to perform a NVRAM reset (Important! **Note:** at OC boot screen, hit SPACE BAR to show NVRAM RESET option)
- Start Sonoma/Ventura installation:
	 - by booting from an USB installer stick (my recommendation), or
	 - for updating from existing Ventura/Sonoma, directly from a downloaded full installer copied to the Application folder.
- Once Sonoma is installed successfully, proceed to Step 4.

**Step 4:** Apply OCLP patcher (to enable graphics card acceleration).

- Modify config.plist again:
	- csr-active-config to 03080000
	- Add “amfi=0x80” to boot-args
- Reboot. Perform NVRAM reset (Important). Reboot again.
- Download the latest OCLP patcher ([OpenCore-Patcher-GUI.app](https://github.com/dortania/OpenCore-Legacy-Patcher/releases "GitHub - dortania/OpenCore-Legacy-Patcher/releases") )
- Launch the OCLP patcher and choose “Post-Install Root Patch”.

**Step 5:** Post OCLP change

- If OCLP root patching is successful (Step 4), remove the following boot-args, if they were added from the previous steps:
	- "-amd_no_dgpu_accel"
	- "nv_disable=1"
	- "amfi=0x80"
	- "revpatch=sbvmm"
- Leave csr-active-config as 03080000
- Reboot. Perform NVRAM reset. Reboot again.

**Note:**

- If you properly followed the steps above, the final EFI should be able to boot exisitng Big-Sur, Monterey, and Ventura/Sonoma

#

**Credits:**

- bilbo's "Z820 - High Sierra, the Great Guide" ([here](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)). Also many of the follow-up posts in the same forum. My build wouldn't possible without these guy's work.
- Dortania's OpenCore Install Guide ([Here](https://dortania.github.io/OpenCore-Install-Guide/))
- "Installing macOS Ventura or newer on Ivy Bridge systems" ([Here](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Guides/Ivy_Bridge.md) )

# 

# ------------ Release History ------------
# Release 3.4 - Added Sonoma/Ventura support
(2/12/2023)


# Release 3.3 - Updated OC to 0.9.7
(2/8/2023)

** Updated OpenCore to 0.9.7
** Removed EFI 0.7.1 folder. Catalina is supported by the newer EFI 0.9.7.

# Release 3.2 - Updated OC to 0.9.5
(10/5/2023)

** Updated OpenCore to 0.9.5 

# Release 3.1 - Updated OC to 0.9.1
(4/29/2023)

** Updated OpenCore to 0.9.1 

# Release 3.0 - Updated OC to 0.8.4, and added CPU Power managment for V1 Xeon's 
(9/15/2022)

**Added support to enable full CPU Power Management for systems running Sandy-Bridge V1 Xeon CPUs**. 

- Newer kernel patches were available to patch the AICPUPM for Big Sur/Monterey to enable full CPU Power Management for Sandy-Bridge CPUs (Credit to the link [here](https://www.insanelymac.com/forum/topic/346988-sandy-bridge-e-power-management-big-sur-1121-big-sur-114/)). With these patches, the earlier revision of the HP systems (Bios Boot Block Date 2011) running V1 Xeon's can enjoy latest macOS, with full CPU Power management. Systems running V2 Xeon's do not require these patches.

- Two EFIs are provided: EFI with OC 0.8.4 and EFI with OC 0.7.1. Two versions of the config.plist files are provided: **config_IvyCPUs.plist** for systems running Ivy-Bridge CPUs, and **config_SandyCPUs.plist** for systems running Sandy-Bridge CPUs. Use the one matching your CPU and rename it as config.plist. 

- EFI (0.7.1) is used mainly for supporting Catalina. This EFI fully supports Catalina and Big Sur (install/update), but can only boot to an existing Monterey install. Fresh install or upgrade to Monterey with this EFI will fail (limitation of OC 0.7.1). You need to use the newer EFI (0.8.4) to accomplish this. If you must update from Catalina to Monterey directly, you must boot up a Monterey USB install stick to do this, using the newer EFI. 


# Release 2.2 - Hackintosh-HP-Z420-Z620-Z820-OpenCore (0.7.8)
(4/19/2022) V2.2

**1. Added support for three more CPUs models: 2643 V2, 2667 V2, 2687w V2**. These CPUs require special patched CpuDef table, by removing unused/out-of-order CPU definitions that cause Kernal panic during booting (KP: # of threads, but (#+1) registered from MADT ...). I have finally figured out how to properly patch them, used in conjunction with enabling "Drop Oem CpuDef".

If you have one of these CPUs, use one of the provided config_xxx.plist files and rename it as config.plist.

**2. Updated all CPUPM files**: with full dual CPU supports.

# Release 2.1 - Hackintosh-HP-Z420-Z620-Z820-OpenCore (0.7.8)
(3/25/2022) V2.1

Added boot-chime (boot sound). Updated USBInjectAll.kext to support MacPro7,1 SYMBIOS (fixed USB ports disappearing issue), but MacPro6,1 still appears to be the optimal SYMBIOS for this platform (better CPU Power management). Removed TSC kext since it is no longer needed for this platform.

(3/4/2022) V2.0

For Z420/620/820 systems with Ivy-Bridge CPUs (V2 Xeons on motherboards with BIOS Boot Block date 2013), Big Sur and Monterey supported. Systems with V1 Xeons (BIOS Boot Block date 2011) should stay at 0.7.1. unless OC booting issues can be resolved (read below). (**Update (9/15/2022)**: issue resolved with Release 3.0)

Finally took the effort to upgrade the OC to 0.7.8. Due to Secure Boot feature added, I was unable to boot up OC 0.7.2 and higher, for systems with Sandy-Bridge CPUs (i.e. V1 32nm Xeons, BIOS Boot Block date 2011). Either the Picker does not show up , or no macOS partitions show up. There is no issue, however, with systems that running Ivy-Bridge CPUs (V2 22nm Xeons, BIOS Boot Block date 2013).

**Monterey 12.2.1** - Can be upraded from Big Sur (tested on 11.6) or fresh installs. Same functionality as the Big Sur. Apart from upgrading to latest OC and kext's, I had to disable VoodooTSCSync.text since it causes kernal panic during booting (same result with CpuTSCSync.kext). I did not notice any performance hit without TSCSync (Geekbench 5 showed the same scores as the Big Sur with TSCSync). If you are upgrading to Monterey from Big Sur, make sure you disable VoodooTSCSync before rebooting.

**Big Sur 11.6** - Everything works, except Sleep mode and the on-board USB3 port (TI-chip not supported).

**Catalina 11.5.7** - Use my release 1.0 file (below) with OC 0.7.1.



# Release 1.0 - Hackintosh-HP-Z420-Z620-Z820-OpenCore (0.7.1)
(8/24/2021)

This is my OC 0.7.1 setup for HP Z420/620/820 workstations. It supports all three HP models. Tested for latest Catalina and Big Sur.

**Catalina 10.15.7** - Everthing works, except Sleep mode and some minor issue with USB3. On-board audio with AppleALC, full CPU Power Management. USB3 at full speed for attached storage device. Other USB3 attaching perepherals, however, is a hit-or-miss (leaving device connected during booting may help).

**Big Sur 11.5.2 (Update: 9/2/2021)**- Similar to Catalina, but USB3 ports is practically non-funcional. Also, CPU Power Management is not working with Sandy-Bridge CPUs (V1 version of Xeons). In this case, you need to disable loading SSDT_CPUPM.aml, until new pacthes are available. There is no issue, however, for Ivy-Bridge CPUs (V2 version of Xeons). In fact, my testing showed no patching is needed for Apple CPU Power Management (Kernal patch #7 & #8 below are not required). Leaving the two patches in config.plist does not appear to do any harm under Big Sur (suggestion: use version control to disable them for Big Sur or higher). So you could remove them, or leave in there if you want dual booting Catalina. For USB3 replacement, you could add a PCI-E card with internal 20-pin header, such as ones based on VLI chip with built-in macOS support (pletty on eBay for ~$13).

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
