# Cracktros, CD Intros & Demos

This repository provides all cracktros, CD intros and demos
coded in ASM68k for Atari ST by Orion from The Replicants & Fuzion.

*orion.src/* contains the ASM sources and corresponding build-time data (pictures, musics)

*disks/* provides the run-time data of the 2 following demos:
- The Bombonne II
- The Megafun 3

In order to build and run those sources, you need to:
- Copy the *orion.src/* directory at the root of your hard drive (space usage is about 2.6 MB)
- Launch Devpac (GenST)
- Choose a cracktro or demo and load the main source file (e.g. INTRO.S)
- Assemble it and Run it

All sources have been successfully assembled with GenST 2.09 and tested on top of an Atari STE with 1MB of RAM, emulated with
Steem v3.2 or Hatari 2.0, and using TOS 1.62.
