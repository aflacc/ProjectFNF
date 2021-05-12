// This is the config folder for ProjectFNF
// These are config options the player doesn't get to access so you can keep the game looking as intended.
class Config extends MusicBeatState
{
	public static var CONFIGGfCar:Bool = true; // If you want GF on week 4 to be sitting on the car in the back and not on a speaker.
	public static var CONFIGTitle:Bool = false; // Title screen uses ProjectFNF logo instead of the Logo bumpin.
	public static var CONFIGSkip:Bool = false; // Skips the "You are using a bla bla bla projectfnf bla bla bla github bla bla bla" message
	public static var ModName:String = 'Vs Banjo And Kazooie'; // Change this to the name of your mod
	public static var DEBUGMODE:Bool = false; // WIP
	public static var MISSFX:Bool = true; // Shakes the camera
	public static var MISSINTENSITY = 0.0004; // Only does anything if MISSFX is true dont put too high
}
