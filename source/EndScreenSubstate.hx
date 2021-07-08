package;

import flixel.math.FlxMath;
import flixel.input.keyboard.FlxKey;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class EndScreenSubstate extends FlxSubState
{
    var totalAccuracy:Float;
    var songNotesHit:Float;
    var songNotesMissed:Float;
    var miss = 0;
	var shit = 0;
	var bad = 0;
	var good = 0;
	var sick = 0;
    var songScore:Int;
    var camHUD:Any;

	public function new(acccuracy:Float, notehit:Float, notemiss:Float, mis:Int, shi:Int, ba:Int, goo:Int, sic:Int, score:Int, cam:Any) // shiiii bro
	{
        // smol brain
        totalAccuracy = acccuracy;
        songNotesHit = notehit;
        songNotesMissed = notemiss;
        miss = mis;
        shit = shi;
        bad = ba;
        good = goo;
        sick = sic;
        songScore = score;
        camHUD = cam;

		super();
	}

    override public function create() {
        var blackBox:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);
		blackBox.alpha = 0;
		FlxTween.tween(blackBox, {alpha: 0.7}, 0.3, {ease: FlxEase.expoInOut});
		var stats = new FlxText(-100, -100, 0, "Stats: LOADING....");
		stats.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, LEFT);
		add(stats);
		// rating
		var accuracy = FlxMath.roundDecimal((totalAccuracy / (songNotesHit + songNotesMissed) * 100), 2);

		if (Math.isNaN(accuracy))
				{
					accuracy = 100;
				}
		
				// rating!!
				var rating = "??"; // incase it doesnt load or start idk
				if (accuracy == 100)
				{
					rating = "SFC";
				}
				else if (accuracy > 90)
				{
					rating = "S";
				}
				else if (accuracy > 80)
				{
					rating = "A";
				}
				else if (accuracy > 70)
				{
					rating = "B";
				}
				else if (accuracy > 60)
				{
					rating = "C";
				}
				else if (accuracy > 50)
				{
					rating = "D";
				}
				else if (accuracy > 30)
				{
					rating = "E";
				}
				else
				{
					rating = "F";
				}

				if (songNotesMissed == 0) {
					rating = rating + "(FC)";
				}

		stats.text = 'Overall Rating: ' + rating + '\n Accuracy: ' + accuracy + '%\n Sicks: ' + sick + '\n Goods:' + good + '\n Bads:' + bad + '\n Shits:' + shit + '\n Misses: ' + songNotesMissed + '\n Final Score: ' + songScore + '\n Press ENTER to continue.';
		stats.screenCenter();
    }

    override public function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ENTER) {
            close();
        }
        super.update(elapsed);
    }
}
