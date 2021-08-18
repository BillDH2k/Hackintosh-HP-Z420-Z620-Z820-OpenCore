# Hackintosh-HP-Z420-620-820-OpenCore
**OpenCore 0.7.1 Loader for HP Z420/620/820**. 

This is my OC setup for HP Z420/620/820 workstations. All patching's are done either via OC hot-patching or SSDT add-on's, so no custom patching of a full DSDT is required. Thus this loader can be used for any said HP units. For post-install, you may need to generate your own CPU specific SSDT to enable full CPU Power Management (See below for detail). Of course, you've also need to generate your own SMBIOS/Serial #.

**My systems:**

- Z820/Z620/Z420 (BIOS 3.96), Xeon 2760 V1, 2650 V2, or 2680 V2, single or dual
- SSD SATA drive or NvMe SSD on PCI-E adapter
- GTX 680 or Radeon 290/390X graphics (Both are supported out of the box by macOS)
  
**Opencore/macOS:**

- OC 0.7.1
- Catalina 10.15.7 - Everything works, except Sleep. Audio via AppleALC. USB3 at full speed, for storage device.
- Big Sur 11.5.1 - Same as Catalina, except USB3 is not functional (attaching mouse/keyboard works, however.)

**Credits:**

- bilbo's "Z820 - High Sierra, the Great Guide" ([here] (https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)), and many of the follow-up contributions in the same forum (especially to: antonio.clb, amadeusex).
- **What I have done:**
	- Succeeded in hot-patching the IRQs conflicts. This has finally enabled me to move all key patchings in DSDT (as were done in bilbo's guide) to SSDT, resulting in a loader not tied to a static machine/bios configuration.
	- Nailed now the single kernal patch required for Apple CPU Power Management to work.
	
	
** More to come **