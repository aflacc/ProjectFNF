
[![Discord](https://img.shields.io/discord/826580018346852372?color=7289da&icon=discord&label=Discord&logoColor=%234e5d94&style=for-the-badge&icon=disc)](https://discord.gg/fmxuXhRqMU)  [![Version](https://img.shields.io/github/v/release/aflacc/ProjectFNF?label=Release&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/releases)  [![Updated](https://img.shields.io/github/last-commit/aflacc/ProjectFNF?label=Updated&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/commits/master) [![Activity](https://img.shields.io/github/commit-activity/w/aflacc/ProjectFNF?label=Activity&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/commits/master)
***
<div align="center"> <img src="https://github.com/aflacc/ProjectFNF/blob/master/art/projectfnf.png?raw=true" height=500 width=500 align="center"></div>
<div align="center">Kade Engine but cooler :sunglasses:</div>

# About
ProjectFNF is a engine for Friday Night Funkin' designed to be flexible. It contains a few quality of life enhancements along with a whole [wiki](https://github.com/aflacc/ProjectFNF/wiki) which can help the user make their own mod.
Interested in trying the beta? Click [here](https://github.com/aflacc/ProjectFNF/blob/master/beta.md)
***

## Changelog
#### v0.2-b
- Miss counter next to score
- A few easter eggs
- Modcharts (WIP)
- In-Game config has a single option called "Debug Mode" (Mostly for testing, probably doesn't work)
- Added MISSFX, MISSIntensity, MISSDir and CACHE config options.
- Missing notes will cause the screen to shake a little bit (highly configurable)
- Notes that you fail to hit will trigger the miss animations and sounds, also resets the combo.
- Added a small outline to the score text to make it visible in Week 5 or just really bright enviroments
- Changed Bopeebo to use the original music and voices (seriously I like them a lot better than the new one)
- Prototype failsafe for attempting to load a song that doesn't exist
- Some more Icons to the DiscordRPC
- Revamped the DiscordRPC design
- Completely revamped the console outputs. (Way less cluttered and is much more specific about what its doing)
- Animations for the characters re-designed to use the official neo stuff (tysm moisty)
- Added "Bookmark" comments (Makes finding parts of the code a LOT easier, just search for the bookmark)

#### v0.2-a ([BETA](https://github.com/aflacc/ProjectFNF/blob/master/beta.md))
- Missing a note causes the screen to shake (configurable)
- Notes that pass (not actually hit) also still play the sound and play the miss animation
- Improved the input system to be able to handle more notes
- Fixed an issue with the freeplay menu causing a crash
- Reverted the "hi" commit (don't ask)
- Created the ProjectFNF Beta Program
- Made the Config file work
- Added a Mod Title to the main menu
- The mod version on the main menu uses the metadata instead of being hand-typed.
- Added miss sprites to week 6
- Dying now zooms the camera in towards the boyfriend
- Screen shakes a little bit if you try and play a locked week
#### v0.1-d
- accidentally committed stuff for a seperate mod aaaaaaaaa
- anything that has to do with neo stuff _does not belong in the files!_
- If anyone wants to go and make a pull request that removes all the neo stuff please let me know
#### v0.1-c
- Added a cutscene to South transitioning to Monster
- Updated Senpai and Pixel Boyfriends sprites to close their mouths.
- Fixed an issue with game crashing opening the debug menu
- Thorns has seperate intro assets

***

# Mods that use ProjectFNF
- neo (woah)

# Setup workspace
Taken from [Here](https://github.com/aflacc/ProjectFNF/wiki/Setup-Workspace)

### Installing the Required Programs

First you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple). 
1. [Install Haxe](https://haxe.org/download) (4.2.1 seems to work fine (Tested on Linux by @VMGuy23))
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe

Other installations you'd need is the additional libraries, a fully updated list will be in `Project.xml` in the project root. Currently, these are all of the things you need to install:
```
lime
openfl
flixel
flixel-addons
flixel-ui
hscript
newgrounds
```
So for each of those type `haxelib install [library]` so shit like `haxelib install newgrounds`

Run `haxelib run lime setup` to be able to use the `lime` command so you can actually compile the game.

You'll also need to install a couple things that involve Gits. To do this, you need to do a few things first.
1. Download [git-scm](https://git-scm.com/downloads). Works for Windows, Mac, and Linux, just select your build. (On Linux, just install Git)
2. Follow instructions to install the application properly.
3. Run `haxelib git polymod https://github.com/larsiusprime/polymod.git` to install Polymod.
4. Run `haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc` to install Discord RPC.

You should have everything ready for compiling the game! Follow the guide below to continue!

At the moment, you can optionally fix the transition bug in songs with zoomed out cameras.
- Run `haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons` in the terminal/command-prompt.

### Downloading the source

You can download the source by unzipping the download from above, running `git clone https://github.com/aflacc/ProjectFNF.git` in a terminal or cloning with GitHub Desktop.

### Compiling game

Once you have all those installed, it's pretty easy to compile the game. You just need to run 'lime test html5 -debug' in the root of the project to build and run the HTML5 version. (command prompt navigation guide can be found here: [https://ninjamuffin99.newgrounds.com/news/post/1090480](https://ninjamuffin99.newgrounds.com/news/post/1090480))

To run it from your desktop (Windows, Mac, Linux) it can be a bit more involved. For Linux, you only need to open a terminal in the project directory and run 'lime test linux -debug' and then run the executible file in export/release/linux/bin. For Windows, you need to install Visual Studio Community 2019. While installing VSC, don't click on any of the options to install workloads. Instead, go to the individual components tab and choose the following:
* MSVC v142 - VS 2019 C++ x64/x86 build tools (Latest)
* Windows SDK (10.0.19041.0)

This will install about 4GB of crap, but once that is done you can open up a command line in the project's directory and run `lime test windows -debug`. Once that command finishes (it takes forever even on a higher end PC), you can run FNF from the .exe file under export\release\windows\bin
As for Mac, 'lime test mac -debug' should work, if not the internet surely has a guide on how to compile Haxe stuff for Mac.

### Additional guides

- [Command line basics](https://ninjamuffin99.newgrounds.com/news/post/1090480)



# Adding Healthbar Colors
Taken from [Here](https://github.com/aflacc/ProjectFNF/wiki/Custom-Healthbar-Colors)


## Explanation
The Way the Healthbar colors works, is inside `PlayState.hx` there is a setting at the top called `CustomHealth`. When this value is set to `true`, this feature is enabled. This feature gives the health bar specific colors depending on what characters are currently being used. The Health bar Colors are handled via a list right below the `CustomHealth` config option. These colors are in hexadecimal. HaxeFlixel does not read `#` well, so to get a Hex color, you will use `0xFF` instead. For example, `0xFFFFFFFF` is White. I just google "Color Picker" to choose my hex colors, but any way to get a hex color also works.

The List of colors is in the same order as the characters in `CharacterList.txt`. (Located in the Data folder), so Boyfriends color is the first value in the array. If the color list is longer than that of `CharacterList.txt` then the game will crash. However, you do not have to do every characters color, since any characters without a color will be assigned to a white color. 


# Enabling/Disabling Features
Taken from [Here](https://github.com/aflacc/ProjectFNF/wiki/Disabling-and-Enabling-features)

ProjectFNF has a configuration file that will be functional in `v0.1-c`. This config file (`config.hx`) is mod locked features that the user can not turn on or off. Before `v0.1-c`, you can find this config options located in their respective files. Some of these config options are as follows:

## List of Features
`distortedIntro` (Bool) - Thorns in week 6 has a more distorted countdown than Roses or Senpai\
`gfLimo` (Bool) - Girlfriend in week 4 will sit on the Limo in the back instead of their normal speaker and in between the two cars \
`fps` (Int) - Frames per Second. This cannot (needs confirmation) be changed during the gameplay. 
`poses` (Int) - If you want the characters to do poses (the "Hey", girlfriend cheering, the sweating in week 2 etc.) This one only accepts 3 values:\
0 - No Poses\
1 - Original Game poses (theres a few custom ones in the engine)\
2 - All poses (Default)\
`hpBarCol` (Array) - See [Custom Healthbar Colors](https://github.com/aflacc/ProjectFNF/wiki/Custom-Healthbar-Colors), this is the list of colors that the custom healthbar uses. If this array is empty (feature as of `v0.1-c`), then the custom healthbar will be disabled. However, if you change this variable into a Integer, you can further customize it:\
`0` - No custom Healthbar\
`1` - Boyfriend side only Colors\
`2` - Dad side only Colors\
`3` - No Color\
`enemyNoteFix` (Bool) - This basically fixes the second characters notes not lighting up and actually looks really good




## References:
`Bool`, or Boolean is a true or false variable. This can *only* be set to `True` or `False`\
`Int`, or Integer is a number variable. Any letters in these kinds of values will result in an error.\
`Array`, a list of values.

# Usage
We do not ask for much, all we ask is you link the github and if the mod is on gamebanana make sure to credit "aflack" for making the engine. Also please do not remove the ProjectFNF version on the bottom of the screen in the main menu, this gives the engine its credit and also makes it easier to receive help with the mod. I will *not* be able to help you if you do not have the version of ProjectFNF in the game.



# General Statistics
[![Issues](https://img.shields.io/github/issues/aflacc/ProjectFNF?style=for-the-badge)](https://github.com/aflacc/ProjectFNF/issues)
[![Discord](https://img.shields.io/discord/826580018346852372?color=7289da&label=Discord&logoColor=%234e5d94&style=for-the-badge)](https://discord.gg/fmxuXhRqMU)  [![Version](https://img.shields.io/github/v/release/aflacc/ProjectFNF?label=Release&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/releases)  [![Updated](https://img.shields.io/github/last-commit/aflacc/ProjectFNF?label=Updated&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/commits/master) [![Activity](https://img.shields.io/github/commit-activity/w/aflacc/ProjectFNF?label=Activity&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/commits/master) ![Downloads](https://img.shields.io/github/downloads/aflacc/ProjectFNF/total?style=for-the-badge) ![License](https://img.shields.io/github/license/aflacc/ProjectFNF?style=for-the-badge)

*click on the stats to see more about that topic!*/
*stats generated with [shields.io](http://shields.io/)*

😐 why are you cringe
