package;

import flixel.FlxG;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image(FlxG.save.data.newicons ? 'iconGrid' : 'iconGrid-v2'), true, 150, 150);

		antialiasing = true;
		if (!FlxG.save.data.newicons) {
			animation.add('bf', [0, 1, 29], 0, false, isPlayer);
			animation.add('bf-car', [0, 1, 29], 0, false, isPlayer); // he turned into a convertible 
			animation.add('bf-christmas', [0, 1, 29], 0, false, isPlayer);
			animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
			animation.add('spooky', [2, 3, 2], 0, false, isPlayer);
			animation.add('pico', [4, 5, 4], 0, false, isPlayer);
			animation.add('mom', [6, 7, 6], 0, false, isPlayer);
			animation.add('mom-car', [6, 7, 6], 0, false, isPlayer);
			animation.add('tankman', [8, 9, 8], 0, false, isPlayer);
			animation.add('face', [10, 11, 10], 0, false, isPlayer);
			animation.add('dad', [12, 13, 12], 0, false, isPlayer);
			animation.add('senpai', [22], 0, false, isPlayer); // I personally hate icon 23
			animation.add('senpai-angry', [24, 25, 24], 0, false, isPlayer);
			animation.add('spirit', [26, 27, 28], 0, false, isPlayer); // winning icon is from weeg mod dont sue me
			animation.add('bf-old', [14, 15,14], 0, false, isPlayer);
			animation.add('gf', [16, 31, 30], 0, false, isPlayer); // cute icons pog
			animation.add('parents-christmas', [17], 0, false, isPlayer);
			animation.add('monster', [19, 20, 19], 0, false, isPlayer);
			animation.add('monster-christmas', [19, 20, 19], 0, false, isPlayer);
		} else {
			animation.add('bf', [0, 1, 2], 0, false, isPlayer);
			animation.add('bf-car', [0, 1, 2], 0, false, isPlayer); // he turned into a convertible 
			animation.add('bf-christmas', [0, 1, 2], 0, false, isPlayer);
			animation.add('bf-pixel', [0, 1, 2], 0, false, isPlayer);
			animation.add('spooky', [3, 4, 5], 0, false, isPlayer);
			animation.add('pico', [6, 7, 8], 0, false, isPlayer);
			animation.add('mom', [9, 10, 11], 0, false, isPlayer);
			animation.add('mom-car', [9, 10, 11], 0, false, isPlayer);
			animation.add('tankman', [24, 25, 26], 0, false, isPlayer);
			animation.add('face', [33, 34, 35], 0, false, isPlayer);
			animation.add('dad', [12, 13, 14], 0, false, isPlayer);
			animation.add('senpai', [27, 28, 29], 0, false, isPlayer); // I personally hate icon 23
			animation.add('senpai-angry', [30, 31, 32], 0, false, isPlayer);
			animation.add('spirit', [26, 27, 28], 0, false, isPlayer); // winning icon is from weeg mod dont sue me
			animation.add('bf-old', [0, 1, 2], 0, false, isPlayer);
			animation.add('gf', [15, 16, 17], 0, false, isPlayer); // cute icons pog
			animation.add('parents-christmas', [18, 19, 20], 0, false, isPlayer);
			animation.add('monster', [21, 22, 23], 0, false, isPlayer);
			animation.add('monster-christmas', [21, 22, 23], 0, false, isPlayer);
		}
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
