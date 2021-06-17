package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class CreditsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;

	var bg:FlxSprite;

	override function create()
	{
		trace("Opened credits! From " + CumFart.stateFrom);

		bg = new FlxSprite(-1300, -90);
		add(bg);
		bg.loadGraphic(Paths.image('mainMenuCity'));
		FlxTween.linearMotion(bg, -1300, -90, -600, -90, 1, true, {type: FlxTween.ONESHOT, ease: FlxEase.expoInOut});

		controlsStrings = CoolUtil.coolTextFile(Paths.txt("credits"));

		grpControls = new FlxTypedGroup<Alphabet>();
		//add(grpControls);
		for (i in 0...controlsStrings.length)
		{
			if (controlsStrings[i].indexOf('set') != -1)
			{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i].substring(3) + ' : ' + controlsStrings[i + 1], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}
		new FlxTimer().start(0.9, function(tmr:FlxTimer) {
			add(grpControls);
			changeSelection();
		});
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.ACCEPT)
		{
			switch(curSelected) {
				case 0:
					FlxG.openURL("https://youtube.com/channel/UCVgVvwOzvsR8pRwVy316SyA");
				case 1:
					FlxG.openURL("https://www.youtube.com/channel/UC7M0aIL8-eVSJker9p0OyUQ");
				case 2:
					FlxG.openURL("https://twitter.com/EvanClubYT");
				case 3:
					FlxG.openURL("https://twitter.com/C0nfuzzl3dis/");
				case 4:
					FlxG.openURL("https://youtube.com/channel/UCVgVvwOzvsR8pRwVy316SyA");
				case 5:
					FlxG.openURL("https://twitter.com/ninja_muffin99");
			}
		//	var funnystring = Std.string(curSelected);
		//	FlxG.openURL(funnystring); 
		}

		if (isSettingControl)
			waitingInput();
		{
			if (controls.BACK)
				CumFart.stateFrom = "freeplay"; // doesnt rlly matter
				FlxG.switchState(new MainMenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
		}
	}

	function waitingInput():Void
	{
		if (FlxG.keys.getIsDown().length > 0)
		{
			PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
		}
		// PlayerSettings.player1.controls.replaceBinding(Control)
	}

	var isSettingControl:Bool = false;

	function changeBinding():Void
	{
		if (!isSettingControl)
		{
			isSettingControl = true;
		}
	}

	function changeSelection(change:Int = 0)
	{
//		#if !switch
		//NGio.logEvent('Fresh');
//		#end

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;
	
				item.alpha = 0;
				// item.setGraphicSize(Std.int(item.width * 0.8));
	
				if (item.targetY == 0)
				{
					item.alpha = 1;
					// item.setGraphicSize(Std.int(item.width));
				}
				if (item.targetY - 1 == 0 || item.targetY + 1 == 0) {
					item.alpha = 0.6;
				}
			}
	}
}
