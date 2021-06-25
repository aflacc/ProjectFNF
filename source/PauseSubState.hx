package;

import flixel.util.FlxTimer;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
using StringTools;

class PauseSubState extends MusicBeatSubstate
{
	var canSkipSong:Bool = true; // adds a skip button to the pause menu

	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Charting Menu', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	var bg:FlxSprite;
	var levelDifficulty:FlxText;
	var levelInfo:FlxText;
	var closed:Bool = false;

	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		levelInfo = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		levelDifficulty = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					if (FlxG.save.data.countdownafterpause && !closed) {
					var swagCounter = 0;
					closed = true;
					// I HAD TO DO IT HERE THE WHOLE TIME IMA KMS
					var sussyTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
						{
							// chefs kiss
							bg.visible = false;
							grpMenuShit.visible = false;
							levelInfo.visible = false;
							levelDifficulty.visible = false;
							
							var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
							introAssets.set('default', ['ready', "set", "go"]);
							introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
							introAssets.set('schoolEvil', [
								'weeb/pixelUI/ready-pixelevil',
								'weeb/pixelUI/set-pixelevil',
								'weeb/pixelUI/date-pixelevil' // scary o-o
							]);
				
							var introAlts:Array<String> = introAssets.get('default');
							var altSuffix:String = "";
				
							for (value in introAssets.keys())
							{
								if (value == PlayState.curStage)
								{
									introAlts = introAssets.get(value);
									altSuffix = '-pixel';
								}
							}
				
							switch (swagCounter)
							{
								case 0:
									if (PlayState.SONG.song.toLowerCase() == 'thorns')
										FlxG.sound.play(Paths.sound('intro3-pixelevil'), 0.6);
									else
									{
										if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses')
											FlxG.sound.play(Paths.sound('intro3-pixel'), 0.6);
										else
											FlxG.sound.play(Paths.sound('intro3'), 0.6);
									}
								case 1:
									var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
									ready.scrollFactor.set();
									ready.updateHitbox();
				
									if (PlayState.curStage.startsWith('school'))
										ready.setGraphicSize(Std.int(ready.width * PlayState.daPixelZoom));
				
									ready.screenCenter();
									add(ready);
									FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
										ease: FlxEase.cubeInOut,
										onComplete: function(twn:FlxTween)
										{
											ready.destroy();
										}
									});
									if (PlayState.SONG.song.toLowerCase() == 'thorns')
										FlxG.sound.play(Paths.sound('intro2-pixelevil'), 0.6);
									else
									{
										if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses')
											FlxG.sound.play(Paths.sound('intro2-pixel'), 0.6);
										else
											FlxG.sound.play(Paths.sound('intro2'), 0.6);
									}
								case 2:
									var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
									set.scrollFactor.set();
				
									if (PlayState.curStage.startsWith('school'))
										set.setGraphicSize(Std.int(set.width * PlayState.daPixelZoom));
				
									set.screenCenter();
									add(set);
									FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
										ease: FlxEase.cubeInOut,
										onComplete: function(twn:FlxTween)
										{
											set.destroy();
										}
									});
									if (PlayState.SONG.song.toLowerCase() == 'thorns')
										FlxG.sound.play(Paths.sound('intro1-pixelevil'), 0.6);
									else
									{
										if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses')
											FlxG.sound.play(Paths.sound('intro1-pixel'), 0.6);
										else
											FlxG.sound.play(Paths.sound('intro1'), 0.6);
									}
								case 3:
									var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
									go.scrollFactor.set();
				
									if (PlayState.curStage.startsWith('school'))
										go.setGraphicSize(Std.int(go.width * PlayState.daPixelZoom));
				
									go.updateHitbox();
				
									go.screenCenter();
									add(go);
									FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
										ease: FlxEase.cubeInOut,
										onComplete: function(twn:FlxTween)
										{
											go.destroy();
										}
									});
									if (PlayState.SONG.song.toLowerCase() == 'thorns')
										FlxG.sound.play(Paths.sound('introGo-pixelevil'), 0.6);
									else
									{
										if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses')
											FlxG.sound.play(Paths.sound('introGo-pixel'), 0.6);
										else
										{
											FlxG.sound.play(Paths.sound('introGo'), 0.6);
										};
									}
								case 4:
									close();
							}
							swagCounter += 1;
							// generateSong('fresh');
						}, 5);
					} else {
							close();
						}
				case "Restart Song":
					FlxG.resetState();
				case "Exit to menu":
					FlxG.switchState(new MainMenuState());
				case "Charting Menu":
					FlxG.switchState(new ChartingState());
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
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
