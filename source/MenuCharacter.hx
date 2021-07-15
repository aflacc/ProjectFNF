package;

import flixel.FlxSprite;

class MenuCharacter extends FlxSprite
{
	public var character:String;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		this.character = character;

		var tex = Paths.getSparrowAtlas('campaign_menu_UI_characters');
		frames = tex;

		animation.addByPrefix('bf', "BF idle dance white", 24, false);
		animation.addByPrefix('bfConfirm', 'BF HEY!!', 24, false);
		animation.addByPrefix('gf', "GF Dancing Beat WHITE", 24, false);
		animation.addByPrefix('dad', "Dad idle dance BLACK LINE", 24, false);
		animation.addByPrefix('spooky', "spooky dance idle BLACK LINES", 24, false);
		animation.addByPrefix('pico', "Pico Idle Dance", 24, false);
		animation.addByPrefix('mom', "Mom Idle BLACK LINES", 24, false);
		animation.addByPrefix('parents-christmas', "Parent Christmas Idle", 24, false);
		animation.addByPrefix('senpai', "SENPAI idle Black Lines", 24, false);
		// Parent Christmas Idle

		updateHitbox();
	}


	public function bounce() {
		animation.play(character);
	}
}
