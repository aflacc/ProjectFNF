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

class TapBPMSubState extends FlxSubState
{
    var funny:FlxText;
    var taps:Int;
    var seconds:Int;
    public var tpm:Float;
    var prevtaps:Array<Int> = [];
    var blackBox:FlxSprite;
    var songName = "test";
    public var saving = true;
    var started = false;
    var timer:Timer;
    public function new(song:String, camHUD:FlxCamera)
    {
        super();
        cameras = [camHUD];
        songName = song;
    }

    override public function create():Void
    {
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
                FlxG.sound.playMusic(Paths.inst(songName.toLowerCase()), 0.6);
                taps++;
                timer = new haxe.Timer(1000); // 1000ms delay
                timer.run = function() { 
                    seconds++;
                    prevtaps.push(taps);
                    taps = 0;
                }
                FlxG.sound.play(Paths.sound('hitsound'), 0.5);
            } else {
                taps++;
                FlxG.sound.play(Paths.sound('hitsound'), 0.5);
            }
        }
        if (FlxG.keys.justPressed.ESCAPE) {
            saving = false;
            close();
        }
        if (FlxG.keys.justPressed.ENTER) {
            saving = true;
            close();
        }
        var tps1 = 0;
        // THIS IS ELEMENTRAY SCHOOLS HTI
        for (i in 0...prevtaps.length) {
            tps1 = tps1 + prevtaps[i];
        }
        var tps = tps1/prevtaps.length; // the fact that i had to look this up
        tpm = tps * 60;
        if (started)
            funny.text = "TAPS: " + taps + "\nTIME: " + seconds + "s\nBPM: " + tpm + "\nPress SPACE and tap to the beat!\nPress ESCAPE to exit. \n Press ENTER to update Song BPM and exit.";
        super.update(elapsed);
    }
}