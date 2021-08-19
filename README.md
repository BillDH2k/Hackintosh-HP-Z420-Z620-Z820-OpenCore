# Hackintosh-HP-Z420-620-820-OpenCore
**(still under construction)**. 

This is my OC 0.7.1 setup for HP Z420/620/820 workstations. All patching are done either via OC hot-patching or SSDT add-on's, so custom patching/loading of DSDT is not required (true OC way). Thus this loader can be used for all three HP models. For post-install, you may need to generate your own CPU specific SSDT to enable full CPU Power Management (See below for detail). Of course, you will need to generate your own SMBIOS/Serial #.

**My systems:**

- Z820/Z620/Z420 (BIOS 3.96), Xeon 2760 V1, 2650 V2, or 2680 V2 (Single or Dual)
- SSD SATA drive or NvMe SSD on PCI-E adapter
- GTX 680 or Radeon 290/390X graphics (Both are supported out of the box by macOS)
  
**Opencore/macOS:**

- OC 0.7.1
- Catalina 10.15.7 - Everything works, except Sleep. Audio via AppleALC. USB3 at full speed, for storage device.
- Big Sur 11.5.1 - Same as Catalina, except USB3 (storage device not mounting, but mouse/keyboard device works)

**Credits:**

- Dortania's OpenCore Install Guide ([Here](https://dortania.github.io/OpenCore-Install-Guide/))
- bilbo's "Z820 - High Sierra, the Great Guide" ([here](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)), and many of the follow-up contributions in the same forum.

**What I have done:**

- Hot-patching of the IRQs conflicts: TMR(0), PIC(2), RTC0(8). Previously, this was done with a patched DSDT (bilbo's method). Without this fix, the on-board audio will not work. With this hot-patching fix, audio can be enabled through SSDT, and custom DSDT is not required. The OC loader is no longer tied to a static machine/bios configuration, thus more compatible.
- Verified the single kernal patch required for Apple CPU Power Management (Catalina/Big Sur), at least for this HP setup.
	
**Included in this EFI folder:**

- OC 0.7.1 base files (debug version)
- ACPI folder:
	- SSDT-EC.aml		For	Embedded Controller, manually created, Opencore Guide
	- SSDT-HPET.aml		IRQ patching. Created with SDDTTime, Opencore Guide.
	- SSDT-HDEF.aml		(Realtek)
	
	
My journey started with bilbo's guide, as newbie two months ago. Even though the guide was written for Clover/High Sierra, many of the patching can be transferred to newer macOS setup. Apart from helpful insights, one key point I leant from bilbo's guide is to gain an understanding of the important ACPI fixes required for this HP system, though his collection of patches used to create the final DSDT. Inspired by this guide, many have attempted and reported back with success for Catalina (using Clover) and couple of couple of succes in the above forum finWith fully patched DSDT, success were reported in the above forum for Catalina (fully working) with Clover, as well as Big Sur (missing USB3).  Though many of the fixes, such as sytax errors, are handled by Opencore automatically now, I gained a good understanding of what the key ACPI patches are for this HP system, such as missing audio and IRQ conflict fix. This helped me finally created this OC loader. People inspired by the guide had reported some success with Catalina/Big Sur (visit who followed bilbo's guide had reported success, with additional tweeking, on Catalina, using Clover. One user (A couple of success with Opencore (in the forum, to obtain full working setup's either with Clover or OpenCore. They were all required to load a fully patched DSDT. Otherwise, ob-board audio will not work. 