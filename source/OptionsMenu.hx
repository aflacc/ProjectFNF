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

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;

	public var acceptInput:Bool = true;

	var optionsText:FlxText;
	var optionsDesc:FlxText;

	var viewer:FlxSprite;

	var notetypes = [
		"NOTE", "TRIANGLE", "CIRCLE", "BEATSABER", "STEPMANIA", "ETTERNA", "SPOOKY", "VAPORWAVE", "HELLBEATS", "WAFELS3", "NEO", "SOFT", "TRANSPARENT",
		"SPLASH", "ITG"
	];
	var noteselection = 69; // funny number

	override function create()
	{
		instance = this;

		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = CoolUtil.coolTextFile(Paths.txt('options'));
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
		controlsStrings[controlsStrings.length] = "setCustomize Keybinds"; // I HAVE SEVERE AUTISM LOOODALOFDALK
		for (i in 0...controlsStrings.length)
		{
			switch (controlsStrings[i].substring(3).split(" || ")[0])
			{
				case "Ghost Tapping":
					if (FlxG.save.data.ghosttapping == null) {
						trace("Some data's null around here :nerd:");
						FlxG.save.data.ghosttapping = controlsStrings[curSelected].split(" || ")[2];
					}
				case "Downscroll":
					if (FlxG.save.data.downscroll == null)
						FlxG.save.data.downscroll = controlsStrings[curSelected].split(" || ")[2];
				case "Miss Shake":
					if (FlxG.save.data.missshake == null)
						FlxG.save.data.missshake = controlsStrings[curSelected].split(" || ")[2];
				case "Dad Notes Visible":
					if (FlxG.save.data.dadnotesvisible == null)
						FlxG.save.data.dadnotesvisible = controlsStrings[curSelected].split(" || ")[2];
				case "Enable Miss Animations":
					if (FlxG.save.data.enablemissanimations == null)
						FlxG.save.data.enablemissanimations = controlsStrings[curSelected].split(" || ")[2];
				case "Square Notes":
					if (FlxG.save.data.squarenotes == null)
						FlxG.save.data.squarenotes = controlsStrings[curSelected].split(" || ")[2];
				case "Advanced Info Bar":
					if (FlxG.save.data.advancedinfobar == null)
						FlxG.save.data.advancedinfobar = controlsStrings[curSelected].split(" || ")[2];
				case "Bot Play":
					if (FlxG.save.data.botplay == null)
						FlxG.save.data.botplay = controlsStrings[curSelected].split(" || ")[2];
				case "Hit Sounds":
					if (FlxG.save.data.hitsounds == null)
						FlxG.save.data.hitsounds = controlsStrings[curSelected].split(" || ")[2];
				case "New Icons":
					if (FlxG.save.data.newicons == null)
						FlxG.save.data.newicons = controlsStrings[curSelected].split(" || ")[2];
				case "Info Bar BG":
					if (FlxG.save.data.infobarbg == null)
						FlxG.save.data.infobarbg = controlsStrings[curSelected].split(" || ")[2];
				case "Countdown After Pause":
					if (FlxG.save.data.countdownafterpause == null)
						FlxG.save.data.countdownafterpause = controlsStrings[curSelected].split(" || ")[2];
				case "Custom Scroll Speed":
					if (FlxG.save.data.customscrollspeed == null)
						FlxG.save.data.customscrollspeed = 0;
				case "Change Note Theme":
					if (FlxG.save.data.notetheme == null)
						FlxG.save.data.notetheme = "NOTE";
				case "Max Optimization":
					if (FlxG.save.data.maxoptimization == null) {
						FlxG.save.data.maxoptimization = controlsStrings[curSelected].split(" || ")[2];
					}
				case "Middle Scroll":
					if (FlxG.save.data.middlescroll == null) {
						FlxG.save.data.middlescroll = controlsStrings[curSelected].split(" || ")[2];
					}
				case "Charting Background":
					if (FlxG.save.data.chartingbackground == null) {
						FlxG.save.data.chartingbackground = controlsStrings[curSelected].split(" || ")[2];
					}
				case "Custom Offset":
					if (FlxG.save.data.offset == null) {
						FlxG.save.data.offset = 0;
					}
			}

			// failsafe cuz stupid
			if (FlxG.save.data.dadnotesdodamage == null)
				FlxG.save.data.dadnotesdodamage = false;
			if (FlxG.save.data.dadnotescankill == null)
				FlxG.save.data.dadnotescankill = false;
			if (FlxG.save.data.dadnotesvisible == null)
				FlxG.save.data.dadnotesvisible = true;
			if (FlxG.save.data.bfnotesvisible == null)
				FlxG.save.data.bfnotesvisible = true;
			if (FlxG.save.data.stunsblockinputs == null)
				FlxG.save.data.stunsblockinputs = false;
			if (FlxG.save.data.infobar == null)
				FlxG.save.data.infobar = [];

			FlxG.save.flush();

			if (controlsStrings[i].indexOf('set') != -1)
			{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i].substring(3).split(" || ")[0], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			}
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}
		viewer = new FlxSprite(1000, 300);
		add(viewer);
		viewer.frames = Paths.getSparrowAtlas('notes/' + FlxG.save.data.notetheme + '_assets', 'shared');
		viewer.animation.addByPrefix('confirm', 'up confirm', 24, true);
		viewer.animation.play('confirm');
		//		viewer.frames = Paths.getSparrowAtlas('notes/' + FlxG.save.data.notetheme + '_assets', 'shared');

		noteselection = notetypes.indexOf(FlxG.save.data.notetheme);
		super.create();
		changeSelection();
		//	openSubState(new OptionsSubState());
	}

	function getOption(name:String) {
		switch (name)
		{
			case "Advanced Info Bar":
				return FlxG.save.data.advancedinfobar;
			case "Countdown After Pause":
				return FlxG.save.data.countdownafterpause;
			case "Downscroll":
				// trace("Before: " + FlxG.save.data.downscroll);
				return FlxG.save.data.downscroll;
			// trace("After: " + FlxG.save.data.downscroll);
			case "Ghost Tapping":
				// trace("Before: " + FlxG.save.data.ghosttapping);
				return FlxG.save.data.ghosttapping;
			// trace("After: " + FlxG.save.data.ghosttapping);
			case "Miss Shake":
				return FlxG.save.data.missshake; // FlxG.save.data.dadnotesvisible
			case "Dad Notes Visible":
				return FlxG.save.data.dadnotesvisible;
			case "Enable Miss Animations":
				return FlxG.save.data.enablemissanimations;
			case "Bot Play":
				return FlxG.save.data.botplay;
			case "Hit Sounds":
				return FlxG.save.data.hitsounds;
			case "New Icons":
				return FlxG.save.data.newicons;
			case "Info Bar BG":
				return FlxG.save.data.infobarbg;
			case "Max Optimization":
				return FlxG.save.data.maxoptimization;
			case "Middle Scroll":
				return FlxG.save.data.middlescroll;
			case "Charting Background":
				return FlxG.save.data.chartingbackground;
			case "Change Note Theme":
				return FlxG.save.data.notetheme;
			case "Custom Scroll Speed":
				return FlxG.save.data.customscrollspeed;
			case "Custom Offset":
				return FlxG.save.data.offset;
		}
		return "None Found";
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
				case "Advanced Info Bar":
					FlxG.save.data.advancedinfobar = !FlxG.save.data.advancedinfobar;
					optionsText.text = FlxG.save.data.advancedinfobar;
				case "Countdown After Pause":
					FlxG.save.data.countdownafterpause = !FlxG.save.data.countdownafterpause;
					optionsText.text = FlxG.save.data.countdownafterpause;
				case "Square Notes":
					FlxG.save.data.squarenotes = !FlxG.save.data.squarenotes;
					optionsText.text = FlxG.save.data.squarenotes;
				case "Downscroll":
					// trace("Before: " + FlxG.save.data.downscroll);
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
					optionsText.text = FlxG.save.data.downscroll;
				// trace("After: " + FlxG.save.data.downscroll);
				case "Ghost Tapping":
					// trace("Before: " + FlxG.save.data.ghosttapping);
					FlxG.save.data.ghosttapping = !FlxG.save.data.ghosttapping;
					optionsText.text = FlxG.save.data.ghosttapping;
				// trace("After: " + FlxG.save.data.ghosttapping);
				case "Miss Shake":
					FlxG.save.data.missshake = !FlxG.save.data.missshake;
					optionsText.text = FlxG.save.data.missshake; // FlxG.save.data.dadnotesvisible
				case "Dad Notes Visible":
					FlxG.save.data.dadnotesvisible = !FlxG.save.data.dadnotesvisible;
					optionsText.text = FlxG.save.data.dadnotesvisible;
				case "Enable Miss Animations":
					FlxG.save.data.enablemissanimations = !FlxG.save.data.enablemissanimations;
					optionsText.text = FlxG.save.data.enablemissanimations;
				case "Bot Play":
					FlxG.save.data.botplay = !FlxG.save.data.botplay;
					optionsText.text = FlxG.save.data.botplay;
				case "Hit Sounds":
					FlxG.save.data.hitsounds = !FlxG.save.data.hitsounds;
					optionsText.text = FlxG.save.data.hitsounds;
				case "New Icons":
					FlxG.save.data.newicons = !FlxG.save.data.newicons;
					optionsText.text = FlxG.save.data.newicons;
				case "Info Bar BG":
					FlxG.save.data.infobarbg = !FlxG.save.data.infobarbg;
					optionsText.text = FlxG.save.data.infobarbg;
				case "Max Optimization":
					FlxG.save.data.maxoptimization = !FlxG.save.data.maxoptimization;
					optionsText.text = FlxG.save.data.maxoptimization;
				case "Middle Scroll":
					FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll;
					optionsText.text = FlxG.save.data.middlescroll;
				case "Charting Background":
					FlxG.save.data.chartingbackground = !FlxG.save.data.chartingbackground;
					optionsText.text = FlxG.save.data.chartingbackground;
				case "Change Note Theme":
					noteselection++;
					if (noteselection > notetypes.length - 1)
					{
						noteselection = 0;
					}
					FlxG.save.data.notetheme = notetypes[noteselection];
					if (FlxG.save.data.notetheme == "NOTE")
					{
						optionsText.text = "NOTE(DEFAULT)";
					}
					else
					{
						optionsText.text = FlxG.save.data.notetheme;
					}
					viewer.frames = Paths.getSparrowAtlas('notes/' + FlxG.save.data.notetheme + '_assets', 'shared');
					viewer.animation.addByPrefix('confirm', 'up confirm', 24, true);
					viewer.animation.play('confirm');
				//	trace(FlxG.save.data.notetheme);
				case "Customize Keybinds":
					OptionsMenu.instance.openSubState(new KeyBindMenu());
				case "Modifiers":
					FlxG.switchState(new ModifiersMenu());
				case "Customize Info Bar": // lol
					OptionsMenu.instance.openSubState(new InfoBarSubstate());
				case "Custom Scroll Speed":
					FlxG.save.data.customscrollspeed = 0;
					optionsText.text = "0";
				case "Custom Offset":
					FlxG.save.data.offset = 0;
					// haxe is monkey
					//FlxG.save.data.offset = Math.fround(FlxG.save.data.offset);
					optionsText.text = "0";
				case "Reset":
					reset();
			}
			//getOption(controlsStrings[curSelected].substring(3).split(" || ")[0]) = !getOption(controlsStrings[curSelected].substring(3).split(" || ")[0]);
			FlxG.save.flush();
			// this could be us but FlxG savedata sucks dick and im too lazy to see how kade engine did it
			//	FlxG.save.data[controlsStrings[curSelected].split(" || ")[1]] = !FlxG.save.data.options[controlsStrings[curSelected].split(" || ")[1]];
		}
		if (controls.LEFT_P) {
			switch (controlsStrings[curSelected].substring(3).split(" || ")[0]) {
				case "Custom Scroll Speed":
					if (FlxG.save.data.customscrollspeed > 0) {
						FlxG.save.data.customscrollspeed -= 1;
						optionsText.text = Std.string(FlxG.save.data.customscrollspeed / 10);
					}
				case "Custom Offset":
					FlxG.save.data.offset -= 1;
					// haxe is monkey
					//FlxG.save.data.offset = Math.fround(FlxG.save.data.offset);
					optionsText.text = Std.string(FlxG.save.data.offset / 10);
			}
		}
		if (controls.RIGHT_P) {
			switch (controlsStrings[curSelected].substring(3).split(" || ")[0]) {
				case "Custom Scroll Speed":
					FlxG.save.data.customscrollspeed += 1;
					optionsText.text = Std.string(FlxG.save.data.customscrollspeed / 10);
				case "Custom Offset":
					FlxG.save.data.offset += 1;
					// haxe is monkey
					//FlxG.save.data.offset = Math.fround(FlxG.save.data.offset);
					optionsText.text = Std.string(FlxG.save.data.offset / 10);
			}
		}
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
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
		viewer.visible = false;
		switch (controlsStrings[curSelected].substring(3).split(" || ")[0])
		{
			case "Ghost Tapping":
				optionsText.text = FlxG.save.data.ghosttapping;
			case "Downscroll":
				optionsText.text = FlxG.save.data.downscroll;
			case "Miss Shake":
				optionsText.text = FlxG.save.data.missshake;
			case "Dad Notes Visible":
				optionsText.text = FlxG.save.data.dadnotesvisible;
			case "Enable Miss Animations":
				optionsText.text = FlxG.save.data.enablemissanimations;
			case "Advanced Info Bar":
				optionsText.text = FlxG.save.data.advancedinfobar;
			case "Countdown After Pause":
				optionsText.text = FlxG.save.data.countdownafterpause;
			case "Bot Play":
				optionsText.text = FlxG.save.data.botplay;
			case "Hit Sounds":
				optionsText.text = FlxG.save.data.hitsounds;
			case "Max Optimization":
				optionsText.text = FlxG.save.data.maxoptimization;
			case "New Icons":
				optionsText.text = FlxG.save.data.newicons;
			case "Square Notes":
				optionsText.text = FlxG.save.data.squarenotes;
			case "Info Bar BG":
				optionsText.text = FlxG.save.data.infobarbg;
			case "Charting Background":
				optionsText.text = FlxG.save.data.chartingbackground;
			case "Change Note Theme":
				if (FlxG.save.data.notetheme == "NOTE")
				{
					optionsText.text = "NOTE(DEFAULT)";
				}
				else
				{
					optionsText.text = FlxG.save.data.notetheme;
				}
				viewer.visible = true;
				viewer.frames = Paths.getSparrowAtlas('notes/' + FlxG.save.data.notetheme + '_assets', 'shared');
				viewer.animation.addByPrefix('static', 'arrowUP', 24, true);
				viewer.animation.addByPrefix('confirm', 'up confirm', 24, false);
				viewer.animation.play('static');
			case "Customize Keybinds":
				optionsText.text = "Press ENTER";
			case "Custom Scroll Speed":
				optionsText.text = Std.string(FlxG.save.data.customscrollspeed / 10);
			default: // i am so lazy :LOOOOL I cant figure this out
				optionsText.text = "Press ENTER";
				optionsDesc.text = "Customize your info bar by adding modules.(WIP, DOES NOT WORK IF ADVANCED INFO TEXT IS OFF)";
			case "Middle Scroll":
				//FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll
				optionsText.text = FlxG.save.data.middlescroll;
			case "Custom Offset":
				optionsText.text = Std.string(FlxG.save.data.offset / 10);
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

	function reset() {
		
	}
}
