import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class ModCharts
{
    static public var stickNotes:Bool = true;
    static public function quickSpin(sprite) {
        FlxTween.angle(sprite, 0, 360, 0.5, { type: FlxTween.ONESHOT, ease: FlxEase.quadInOut, startDelay: 0, loopDelay: 0 });
    }
    static public function circleSprite(sprite, rotateradius, speed) {
        FlxTween.circularMotion(sprite, sprite.x, sprite.y, rotateradius, 90, true, speed, {type: FlxTween.LOOPING});
    }
}