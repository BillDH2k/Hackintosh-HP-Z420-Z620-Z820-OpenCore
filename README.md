# Hackintosh-HP-Z420-620-820-OpenCore
OpenCore 0.7.1 loader for HP Z420/620/820. 

This is my OC setup for HP Z420/620/820 workstations. All patching are done either via OC hot-patching or SSDT add-on's, so no custom patching of a full DSDT is required. Thus this loader should work on any said HP units. For post-install, you may need to generate your own CPU specific SSDT to enable full CPU Power Management (See below for detail).

My systems:

- Z820/Z620/Z420 (BIOS 3.96), Xeon 2760 V1, 2650 V2, or 2680 V2, single or dual
- SSD SATA drive or NvMe SSD on PCI-E adapter
- GTX 680 or Radeon 290/390X graphics (Both are supported out of the box by macOS)
  
Opencore/macOS:

- OC 0.7.1
- Catalina 10.15.7 - Everything works, except Sleep. USB3 at full speed, for storage device. But other USB3 funcionality has not fully tested.
- Big Sur 11.5.1 - Same as Catalina, except USB3 is not functional (attaching storage device wiil not mount, but attaching mouse/keyboard works, however.)

Credits:

- bilbo's "Z820 - High Sierra, the Great Guide" (here), and many of the follow-up contributions in the same forum
- What I have done:
	1) Hot-patching the IRQs conflicts. This finally allows me to move all key patchings, in this case Realtek audio, from DSDT (as done bilbo's guide) to SSDT. Thus the loader is no longer tied to a specific machine/bios configuration, and can be used acrossed other compatible systems (Z420/Z620/Z820's) 
	2) Nailed now the single kernal patch required for Apple CPU Power Management to work.
	
	
