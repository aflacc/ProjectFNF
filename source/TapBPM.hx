package;

import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxG;

class TapBPMState extends FlxState
{
    var funny:FlxText;
    var taps:Int;

    override public function create():Void
    {
        funny = new FlxText(0, 0, 0, "TAPS: None", 20, true);
        add(funny);
        funny.screenCenter();

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        if (FlxG.keys.justPressed.SPACE) {
            taps++;
            funny.text = "TAPS: " + taps;
        }
        super.update(elapsed);
    }
}