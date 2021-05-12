package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitGF:FlxSprite;
	var portraitBJ:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		box = new FlxSprite(0, 370);

		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'new-moves':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('banjo/banjoui/speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'Speech Bubble Normal Open', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
		}

		this.dialogueList = dialogueList;

		if (!hasDialog)
			return;

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.15));
		box.updateHitbox();
		add(box);

		portraitRight = new FlxSprite(60, 485);
		portraitRight.frames = Paths.getSparrowAtlas('banjo/bf_talking_sprites');
		portraitRight.animation.addByPrefix('enter', 'bf head dialouge', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.1));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		portraitRight.antialiasing = true;
		add(portraitRight);
		portraitRight.visible = false;

		portraitGF = new FlxSprite(120, 430);
		portraitGF.frames = Paths.getSparrowAtlas('banjo/Kazooie_sprites');
		portraitGF.animation.addByPrefix('enter', 'Kazooie dialouge', 50, true);
		portraitGF.setGraphicSize(Std.int(portraitGF.width * PlayState.daPixelZoom * 0.1));
		portraitGF.updateHitbox();
		portraitGF.scrollFactor.set();
		portraitGF.antialiasing = true;
		add(portraitGF);
		portraitGF.visible = false;

		portraitBJ = new FlxSprite(80, 460);
		portraitBJ.frames = Paths.getSparrowAtlas('banjo/banjo_talking');
		portraitBJ.animation.addByPrefix('enter', 'banjo dialogue', 50, true);
		portraitBJ.setGraphicSize(Std.int(portraitBJ.width * PlayState.daPixelZoom * 0.1));
		portraitBJ.updateHitbox();
		portraitBJ.scrollFactor.set();
		portraitBJ.antialiasing = true;
		add(portraitBJ);
		portraitBJ.visible = false;

		portraitLeft = new FlxSprite(100, 500);
		portraitLeft.frames = Paths.getSparrowAtlas('banjo/banjotooie');
		portraitLeft.animation.addByPrefix('enter', 'Kazooie dialouge', 10, false);
		portraitLeft.setGraphicSize(Std.int(portraitGF.width * PlayState.daPixelZoom * 0.1));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(282, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'CCComicrazy Regular';
		dropText.color = 0xFFD89494;

		swagDialogue = new FlxTypeText(300, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'CCComicrazy Regular';
		swagDialogue.color = 0xFFFFFFFF;
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueStarted == true)
		{
			remove(dialogue);

			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					new FlxTimer().start(0, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				portraitGF.visible = false;
				if (!portraitBJ.visible)
				{
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('eugh'), 0.6)];
					portraitBJ.visible = true;
					portraitBJ.animation.play('enter');
				}
			case 'bf':
				portraitBJ.visible = false;
				portraitGF.visible = false;
				if (!portraitRight.visible)
				{
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bf'), 0.6)];
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'gf':
				portraitBJ.visible = false;
				portraitRight.visible = false;
				if (!portraitGF.visible)
				{
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('kaz'), 0.6)];
					portraitGF.visible = true;
					portraitGF.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
