
[![Discord](https://img.shields.io/discord/826580018346852372?color=7289da&label=Discord&logoColor=%234e5d94&style=for-the-badge)](https://discord.gg/fmxuXhRqMU)  [![Version](https://img.shields.io/github/v/release/aflacc/ProjectFNF?label=Release&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/releases)  [![Updated](https://img.shields.io/github/last-commit/aflacc/ProjectFNF?label=Updated&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/commits/master) [![Activity](https://img.shields.io/github/commit-activity/w/aflacc/ProjectFNF?label=Activity&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/commits/master)
***
![Logo](https://u.cubeupload.com/Aflac/ProjectFNF.png)

*Kade Engine but cooler :sunglasses:*

# About
ProjectFNF is a engine for Friday Night Funkin' designed to be flexable. It contains a few quality of life enhancements along with a whole [wiki](https://github.com/aflacc/ProjectFNF/wiki) which can help the user make their own mod.
***

## Changelog
#### v0.1-d
- accidentally committed stuff for a seperate mod aaaaaaaaa
- anything that has to do with neo stuff _does not belong  in the files!_
- If anyone wants to go and make a pull request that removes all the neo stuff please let me know
#### v0.1-c
- Added a cutscene to South transitioning to Monster
- Updated Senpai and Pixel Boyfriends sprites to close their mouths.
- Fixed an issue with game crashing opening the debug menu
- Thorns has seperate intro assets
- 

***

# Mods that use ProjectFNF
- none yet

# Setup workspace
Taken from [Here](https://github.com/aflacc/ProjectFNF/wiki/Setup-Workspace)

### Installing the Required Programs

First you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple). 
1. [Install Haxe 4.1.5](https://haxe.org/download/version/4.1.5/) (Download 4.1.5 instead of 4.2.0 because 4.2.0 is broken and is not working with gits properly...)
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe

Other installations you'd need is the additional libraries, a fully updated list will be in `Project.xml` in the project root. Currently, these are all of the things you need to install:
```
flixel
flixel-addons
flixel-ui
hscript
newgrounds
```
So for each of those type `haxelib install [library]` so shit like `haxelib install newgrounds`

You'll also need to install a couple things that involve Gits. To do this, you need to do a few things first.
1. Download [git-scm](https://git-scm.com/downloads). Works for Windows, Mac, and Linux, just select your build.
2. Follow instructions to install the application properly.
3. Run `haxelib git polymod https://github.com/larsiusprime/polymod.git` to install Polymod.
4. Run `haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc` to install Discord RPC.

You should have everything ready for compiling the game! Follow the guide below to continue!

At the moment, you can optionally fix the transition bug in songs with zoomed out cameras.
- Run `haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons` in the terminal/command-prompt.

### Ignored files

I gitignore the API keys for the game, so that no one can nab them and post fake highscores on the leaderboards. But because of that the game
doesn't compile without it.

Just make a file in `/source` and call it `APIStuff.hx`, and copy paste this into it

```haxe
package;

class APIStuff
{
	public static var API:String = "";
	public static var EncKey:String = "";
}

```

and you should be good to go there.

### Compiling game

Once you have all those installed, it's pretty easy to compile the game. You just need to run 'lime test html5 -debug' in the root of the project to build and run the HTML5 version. (command prompt navigation guide can be found here: [https://ninjamuffin99.newgrounds.com/news/post/1090480](https://ninjamuffin99.newgrounds.com/news/post/1090480))

To run it from your desktop (Windows, Mac, Linux) it can be a bit more involved. For Linux, you only need to open a terminal in the project directory and run 'lime test linux -debug' and then run the executible file in export/release/linux/bin. For Windows, you need to install Visual Studio Community 2019. While installing VSC, don't click on any of the options to install workloads. Instead, go to the individual components tab and choose the following:
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)
* C++ Profiling tools
* C++ CMake tools for windows
* C++ ATL for v142 build tools (x86 & x64)
* C++ MFC for v142 build tools (x86 & x64)
* C++/CLI support for v142 build tools (14.21)
* C++ Modules for v142 build tools (x64/x86)
* Clang Compiler for Windows
* Windows 10 SDK (10.0.17134.0)
* Windows 10 SDK (10.0.16299.0)
* MSVC v141 - VS 2017 C++ x64/x86 build tools
* MSVC v140 - VS 2015 C++ build tools (v14.00)

This will install about 22GB of crap, but once that is done you can open up a command line in the project's directory and run `lime test windows -debug`. Once that command finishes (it takes forever even on a higher end PC), you can run FNF from the .exe file under export\release\windows\bin
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



# General Statistics
[![Issues](https://img.shields.io/github/issues/aflacc/ProjectFNF?style=for-the-badge)](https://github.com/aflacc/ProjectFNF/issues)
[![Discord](https://img.shields.io/discord/826580018346852372?color=7289da&label=Discord&logoColor=%234e5d94&style=for-the-badge)](https://discord.gg/fmxuXhRqMU)  [![Version](https://img.shields.io/github/v/release/aflacc/ProjectFNF?label=Release&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/releases)  [![Updated](https://img.shields.io/github/last-commit/aflacc/ProjectFNF?label=Updated&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/commits/master) [![Activity](https://img.shields.io/github/commit-activity/w/aflacc/ProjectFNF?label=Activity&style=for-the-badge)](https://github.com/aflacc/ProjectFNF/commits/master) ![Downloads](https://img.shields.io/github/downloads/aflacc/ProjectFNF/total?style=for-the-badge) ![License](https://img.shields.io/github/license/aflacc/ProjectFNF?style=for-the-badge)

*click on the stats to see more about that topic!*/
*stats generated with [shields.io](http://shields.io/)*
