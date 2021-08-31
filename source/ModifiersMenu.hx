package;

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

class ModifiersMenu extends MusicBeatState
{
	public static var instance:ModifiersMenu;

	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;

	public var acceptInput:Bool = true;

	var optionsText:FlxText;
	var optionsDesc:FlxText;

	override function create()
	{
		instance = this;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = CoolUtil.coolTextFile(Paths.txt('modifiers'));
		menuBG.color = FlxColor.GRAY;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);
		optionsText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		optionsText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		optionsDesc = new FlxText(830, 80, 450, "", 32);
		optionsDesc.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		var optionsBG:FlxSprite = new FlxSprite(optionsText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.55), 80, 0xFF000000);
		optionsBG.alpha = 0.6;
		add(optionsBG);
		add(optionsText);
		add(optionsDesc);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);
		for (i in 0...controlsStrings.length)
		{
			if (controlsStrings[i].indexOf('set') != -1)
			{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i].substring(3).split(" || ")[0], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}
		super.create();
		changeSelection();
		//	openSubState(new OptionsSubState());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			// hey, atleast its not yanderedev
			 trace(controlsStrings[curSelected].substring(3).split(" || ")[0]);
			switch (controlsStrings[curSelected].substring(3).split(" || ")[0])
			{
				case "Dad Notes Do Damage":
					FlxG.save.data.dadnotesdodamage = !FlxG.save.data.dadnotesdodamage;
					optionsText.text = FlxG.save.data.dadnotesdodamage;
				case "Dad Notes Can Kill":
					FlxG.save.data.dadnotescankill = !FlxG.save.data.dadnotescankill;
					optionsText.text = FlxG.save.data.dadnotescankill;
				case "Damage from Dad Notes":
					FlxG.save.data.damagefromdadnotes = 10;
					optionsText.text = "1";
				case "No Health Gain":
					FlxG.save.data.nohealthgain += 50;
					if (FlxG.save.data.nohealthgain > 100)
						FlxG.save.data.nohealthgain = 0;
					optionsText.text = FlxG.save.data.nohealthgain == 0 ? "OFF" : FlxG.save.data.nohealthgain + "%";
				case "Dad Notes Visible":
					FlxG.save.data.dadnotesvisible = !FlxG.save.data.dadnotesvisible;
					optionsText.text = FlxG.save.data.dadnotesvisible;
				case "BF Notes Visible":
					FlxG.save.data.bfnotesvisible = !FlxG.save.data.bfnotesvisible;
					optionsText.text = FlxG.save.data.bfnotesvisible;
				case "Stuns Block Inputs":
					FlxG.save.data.stunsblockinputs = !FlxG.save.data.stunsblockinputs;
					optionsText.text = FlxG.save.data.stunsblockinputs;
			}
			FlxG.save.flush();
			// this could be us but FlxG savedata sucks dick and im too lazy to see how kade engine did it
			//	FlxG.save.data[controlsStrings[curSelected].split(" || ")[1]] = !FlxG.save.data.options[controlsStrings[curSelected].split(" || ")[1]];
		}
		if (controls.BACK)
			FlxG.switchState(new OptionsMenu());
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
		if (controls.LEFT_P) {
			switch (controlsStrings[curSelected].substring(3).split(" || ")[0]) {
				case "Damage from Dad Notes":
					FlxG.save.data.damagefromdadnotes -= 1;
					if (FlxG.save.data.damagefromdadnotes < 1)
						FlxG.save.data.damagefromdadnotes = 1;
					optionsText.text = Std.string(FlxG.save.data.damagefromdadnotes / 10);
			}
		}
		if (controls.RIGHT_P) {
			switch (controlsStrings[curSelected].substring(3).split(" || ")[0]) {
				case "Damage from Dad Notes":
					FlxG.save.data.damagefromdadnotes += 1;
					optionsText.text = Std.string(FlxG.save.data.damagefromdadnotes / 10);
			}
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
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// trace(controlsStrings[curSelected].substring(3).split(" || ")[0]);
		switch (controlsStrings[curSelected].substring(3).split(" || ")[0])
		{
			case "Dad Notes Do Damage":
				optionsText.text = FlxG.save.data.dadnotesdodamage;
			case "Dad Notes Can Kill":
				optionsText.text = FlxG.save.data.dadnotescankill;
			case "Damage from Dad Notes":
				optionsText.text = Std.string(FlxG.save.data.damagefromdadnotes / 10);
			case "No Health Gain":
				optionsText.text = FlxG.save.data.nohealthgain == 0 ? "OFF" : FlxG.save.data.nohealthgain + "%";
			case "BF Notes Visible":
				optionsText.text = FlxG.save.data.bfnotesvisible;
			case "Dad Notes Visible":
				optionsText.text = FlxG.save.data.dadnotesvisible;
			case "Stuns Block Inputs":
				optionsText.text = FlxG.save.data.stunsblockinputs;
		}
		// how did it take me this long to figure this out bruh (still applies here)
		optionsDesc.text = controlsStrings[curSelected].split(" || ")[1];

		// selector.y = (70 * curSelected) + 30;
		var bullShit:Int = 0;
		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
