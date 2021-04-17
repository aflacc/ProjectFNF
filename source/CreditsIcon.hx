package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class CreditsIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('creditsGrid'), true, 150, 150);

		animation.add('', [0], 0, false, isPlayer);
		animation.add('projectfnf', [1], 0, false, isPlayer);
		animation.add('core', [1], 0, false, isPlayer);
		animation.add('aflack', [2], 0, false, isPlayer);
		animation.add('enigma', [3], 0, false, isPlayer);
		animation.add('dumbmodmaker', [4], 0, false, isPlayer);

		animation.play(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
/* */
