/**
 *  This is the config folder for ProjectFNF
 *
 * These are config options the player doesn't get to access so you can keep the game looking as intended.
 * 
 * config options lmao
 */

import flixel.util.FlxColor;

class Config extends MusicBeatState
{

	/**
	* Week colors. Each color corresponds to its custom week
	**/
	public static var weekColors:Array<FlxColor> = [
		0xFFca1f6f, // GF
		0xFFc885e5, // DAD
		0xFFf9a326, // SPOOKY
		0xFFceec75, // PICO
		0xFFec7aac, // MOM
		0xFFffffff, // PARENTS-CHRISTMAS (Look I don't know what a Better color would be.)
		0xFFffaa6f // SENPAI
	];

	/**
	* Health Bar Colors. One for each character uses the character list
	* To add your own character healthbar color, simply add another line to the list, and put your hexadecimal color code (#ffffff or somethin)
	* and then replace the "#" with "0xFF".
	**/
	public static var col:Array<FlxColor> = [
		0xFF51d8fb, // BF
		0xFF9fe6ff, // BF-PIXEL
		0xFF51d8fb, // BF-CHRISTMAS
		0xFF51d8fb, // BF-CAR
		0xFFca1f6f, // GF
		0xFFca1f6f, // GF-CHRISTMAS (Pretty sure this one doesn't really do anything.)
		0xFFc885e5, // DAD
		0xFFec7aac, // MOM
		0xFFec7aac, // MOM-CAR
		0xFFffffff, // PARENTS-CHRISTMAS (Look I don't know what a Better color would be.)
		0xFFf9a326, // SPOOKY
		0xFFceec75, // PICO
		0xFFf5ff8a, // MONSTER
		0xFFf5ff8a, // MONSTER-CHRISTMAS
		0xFFffaa6f, // SENPAI
		0xFFffaa6f, // SENPAI-ANGRY
		0xFFff5d87 // SPIRIT
	];

	/**
	 * The intro thing. plays right before the flash to the gf screen
	 * 
	 * Default = **["Friday", "Night", "Funkin"]**
	 */
	 public static var TITLEMESSAGE:Array<String> = ["Friday", "Night", "Funkin"];

	/**
	 * Makes the Girlfriend sit on the Limo instead of the Speaker in week 4.
	 * Its very funny
	 * 
	 * Default = **true**
	 */
	public static var CONFIGGfCar:Bool = true;

	/**
	 * Use the ProjectFNF logo or the Friday Night Funkin logo??
	 * 
	 * Default = **true**
	 */
	public static var CONFIGTitle:Bool = true;

	/**
	 * Skips the "You are using a bla bla bla projectfnf bla bla bla github bla bla bla" message
	 * 
	 * Usually for devs
	 */
	public static var CONFIGSkip:Bool = false;
	/**
	 *  The Name of the Mod. This shows up in the Main Menu with the Story Mode, Freeplay, Donate, and Options buttons
	 * 
	 * Default = **ProjectFNF**
	 */
	public static var ModName:String = 'ProjectFNF';

	/**
	 * This is a WIP thing. I don't fully know what I'm gonna do with this but I might just have it make the Output be a little more in depth.
	 * 
	 * Default = **false**
	 */
	public static var DEBUGMODE:Bool = false;

	/**
	 * Only Works if **MISSFX** is set to **true**
	 * 
	 * It is not reccomended to set this *too* high, it gets very obnoxious ***VERY*** quickly.
	 * 
	 * Suggested to use any value between .001 - .01
	 * 
	 * Default = **0.002**
	 */
	public static var MISSINTENSITY = 0.002;
}
