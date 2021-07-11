package;

import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxG;

class TapBPMState extends FlxState
{
    var funny:FlxText;
    var taps:Int;
    var seconds:Int;

    var prevtaps:Array<Int> = [];

    override public function create():Void
    {
        funny = new FlxText(0, 0, 0, "TAPS: None\nTIME: idk\nTPS: ", 20, true);
        add(funny);
        funny.screenCenter();

        var timer = new haxe.Timer(1000); // 1000ms delay
        timer.run = function() { 
            seconds++;
            prevtaps.push(taps);
            taps = 0;
         }
        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        if (FlxG.keys.justPressed.SPACE) {
            taps++;
        }
        var tps1 = 0;
        // THIS IS ELEMENTRAY SCHOOLS HTI
        for (i in 0...prevtaps.length) {
            tps1 = tps1 + prevtaps[i];
        }
        var tps = tps1/prevtaps.length; // the fact that i had to look this up
        var tpm = tps * 60;
        funny.text = "TAPS: " + taps + "\nTIME: " + seconds + "s\nTPM: " + tpm;
        super.update(elapsed);
    }
}