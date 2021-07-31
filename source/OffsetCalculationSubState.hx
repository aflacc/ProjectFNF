package;

import haxe.Timer;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxG;

/**
    * Pretty much a clone of tapbpmstate lolol
**/
class OffsetCalculationSubState extends FlxSubState
{
    var funny:FlxText;
    var offset:Float;
    var miniseconds:Int;
    var seconds:Int;
    var prevoffsets:Array<Float> = [];
    var blackBox:FlxSprite;
    public var saving = true;
    var started = false;
    var timer:Timer;
    public function new()
    {
        super();
    }

    override public function create():Void
    {
        FlxG.fixedTimestep = false;
        FlxG.sound.music.stop();
        blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);
        funny = new FlxText(0, 0, 0, "Press SPACE to start", 20, true);
        add(funny);
        funny.screenCenter();
        blackBox.alpha = 0;
        funny.alpha = 0;
        FlxTween.tween(blackBox, {alpha: 0.7}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(funny, {alpha: 1}, 1, {ease: FlxEase.expoInOut});

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
     //   trace(started);
        if (FlxG.keys.justPressed.SPACE) {
            if (!started) {
                started = true;
                timer = new haxe.Timer(1); // 1ms delay
                timer.run = function() { 
                    miniseconds += 1; // lol
                    if (miniseconds == 100) {
                        miniseconds = 0;
                        seconds++;
                        FlxG.sound.play(Paths.sound('hitsound', 'shared'), 0.5);
                    }
                }
            } else {
                prevoffsets.push((100 - miniseconds) / 10);
                var of1:Float = 0;
                for (i in 0...prevoffsets.length) {
                    of1 = of1 + prevoffsets[i];
                }
                offset = of1/prevoffsets.length;
            }
        }

        if (FlxG.keys.justPressed.ESCAPE) {
            timer.run = function() {

            }
            close();
        }
        if (FlxG.keys.justPressed.ENTER) {
            timer.run = function() {
                
            }
            FlxG.save.data.offset = offset;
            close();
        }
        
        if (started)
            funny.text = "OFFSET:" + offset + "\nMINISECONDS:" + miniseconds + "\nSECONDS:" + seconds + "\nPress SPACE and tap to the beat!\nPress ESCAPE to exit. \n Press ENTER to update offset and exit.";
        super.update(elapsed);
    }
}