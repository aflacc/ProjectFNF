import flixel.group.FlxGroup;
import flixel.FlxBasic.FlxType;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.effects.FlxTrail;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class ModCharts
{
	/**
	 * Configures if the notes should track to there respective strum note. Good to have on, unless your not modcharting.
	 */
	static public var stickNotes:Bool = true;

	/**
	 * Configures if the strum note hiding and unhiding should be checked every frame. IT WOULD BE BETTER TO JUST USE toggleVisibilty()
	 */
	static public var updateNoteVisibilty:Bool = false;

	/**
	 * Defines if the dads strum notes and normal notes should be visible.(FOR CHANGING IN GAME IT IS MORE RECCOMENDED TO USE toggleVisibility()!!)
	 */
	static public var dadNotesVisible:Bool = true;

	/**
	 * Defines if the boyfriends notes should be visible.
	 */
	static public var bfNotesVisible:Bool = true;

	/**
	 * Configures if the strumline should automatically be adjusted every frame.(MAY BE LAGGY)
	 */
	 static public var autoStrum:Bool = false;

	/**
	 * Picks the strum note num to set strumline to, if autoStrum is on
	 */
	 static public var autoStrumNum:Float = 4;

	/**
	 * Quickly spin a sprite 180 degrees. Usually used for spinning the strum arrows.
	 *
	 * ```haxe
	 * ModCharts.quickSpin(arrow);
	 * ```
	 *
	 * @param	Object 		The object to move (FlxObject)
	 */
	static public function quickSpin(sprite)
	{
		FlxTween.angle(sprite, 0, 360, 0.5, {
			type: FlxTween.ONESHOT,
			ease: FlxEase.quadInOut,
			startDelay: 0,
			loopDelay: 0
		});
	}

	/**
	 * Loops a sprite in a circle infinetly. DOES NOT ROTATE THE SPRITE!
	 *
	 * ```haxe
	 * ModCharts.circleLoop(arrow, 90, 50);
	 * ```
	 *
	 * @param	Object 		The object to move (FlxObject)
	 * @param	RotateRadius 		The rotating radius of the object
	 * @param	Duration 		The time it takes to complete a rotation
	 */
	static public function circleLoop(sprite, rotateradius, duration)
	{
		FlxTween.circularMotion(sprite, sprite.x, sprite.y, rotateradius, 90, true, duration, {type: FlxTween.LOOPING});
	}

	/**
	 * Moves the sprite to a certain place on the screen over time.
	 *
	 * ```haxe
	 * ModCharts.moveTo(arrow, 100, 100, 4);
	 * ```
	 *
	 * @param	Object 		The object to move (FlxObject)
	 * @param	x 		The x value of the final destination
	 * @param	y 		The y value of the final destination
	 * @param	duration 		How long it takes to get there(seconds)
	 */
	static public function moveTo(sprite, x, y, duration)
	{
		FlxTween.linearMotion(sprite, sprite.x, sprite.y, x, y, duration, true, {type: FlxTween.ONESHOT, ease: FlxEase.quadInOut});
	}

	/**
	 * Bounces the sprite up and down infinenty(WIP, STILL SHAKY)
	 *
	 * ```haxe
	 * ModCharts.bounceLoop(arrow, 3);
	 * ```
	 *
	 * @param	Object 		The object to bounce (FlxObject)
	 * @param	duration		How logn it takes to bounce up. Repeats for down
	 */
	static public function bounceLoop(sprite, duration)
	{
		FlxTween.linearMotion(sprite, sprite.x, sprite.y, sprite.x, sprite.y - 50, duration, true, {type: FlxTween.PINGPONG});
	}

	/**
	 * Adds a trail to the sprite, like the one spirit has. Pretty much a crossfade effect.
	 *
	 * ```haxe
	 * ModCharts.addTrailToSprite(dad);
	 * ```
	 *
	 * @param	Object 		The object to add the effect to (FlxObject)
	 * @return The trail sprite. simply add it to the project with add(spriteName)
	 */
	static public function addTrailToSprite(sprite)
	{
		var trail = new FlxTrail(sprite, null, 4, 24, 0.3, 0.069);
		// evilTrail.changeValuesEnabled(false, false, false, false);
		// evilTrail.changeGraphic()
		return trail; // to be added
	}

	/**
	 * Cancels all active movements on the sprite. Good for stages if you were using a loop.
	 *
	 * ```haxe
	 * ModCharts.cancelMovement(arrow);
	 * ```
	 *
	 * @param	Object 		The object to cancel (FlxObject)
	 */
	static public function cancelMovement(sprite)
	{
		FlxTween.cancelTweensOf(sprite);//Remind me to uncomment this when magnus fixes it
	}

	/**
	 * Haxeflixel has autism and needs this
	 *
	 * ```haxe
	 * ModCharts.cancelCamera(arrow);
	 * ```
	 *
	 * @param	Camera 		The Camera to cancel
	 */
	static public function cancelCamera(camera:Any)
	{
		FlxTween.cancelTweensOf(camera);//Remind me to uncomment this when magnus fixes it
	}

	/**
	 * Toggles visibility for a sprite. Safe to run after the stage.
	 *
	 * ```haxe
	 * ModCharts.toggleVisibility(arrow, true);
	 * ```
	 *
	 * @param	Object 		The object to toggle (FlxObject)
	 * @param	Bool 		New state for the object(true for seeable, false for invisible)
	 */
	static public function toggleVisibility(sprite, newstate)
	{
		if (newstate == true)
		{
			FlxTween.tween(sprite, {"visible": true}, 0.1);
		}
		else
		{
			FlxTween.tween(sprite, {"visible": false}, 0.1);
		}
	}

	/**
	 * Moves player 1 or two's strum notes to an x or y location. WIP
	 *
	 * ```haxe
	 * ModCharts.moveStrumNotes(playerStrums, 600, 50, 150, 0);
	 * ```
	 *
	 * @param	notesGroup	The group of strum notes to move.
	 * @param	x	The x of the final movement.
	 * @param	y	The y of the final movement.
	 * @param	time	The time it takes to get there.
	 * @param	distancebetweennotes	The distance between each strum note(DEFAULT 150)
	 * @param	startingnum		The starting number for x. Not reccomended to use unless your porting things
	 */

	static public function moveStrumNotes(notesGroup:FlxTypedGroup<FlxSprite>, x, y, time, distancebetweennotes = 50, startingnum = 0) {
		var num = 0;
		notesGroup.forEach(function(note)
		{
			num = num + distancebetweennotes;
			ModCharts.cancelMovement(note);
			ModCharts.moveTo(note, x + num, y, time);
		});
	}

	/**
	 * Fades out an object.
	 * @param object	The object to fade out
	 */
	static public function fadeOutObject(object) {
		FlxTween.tween(object, {"alpha": 0}, 2);
	}

	/**
	 * Fades in an object.
	 * @param object	The object to fade in
	 */
	static public function fadeInObject(object) {
		FlxTween.tween(object, {"alpha": 1}, 2);
	}

	/**
	 * Fades in an out an object infenetly. STARTS BY FADING OUT, THE OBJECT MUST HAVE AN ALPHA OF 1 FOR THIS TO WORK
	 * @param object	The object to fade in and out
	 */
	 static public function fadeInOutLoop(object:FlxSprite) {
		if (object.alpha == 0) {
			trace("[ProjectFNF] Alpha can not be 0");
			return;
		}
		FlxTween.tween(object, {"alpha": 0}, 2, {ease: FlxEase.quadOut, type: FlxTween.PINGPONG});
	}

	/**
	* Bounces the camera up and down infenitley. WIP
	* @param camera		The camera to bounce.
	*/
	static public function cameraBounce(camera:FlxCamera, duration:Float, intensity:Float = 200) {
		FlxTween.tween(camera, {'scroll.y': intensity}, duration, {ease: FlxEase.quadOut, type: FlxTweenType.PINGPONG});
	}

}
