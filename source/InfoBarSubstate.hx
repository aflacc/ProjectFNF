package;

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

class InfoBarSubstate extends FlxSubState
{
    var blackBox:FlxSprite;
    var available:Array<String> = ["Rating", "Accuracy", "Score", "Misses", "Hits", "Health", "Week Score", "Accuracy Score", "Notes Judged", "Shits", "Bads", "Goods", "Sicks", "Reset"];
    var current:Array<String> = FlxG.save.data.infobar;
    var view:FlxText;
    var btns:FlxTypedGroup<FlxButton>;

	public function new()
	{
		super();
	}

    override public function create() {
        FlxG.mouse.visible = true;
        blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);
        var funny:FlxText = new FlxText(0, 0, 0, "Press ESCAPE to save and exit.", 20, true);
        add(funny);
        view = new FlxText(0, 0, 0, "Loading...", 20);
        add(view);
        view.screenCenter();
        btns = new FlxTypedGroup<FlxButton>();
        add(btns);
        blackBox.alpha = 0;
        funny.alpha = 0;
        view.alpha = 0;

        var amogus = 20;
        for (option in available) {
            var optionBtn = new FlxButton(amogus, 300, option, function() {addFeature(option);});
            optionBtn.scale.set(1, 2);
            btns.add(optionBtn);
            optionBtn.alpha = 0;
            FlxTween.tween(optionBtn, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
            amogus = amogus + 90;
        }

        FlxTween.tween(blackBox, {alpha: 0.7}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(funny, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(view, {alpha: 1}, 1, {ease: FlxEase.expoInOut});

        

        if (current == null) {
            current = ["Rating", "Misses", "Score", "Accuracy", "Health"];
            trace(save());
        }
        view.text = "Current Bar: " + current.toString();
        view.screenCenter();

        super.create();
    }

    override public function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ESCAPE) {
            exit();
        }

        super.update(elapsed);
    }

    function save() {
        FlxG.save.data.infobar = current;
        return current;
    }

    function exit() {
        FlxG.save.data.infobar = current;
        close();
    }

    function addFeature(feature):Void {
        if (feature == "Reset") {
            current = [];
        } else {
            current.push(feature);
        }
        save();
        view.text = "Current Bar:" + current.toString();
        view.screenCenter();
    }
}
