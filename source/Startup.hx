package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;

using StringTools;

class Startup extends MusicBeatState
{

    var splash:FlxSprite;
	
    var loadingText:FlxText;

	override function create()
	{

        FlxG.mouse.visible = false;

        splash = new FlxSprite(0, 0);
        splash.frames = FlxAtlasFrames.fromSparrow('assets/images/fpsPlus/RozeSplash.png', 'assets/images/fpsPlus/RozeSplash.xml');
        splash.animation.addByPrefix('start', 'Splash Start', 24, false);
        splash.animation.addByPrefix('end', 'Splash End', 24, false);
        add(splash);
        splash.animation.play("start");
        splash.updateHitbox();
        splash.screenCenter(X);

        loadingText = new FlxText(5, FlxG.height - 30, 0, "Preloading Assets...", 24);
        loadingText.setFormat("assets/fonts/vcr.ttf", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(loadingText);

        new FlxTimer().start(1.1, function(tmr:FlxTimer)
        {
            FlxG.sound.play("assets/sounds/splashSound.ogg");   
        });
        sys.thread.Thread.create(() -> {
            preload();
        });
        super.create();
        
    }

    override function update(elapsed) 
    {
        
      
       
         
        
        
        super.update(elapsed);

    }

    function preload(){
		var characters = [];
        var portraits = [];
        var music = [];
        
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
			{
				if (!i.endsWith(".png"))
					continue;
				characters.push(i);
			}
        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/dialogue/images/portrait")))
			{
				if (!i.endsWith(".png"))
					continue;
				portraits.push(i);
			}
        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
                {
                    music.push(i);
                }


        for (i in characters)
            {
                 var replaced = i.replace(".png","");
                 FlxG.bitmap.add(Paths.image("characters/" + replaced,"shared"), true);
                 trace("cached character " + replaced);
            }
        for (i in portraits)
            {
                 var replaced = i.replace(".png","");
                 FlxG.bitmap.add(Paths.image("portrait/" + replaced,"dialogue"), true);
                 trace("cached portrait " + replaced);
            }
        for (i in music)
            {
                FlxG.sound.cache(Paths.inst(i));
                FlxG.sound.cache(Paths.voices(i));
                trace("cached " + i);
               
            }
     
        loadingText.text = "Done!";
        FlxG.sound.play(Paths.sound('confirmMenu'));
        FlxG.switchState(new TitleState());
        

    }

}
