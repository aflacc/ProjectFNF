import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class ModCharts
{
    static public var stickNotes:Bool = true;
    static public var dadNotesVisible:Bool = true;
    static public var bfNotesVisible:Bool = true;

    static public function quickSpin(sprite) {
        FlxTween.angle(sprite, 0, 360, 0.5, { type: FlxTween.ONESHOT, ease: FlxEase.quadInOut, startDelay: 0, loopDelay: 0 });
    }
    static public function circleLoop(sprite, rotateradius, speed) {
        FlxTween.circularMotion(sprite, sprite.x, sprite.y, rotateradius, 90, true, speed, {type: FlxTween.LOOPING});
    }
    static public function moveTo(sprite, x, y, duration) {
        FlxTween.linearMotion(sprite, sprite.x, sprite.y, x, y, duration, true, { type: FlxTween.ONESHOT, ease: FlxEase.quadInOut});
    }
    static public function bounceLoop(sprite, duration) {
        FlxTween.linearMotion(sprite, sprite.x, sprite.y, sprite.x, sprite.y - 50, duration, true, { type: FlxTween.PINGPONG});
    }
}