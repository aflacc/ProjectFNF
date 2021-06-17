/**
 *  This is the config folder for ProjectFNF
 *
 * These are config options the player doesn't get to access so you can keep the game looking as intended.
 * 
 * config options lmao
 */
class Config extends MusicBeatState
{

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
	 * Downscroll. Thanks kade :uwu:
	 * 
	 * Default = **false**
	 */
	 public static var DOWNSCROLL:Bool = true;

	/**
	 * Use the ProjectFNF logo or the Friday Night Funkin logo??
	 * 
	 * Default = **true**
	 */
	public static var CONFIGTitle:Bool = true;

	/**
	 * Skips the "You are using a bla bla bla projectfnf bla bla bla github bla bla bla" message
	 * 
	 * Default = **false**
	 */
	public static var CONFIGSkip:Bool = true;

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
	 * Shakes the camera when you miss a note. Shakes on the Axis you missed the note of. (Up/Down will shake the camera Up and Down)
	 * 
	 * Default = **true**
	 */
	public static var MISSFX:Bool = true;

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

	/**
	 * Use funny inputs like in Kade Engine
	 * (Spam is allow) 
	**/
	public static var INPUT:Bool = true;
}
