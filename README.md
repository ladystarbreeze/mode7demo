# mode7demo
 **GBA Mode 7 demo written in assembly.**

## **How does this demo work?**
 This demo uses the Game Boy Advance's *actual* Mode 7 (which is only capable of displaying a single color, the backdrop) to display a 15-bit color bitmap.

 This is done by streaming the colors of a bitmap to palette entry 0. In this demo, DMA3 streams color information to palette RAM whereas DMA0 assists with synchronization.

## **How can I assemble this ROM?**
 Use FASMARM and assemble `main.asm` in the `source` folder; this should give you a working ROM.

## **Can I replace the bitmap with a custom one?**
 Yes. Replace `serena.img.bin` with a 15-bit color bitmap of your liking. If you want to use a different file name, edit `main.asm` and replace `file    'serena.img.bin'` with `file    'your.bitmap'`.

## **Is this demo useful?**
 No, it's **not**. Similar to "blast processing" on the Sega Genesis, this demo eats up most of the available CPU time (while the CPU doesn't do much work, it's still blocked due to continuous DMA during VDRAW).

## **License**
 This demo is released under the **MIT license**.
