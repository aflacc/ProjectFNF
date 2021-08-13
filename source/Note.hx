package;

import flixel.FlxG;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSkewedSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var nType:Int = 0;
	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, type:Int = 0)
	{
		super();
		nType = type;
		
		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

	//	trace("Type == " + type);
		if (type == 1) { //????
			frames = Paths.getSparrowAtlas('notes/ALL_deathnotes');
			animation.addByPrefix('greenScroll', 'Green Arrow', 30, false);
			animation.addByPrefix('redScroll', 'Red Arrow', 30, false);
			animation.addByPrefix('blueScroll', 'Blue Arrow', 30, false);
			animation.addByPrefix('purpleScroll', 'Purple Arrow', 30, false);
			setGraphicSize(Std.int(width * 0.6));
			updateHitbox();
			antialiasing = true;
			//animation.play('redScroll', true);
		} else {
			if (!FlxG.save.data.squarenotes) {
			switch (daStage)
			{
				case 'school' | 'schoolEvil':
					try {
						loadGraphic(Paths.image('weeb/pixelUI/notes/' + FlxG.save.data.notetheme + '-pixels'), true, 17, 17);
					} catch(err) {
						trace("No pixel theme found");
						loadGraphic(Paths.image('weeb/pixelUI/notes/NOTE-pixels'), true, 17, 17);
					}
					animation.add('greenScroll', [6]);
					animation.add('redScroll', [7]);
					animation.add('blueScroll', [5]);
					animation.add('purpleScroll', [4]);

					if (isSustainNote)
					{
						loadGraphic(Paths.image('weeb/pixelUI/notes/arrowEnds' /*forgot notes oops*/), true, 7, 6);

						animation.add('purpleholdend', [4]);
						animation.add('greenholdend', [6]);
						animation.add('redholdend', [7]);
						animation.add('blueholdend', [5]);

						animation.add('purplehold', [0]);
						animation.add('greenhold', [2]);
						animation.add('redhold', [3]);
						animation.add('bluehold', [1]);
					}

					setGraphicSize(Std.int(width * PlayState.daPixelZoom));
					updateHitbox();

				default:
					frames = Paths.getSparrowAtlas('notes/' + FlxG.save.data.notetheme + '_assets');

					animation.addByPrefix('greenScroll', 'green0');
					animation.addByPrefix('redScroll', 'red0');
					animation.addByPrefix('blueScroll', 'blue0');
					animation.addByPrefix('purpleScroll', 'purple0');

					animation.addByPrefix('purpleholdend', 'pruple end hold');
					animation.addByPrefix('greenholdend', 'green hold end');
					animation.addByPrefix('redholdend', 'red hold end');
					animation.addByPrefix('blueholdend', 'blue hold end');

					animation.addByPrefix('purplehold', 'purple hold piece');
					animation.addByPrefix('greenhold', 'green hold piece');
					animation.addByPrefix('redhold', 'red hold piece');
					animation.addByPrefix('bluehold', 'blue hold piece');

					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();
					antialiasing = true;
			}
		}
		}
		if (FlxG.save.data.squarenotes) {
			setGraphicSize(Std.int(width * 0.7));
			if (!isSustainNote) 
				switch (noteData)
				{
					case 0:
						x += swagWidth * 0;
						makeGraphic(100, 100, 0xFFFFFFFF);
						color = FlxColor.PURPLE;
					case 1:
						x += swagWidth * 1;
						makeGraphic(100, 100, 0xFFFFFFFF);
						color = FlxColor.BLUE;
					case 2:
						x += swagWidth * 2;
						makeGraphic(100, 100, 0xFFFFFFFF);
						color = FlxColor.GREEN;
					case 3:
						x += swagWidth * 3;
						makeGraphic(100, 100, 0xFFFFFFFF);
						color = FlxColor.RED;
				}

		/*	switch (noteData)
			{
				x += swagWidth * 0;

			}*/
		} else {
			switch (noteData)
			{
				case 0:
					x += swagWidth * 0;
					animation.play('purpleScroll');
				case 1:
					x += swagWidth * 1;
					animation.play('blueScroll');
				case 2:
					x += swagWidth * 2;
					animation.play('greenScroll');
				case 3:
					x += swagWidth * 3;
					animation.play('redScroll');
			}
	}

		// trace(prevNote);
		if (FlxG.save.data.downscroll && sustainNote) {
			flipY = true;
		}

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			if (FlxG.save.data.squarenotes) {
				switch (noteData)
				{
					case 0:
						x += swagWidth * 0;
						makeGraphic(30, 50, 0xFFFFFFFF);
						color = FlxColor.PURPLE;
					case 1:
						x += swagWidth * 1;
						makeGraphic(30, 50, 0xFFFFFFFF);
						color = FlxColor.BLUE;
					case 2:
						x += swagWidth * 2;
						makeGraphic(30, 50, 0xFFFFFFFF);
						color = FlxColor.GREEN;
					case 3:
						x += swagWidth * 3;
						makeGraphic(30, 50, 0xFFFFFFFF);
						color = FlxColor.RED;
				}
			} else {
				switch (noteData)
				{
					case 2:
						animation.play('greenholdend');
					case 3:
						animation.play('redholdend');
					case 1:
						animation.play('blueholdend');
					case 0:
						animation.play('purpleholdend');
				}
			}
			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			if (isSustainNote)
			{
			if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		} else {
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
				canBeHit = true;
			else
				canBeHit = false;
		}

		if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset * Conductor.timeScale && !wasGoodHit)
			tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
