import flixel.FlxG;

// YOU CAN IGNORE THIS
class ProjectFNF
{
	/**
	* Simple helper function to update all options to prevent crashes. ngl you could probably run this every frame :troll:
	**/
	static public function updateOptions() {
		FlxG.save.bind('savedata', 'ProjectFNF');
		trace(FlxG.save.data.quaverbar);
		var controlsStrings = CoolUtil.coolTextFile(Paths.txt('options'));

		// modifiers
		if (FlxG.save.data.dadnotesdodamage == null)
			FlxG.save.data.dadnotesdodamage = false;
		if (FlxG.save.data.dadnotescankill == null)
			FlxG.save.data.dadnotescankill = false;
		if (FlxG.save.data.damagefromdadnotes == null)
			FlxG.save.data.damagefromdadnotes = 10;
		if (FlxG.save.data.nohealthgain == null)
			FlxG.save.data.nohealthgain = 0;
		if (FlxG.save.data.dadnotesvisible == null)
			FlxG.save.data.dadnotesvisible = true;
		if (FlxG.save.data.bfnotesvisible == null)
			FlxG.save.data.bfnotesvisible = true;
		if (FlxG.save.data.stunsblockinputs == null)
			FlxG.save.data.stunsblockinputs = false;
		if (FlxG.save.data.infobar == null)
			FlxG.save.data.infobar = [];

		var curSelected = 1;
		for (i in 0...controlsStrings.length)
		{
			curSelected = i;
			// not modifiers
			if (FlxG.save.data.ghosttapping == null) {
				trace("Some data's null around here :nerd:");
				FlxG.save.data.ghosttapping = controlsStrings[curSelected].split(" || ")[2];
			}
			if (FlxG.save.data.downscroll == null)
				FlxG.save.data.downscroll = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.missshake == null)
				FlxG.save.data.missshake = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.dadnotesvisible == null)
				FlxG.save.data.dadnotesvisible = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.enablemissanimations == null)
				FlxG.save.data.enablemissanimations = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.squarenotes == null)
				FlxG.save.data.squarenotes = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.advancedinfobar == null)
				FlxG.save.data.advancedinfobar = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.botplay == null)
				FlxG.save.data.botplay = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.icons == null)
				FlxG.save.data.icons = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.hitsounds == null)
				FlxG.save.data.hitsounds = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.infobarbg == null)
				FlxG.save.data.infobarbg = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.countdownafterpause == null)
				FlxG.save.data.countdownafterpause = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.customscrollspeed == null)
				FlxG.save.data.customscrollspeed = 0;
			if (FlxG.save.data.notetheme == null)
				FlxG.save.data.notetheme = "NOTE";
			if (FlxG.save.data.maxoptimization == null)
				FlxG.save.data.maxoptimization = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.hardmode == null)
				FlxG.save.data.hardmode = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.quaverbar == null)
				FlxG.save.data.quaverbar = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.middlescroll == null)
				FlxG.save.data.middlescroll = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.chartingbackground == null)
				FlxG.save.data.chartingbackground = controlsStrings[curSelected].split(" || ")[2];
			if (FlxG.save.data.offset == null)
				FlxG.save.data.offset = 0;
		}
		FlxG.save.flush();
	}
}
