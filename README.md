# Hackintosh-HP-Z420-620-820-OpenCore
**OpenCore 0.7.1 Loader for HP Z420/620/820 (still under construction)**. 

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

- [Dortania's OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/)
- bilbo's "Z820 - High Sierra, the Great Guide" ([here](https://www.insanelymac.com/forum/topic/335860-guide-2018-z820-high-sierra-the-great-guide-sucess/)), and many of the follow-up contributions in the same forum (especially to: antonio.clb & amadeusex, for their success examples with newer macOS).
- **What I have done:**
	- Succeeded in hot-patching the IRQs conflicts. This has finally allow me to move the Realtek Audio patching to SSDT. DSDT patching, as was done in bilbo's guide, is no longer needed, resulting in more compatible loader not tied to a static machine/bios configuration.
	- Singled down the only kernal patch required for Apple CPU Power Management for Catalina/Big Sur (at least for this HP machine).
	
My journey started with bilbo's great guide. Even though it was written for Clover/High Sierra and no longer directly applies to newer macOS, but many of the patching can be transferred to newer setup. The key knowledge I leant from bilbo's guide is his collection of patches required for this HP machine and the method to generate the final DSDT for Clover to load. It allowed me to gain a good understanding of what the key patches are. People had reported success in the forum, to obtain full working setup's either with Clover or OpenCore. They were all required to load a fully patched DSDT. Otherwise, ob-board audio will not work. 