package;

import haxe.Timer;
import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import lime.utils.Assets;
import lime.app.Application;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState;

	var characterCol:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public static var carGf:Bool = Config.CONFIGGfCar; // Girlfriend in week 4 sits on car

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var player2Strums:FlxTypedGroup<FlxSprite>;

	private var strumming2:Array<Bool> = [false, false, false, false];

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;

	var health:Float; // modders: go to line 208 to set starting health (dont set to static)
	var maxHealth:Float = 2; // 100%
	var healthPercentage:Float;

	private var combo:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var block:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	public var songScore:Int = 0;
	public var songNotesMissed:Float = 0; // accurasy shit
	public var songNotesHit:Float = 0;
	var infoTxt:FlxText;
	var funnySexBox:FlxSprite;
	var timerTxt:FlxText;

	public var miss = 0;
	public var shit = 0;
	public var bad = 0;
	public var good = 0;
	public var sick = 0;

	public var totalAccuracy:Float = 0;
	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	var inCutscene:Bool = false;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var endingSong = false;

	// modcharting

	var modcharting:Bool = false;
	var modchart:String;

	var lastModchart:Bool = false;

	var step:Int = 0;

	function sustain2(strum:Int, spr:FlxSprite, note:Note):Void
	{
		var length:Float = note.sustainLength;

		if (length > 0)
		{
			strumming2[strum] = true;
		}

		var bps:Float = Conductor.bpm / 60;
		var spb:Float = 1 / bps;

		if (!note.isSustainNote)
		{
			new FlxTimer().start(length == 0 ? 0.2 : (length / Conductor.crochet * spb) + 0.1, function(tmr:FlxTimer)
			{
				if (!strumming2[strum])
				{
					spr.animation.play("static", true);
				}
				else if (length > 0)
				{
					strumming2[strum] = false;
					spr.animation.play("static", true);
				}
			});
		}
	}

	var usingCustomScrollSpeed:Bool = false;

	override public function create()
	{
		// modchartz
		try {
			modchart = Assets.getText(Paths.mc(SONG.song.toLowerCase() + '/' + SONG.song.toLowerCase()).trim());
			modcharting = true;
		} catch(err) {
			trace("no modchart poops cutely");
			modcharting = false;
		}

		// scrollspeed
		if (FlxG.save.data.customscrollspeed > 0) {
			usingCustomScrollSpeed = true;
		}
		health = FlxG.save.data.nohealthgain == 0 ? 1 : FlxG.save.data.nohealthgain * 0.02;
		var stageCurtains:FlxSprite;
		var stageFront:FlxSprite;
		var bg:FlxSprite;
		// dis shit can be changed
		ModCharts.dadNotesVisible = FlxG.save.data.dadnotesvisible; // gamer
		ModCharts.bfNotesVisible = FlxG.save.data.bfnotesvisible;
		ModCharts.dadNotesDoDamage = FlxG.save.data.dadnotesdodamage;
		ModCharts.dadNotesCanKill = FlxG.save.data.dadnotescankill;
		ModCharts.damageFromDadNotes = FlxG.save.data.damagefromdadnotes / 10 * 0.02;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
		}

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'bf':
				iconRPC = 'bf';
			case 'gf':
				iconRPC = 'gf';
			case 'spooky':
				iconRPC = 'spooky';
			case 'pico':
				iconRPC = 'pico';
			case 'senpai':
				iconRPC = 'senpai';
			case 'senpai-angry':
				iconRPC = 'senpaipissed';
			case 'monster-christmas':
				iconRPC = 'lemon';
			case 'monster':
				iconRPC = 'lemon';
			case 'mom-car':
				iconRPC = 'mom';
			case 'mom':
				iconRPC = 'mom';
			case 'dad':
				iconRPC = 'dad';
			case 'parents-christmas':
				iconRPC = 'mom_and_dad';
			case 'spirit':
				iconRPC = 'spirit';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: " + SONG.song;
		}
		else
		{
			detailsText = "Free Play: " + SONG.song;
		}

		// String for when the game is paused
		detailsPausedText = "Paused on " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, "Version " + Application.current.meta.get('version'), iconRPC);
		#end

	if (!FlxG.save.data.maxoptimization) {
		switch (SONG.song.toLowerCase())
		{
			case 'spookeez' | 'monster' | 'south':
				{
					curStage = 'spooky';
					halloweenLevel = true;

					var hallowTex = Paths.getSparrowAtlas('halloween_bg');

					halloweenBG = new FlxSprite(-200, -100);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
					halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
					halloweenBG.animation.play('idle');
					halloweenBG.antialiasing = true;
					add(halloweenBG);

					isHalloween = true;
				}
			case 'pico' | 'blammed' | 'philly':
				{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					add(phillyCityLights);

					for (i in 0...5)
					{
						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = true;
						phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
					add(phillyTrain);

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
					add(street);
				}
			case 'milf' | 'satin-panties' | 'high':
				{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
					// add(limo);
				}
			case 'cocoa' | 'eggnog':
				{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = true;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					add(upperBoppers);

					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
					bgEscalator.antialiasing = true;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
					tree.antialiasing = true;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = true;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					add(bottomBoppers);

					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
					fgSnow.active = false;
					fgSnow.antialiasing = true;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = true;
					add(santa);
				}
			case 'winter-horrorland':
				{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
					evilTree.antialiasing = true;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
					evilSnow.antialiasing = true;
					add(evilSnow);
				}
			case 'senpai' | 'roses':
				{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (SONG.song.toLowerCase() == 'roses')
					{
						bgGirls.getScared();
					}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					add(bgGirls);
				}
			case 'thorns':
				{
					curStage = 'schoolEvil';

					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);
				}
			default:
				{
					{
						curStage = 'stage';
						bg = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

						stageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);

						stageCurtains = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;

						add(stageCurtains);
					}
				}
		}
	}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				if (carGf == true)
				{
					gfVersion = 'gf-limo'; // vroom
				}
				else
					gfVersion = 'gf-car';

			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
		}

		if (curStage == 'limo')
			if (carGf == true)
			{
				gfVersion = 'gf-limo'; // vroom
			}
			else
				gfVersion = 'gf-car';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico' | 'bf' | 'bf-pixel':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				if (carGf == true) // Zoom
				{
					gf.y += 80;
					gf.x += 80;
					gf.scale.x -= 0.1;
					gf.scale.y -= 0.1;
					gf.scrollFactor.set(0.4, 0.4);
				}
				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// var noteevilTrail = new FlxTrail(FlxCamera, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}

		add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		// add(ModCharts.addTrailToSprite(dad));
		add(boyfriend);

		if (FlxG.save.data.maxoptimization) {
			dad.visible = false;
			boyfriend.visible = false;
			gf.visible = false;
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (FlxG.save.data.downscroll) {
			strumLine.y = FlxG.height - 165;
		}

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		player2Strums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(!FlxG.save.data.quaverbar ? 0 : FlxG.width, !FlxG.save.data.quaverbar ? FlxG.height * 0.88 : 0).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll) {
			healthBarBG.y = 50;
		}
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);
		if (FlxG.save.data.quaverbar) {
			healthBarBG.angle = 90;
		}
		trace("QUAVERBAR: " + FlxG.save.data.quaverbar);

		if (FlxG.save.data.quaverbar) {
			healthBarBG.x = -290;
			healthBarBG.y = 340;
		}
		healthBar = new FlxBar(FlxG.save.data.quaverbar ? 5 : healthBarBG.x + 4, !FlxG.save.data.quaverbar ? healthBarBG.y + 4 : 53, !FlxG.save.data.quaverbar ? RIGHT_TO_LEFT : BOTTOM_TO_TOP, !FlxG.save.data.quaverbar ? Std.int(healthBarBG.width - 8) : Std.int(healthBarBG.height - 8), !FlxG.save.data.quaverbar ? Std.int(healthBarBG.height - 8) : Std.int(healthBarBG.width - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		var curcol:FlxColor = Config.col[characterCol.indexOf(dad.curCharacter)]; // Dad Icon
		var curcol2:FlxColor = Config.col[characterCol.indexOf(boyfriend.curCharacter)]; // Bf Icon
		healthBar.createFilledBar(curcol, curcol2); // Use those colors
		// healthBar
		add(healthBar);
		// i hate my fucking life
		funnySexBox = new FlxSprite(healthBarBG.x + healthBarBG.width - 545, healthBarBG.y + 55).makeGraphic(500, 20, FlxColor.BLACK);
		funnySexBox.alpha = (FlxG.save.data.infobarbg ? 0.3 : 0); // i really like this feature c:
		add(funnySexBox);
		funnySexBox.cameras = [camHUD]; // hopefully this works lol
		infoTxt = new FlxText(healthBarBG.x + healthBarBG.width - 610, healthBarBG.y + 55, 0, "", 20);
		infoTxt.bold = true;
		infoTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		infoTxt.borderColor = FlxColor.BLACK;
		infoTxt.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 1, 1);
		add(infoTxt);
		updateInfo();
		add(timerTxt);
		funnySexBox.scale.x = infoTxt.fieldWidth;
		if (FlxG.save.data.quaverbar) {
			infoTxt.y = 10;
			funnySexBox.y = 10;
		}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);
		iconP1.visible = FlxG.save.data.icons;

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);
		iconP2.visible = FlxG.save.data.icons;

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		infoTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case "monster":
					var whiteScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 10), Std.int(FlxG.height * 10), FlxColor.WHITE);
					add(whiteScreen);
					whiteScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(whiteScreen);
						FlxG.sound.play(Paths.sound('BIGTHUNDER'));
						camFollow.y = boyfriend.y - 200;
						camFollow.x = boyfriend.x;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 2.7;
						boyfriend.playAnim('scared', true);
						gf.playAnim('scared', true);

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(whiteScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixelevil',
				'weeb/pixelUI/set-pixelevil',
				'weeb/pixelUI/date-pixelevil' // scary o-o
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					if (SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.play(Paths.sound('intro3-pixelevil'), 0.6);
					else
					{
						if (SONG.song.toLowerCase() == 'senpai' || SONG.song.toLowerCase() == 'roses')
							FlxG.sound.play(Paths.sound('intro3-pixel'), 0.6);
						else
							FlxG.sound.play(Paths.sound('intro3'), 0.6);
					}
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					if (SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.play(Paths.sound('intro2-pixelevil'), 0.6);
					else
					{
						if (SONG.song.toLowerCase() == 'senpai' || SONG.song.toLowerCase() == 'roses')
							FlxG.sound.play(Paths.sound('intro2-pixel'), 0.6);
						else
							FlxG.sound.play(Paths.sound('intro2'), 0.6);
					}
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					if (SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.play(Paths.sound('intro1-pixelevil'), 0.6);
					else
					{
						if (SONG.song.toLowerCase() == 'senpai' || SONG.song.toLowerCase() == 'roses')
							FlxG.sound.play(Paths.sound('intro1-pixel'), 0.6);
						else
							FlxG.sound.play(Paths.sound('intro1'), 0.6);
					}
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					if (SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.play(Paths.sound('introGo-pixelevil'), 0.6);
					else
					{
						if (SONG.song.toLowerCase() == 'senpai' || SONG.song.toLowerCase() == 'roses')
							FlxG.sound.play(Paths.sound('introGo-pixel'), 0.6);
						else
						{
							FlxG.sound.play(Paths.sound('introGo'), 0.6);
							gf.playAnim('cheer', true);
						};
					}
				case 4:
					// modchart shit
				/*	for (note in 0...strumLineNotes.members.length) {
						ModCharts.circleLoop(strumLineNotes.members[note], 100, 3);
				  }*/

				// making sure i got kade engine to work correctly lol
					//ModCharts.tweenCameraAngle(180, 1, FlxG.camera);
				case 5:
					sectionHit();

			}
			swagCounter += 1;
			// generateSong('fresh');
		}, 6);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		if (isStoryMode)
			{
				detailsText = "Story Mode: " + SONG.song;
			}
			else
			{
				detailsText = "Free Play: " + SONG.song;
			}

			// String for when the game is paused
			detailsPausedText = "Paused on " + detailsText;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, "Version " + Application.current.meta.get('version'), iconRPC, true, songLength);
		updateLoop();
		#end
	}

	function updateLoop()
	{
		#if desktop
		var timer = Timer.delay(function()
		{
			if (isStoryMode)
				{
					detailsText = "Story Mode: " + SONG.song;
				}
				else
				{
					detailsText = "Free Play: " + SONG.song;
				}

				// String for when the game is paused
				detailsPausedText = "Paused on " + detailsText;

			DiscordClient.changePresence(detailsText, "Version " + Application.current.meta.get('version'),
				iconRPC);
			updateLoop();
		}, 5000);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				//trace("STRUM TIME WITHOUT: " + songNotes[0])
				//trace("STRUM TIME WITH: " + FlxG.save.data.offset)
				var daStrumTime:Float = songNotes[0] + (FlxG.save.data.offset / 10);
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

//				trace("NOTE TYPE: " + songNotes[3]);
				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, songNotes[3]);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);
				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			//if (!FlxG.save.data.squarenotes) {
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/notes/' + FlxG.save.data.notetheme + '-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}

				default:
					babyArrow.frames = Paths.getSparrowAtlas('notes/' + FlxG.save.data.notetheme + '_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					babyArrow.updateHitbox();

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
			}
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode == true || curSong == 'bopeebo' || curSong == 'tutorial' || curSong == 'spookeez' || curSong == 'pico'
				|| curSong == 'satin-panties' || curSong == 'cocoa' || curSong == 'senpai') // Just play the intro anim for JUST the first song in a week. I think theres a better way to do it tho.
			{
				babyArrow.y -= 20;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 20, alpha: 1}, 1, {ease: FlxEase.smoothStepInOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				player2Strums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			if (FlxG.save.data.middlescroll) {
				babyArrow.x -= 275;
				if (player != 1) {
					babyArrow.visible = false;
				}
			}

			strumLineNotes.add(babyArrow);
			ModCharts.quickSpin(babyArrow);
		}
		for (note in 0...strumLineNotes.members.length)
		{
			if (player == 1 && note >= 4)
			{
				if (!ModCharts.bfNotesVisible)
				{
					strumLineNotes.members[note].visible = false;
				}
			}
			else if (!ModCharts.dadNotesVisible)
			{
				strumLineNotes.members[note].visible = false;
			}
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.smoothStepInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{

			// ITS 1:49 AM IOM SO FIUCKING TIREEDDD
			if (FlxG.sound.music != null && !startingSong)
				{
					resyncVocals();
				}

				if (!startTimer.finished)
					startTimer.active = true;
				paused = false;

			#if desktop
			if (isStoryMode)
				{
					detailsText = "Story Mode: " + SONG.song;
				}
				else
				{
					detailsText = "Free Play: " + SONG.song;
				}

				// String for when the game is paused
				detailsPausedText = "Paused on " + detailsText;

			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, "Version " + Application.current.meta.get('version'));
			}
			else
			{
				DiscordClient.changePresence(detailsText, "Version " + Application.current.meta.get('version'), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (isStoryMode)
				{
					detailsText = "Story Mode: " + SONG.song;
				}
				else
				{
					detailsText = "Free Play: " + SONG.song;
				}

				// String for when the game is paused
				detailsPausedText = "Paused on " + detailsText;


			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, "Version " + Application.current.meta.get('version'));
			}
			else
			{
				DiscordClient.changePresence(detailsText, "Version " + Application.current.meta.get('version'), iconRPC);
			}
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (isStoryMode)
				{
					detailsText = "Story Mode: " + SONG.song;
				}
				else
				{
					detailsText = "Free Play: " + SONG.song;
				}

				// String for when the game is paused
				detailsPausedText = "Paused on " + detailsText;

			DiscordClient.changePresence(detailsPausedText, "Version " + Application.current.meta.get('version'), iconRPC);
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var fullClearFormat = new FlxTextFormat(FlxColor.CYAN);
	var sFormat = new FlxTextFormat(FlxColor.MAGENTA);
	var aFormat = new FlxTextFormat(FlxColor.LIME);
	var bFormat = new FlxTextFormat(FlxColor.GREEN);
	var cFormat = new FlxTextFormat(FlxColor.YELLOW);
	var dFormat = new FlxTextFormat(FlxColor.ORANGE);
	var eFormat = new FlxTextFormat(FlxColor.BLUE);
	var fFormat = new FlxTextFormat(FlxColor.PURPLE);
	var fcFormat = new FlxTextFormat(FlxColor.fromRGB(255, 252, 97));

	function updateInfo() {
		// accuracy!!
		//var accuracy = FlxMath.roundDecimal((songNotesHit / (songNotesHit + songNotesMissed) * 100), 2);
		var accuracy = FlxMath.roundDecimal((totalAccuracy / (songNotesHit + songNotesMissed) * 100), 2);
		healthPercentage = FlxMath.roundDecimal((health / 0.02), 0) > (maxHealth / 0.02) ? (maxHealth / 0.02) : FlxMath.roundDecimal((health / 0.02), 0);

		if (Math.isNaN(accuracy))
				{
					accuracy = 100;
				}

				// rating!!
				var rating = "??"; // incase it doesnt load or start idk
				if (accuracy == 100)
				{
					rating = "!SFC!";
				}
				else if (accuracy > 90)
				{
					rating = "<S<";
				}
				else if (accuracy > 80)
				{
					rating = "@A@";
				}
				else if (accuracy > 70)
				{
					rating = "#B#";
				}
				else if (accuracy > 60)
				{
					rating = "$C$";
				}
				else if (accuracy > 50)
				{
					rating = "*D*";
				}
				else if (accuracy > 30)
				{
					rating = "^E^";
				}
				else
				{
					rating = "&F&";
				}

				if (songNotesMissed == 0) {
					rating = rating + "(>FC>)";
				}

				if (FlxG.save.data.botplay) {
					infoTxt.text = "BOTPLAY // ProjectFNF " + Application.current.meta.get('version');
				} else if (!FlxG.save.data.advancedinfobar) {
						infoTxt.text = "Misses: " + songNotesMissed + " // Health: " + healthPercentage + "% // Score: " + songScore + " // ProjectFNF " + Application.current.meta.get('version');
					//	infoTxt.updateHitbox();
				} else {
					// the things i do for funny colors
					var finalthing = "";
					var haxewantsthis:Array<String> = FlxG.save.data.infobar;
					if (haxewantsthis == null) {
						haxewantsthis = [];
					}
					for (item in haxewantsthis) {
						var lol:Any = "ERROR";
						switch(item) {
							case "Rating":
								lol = rating;
							case "Accuracy":
								lol = accuracy + "%";
							case "Score":
								lol = songScore;
							case "Misses":
								lol = songNotesMissed;
							case "Hits":
								lol = songNotesHit;
							case "Health":
								lol = healthPercentage;
							case "Week Score":
								lol = campaignScore;
							case "Shits":
								lol = Std.string(shit);
							case "Bads":
								lol = Std.string(bad);
							case "Goods":
								lol = Std.string(good);
							case "Sicks":
								lol = Std.string(sick);
							case "Accuracy Score":
								lol = totalAccuracy;
							case "Notes Judged":
								lol = songNotesHit + songNotesMissed;
						}
						finalthing += item + ": " + lol + " // ";
					}
					infoTxt.applyMarkup(finalthing + "ProjectFNF " + Application.current.meta.get('version'),
						[
							new FlxTextFormatMarkerPair(fullClearFormat, "!"),
							new FlxTextFormatMarkerPair(sFormat, "<"),
							new FlxTextFormatMarkerPair(aFormat, "@"),
							new FlxTextFormatMarkerPair(bFormat, "#"),
							new FlxTextFormatMarkerPair(cFormat, "$"),
							new FlxTextFormatMarkerPair(dFormat, "*"),
							new FlxTextFormatMarkerPair(eFormat, "^"),
							new FlxTextFormatMarkerPair(fFormat, "&"),
							new FlxTextFormatMarkerPair(fcFormat, ">")
						]);
					}
					// How did i not think of this earlier LOL
					infoTxt.screenCenter(X);
	}
	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER && endingSong) {
			nextSong();
		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				var detailsPausedText = "Paused on " + SONG.song;

			#if desktop
			DiscordClient.changePresence(detailsPausedText, "Version " + Application.current.meta.get('version'), iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", "Version " + Application.current.meta.get('version'), null, true);
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		// if this works like the other things i will laugh so fucking hard

		if (FlxG.save.data.quaverbar) {
			iconP1.x = healthBar.x;
			iconP1.y = healthBar.y + (healthBar.height * (FlxMath.remapToRange(healthPercentage, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x;
			iconP2.y = healthBar.y + (healthBar.height * (FlxMath.remapToRange(healthPercentage, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		} else {
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthPercentage, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthPercentage, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}
		if (health > maxHealth)
			health = maxHealth;

		if (healthPercentage < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthPercentage > 80)
		{
			iconP2.animation.curAnim.curFrame = 1;
			iconP1.animation.curAnim.curFrame = 3;
		}
		else if (healthPercentage < 20)
			iconP2.animation.curAnim.curFrame = 3;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			// health = 0;
			trace("[ProjectFNF] Reset player");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();
			FlxG.camera.shake(0.08, 0.1, null, true, XY);
			if (SONG.song.toLowerCase() == 'tutorial')
				trace('[ProjectFNF] how tf did you die on tutorial');
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, "Version " + Application.current.meta.get('version'), iconRPC);
			#end
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if (ModCharts.autoStrum && startedCountdown && !inCutscene)
			{ // sex
				strumLine.y = strumLineNotes.members[Std.int(ModCharts.autoStrumNum)].y;
			}
			if (ModCharts.updateNoteVisibilty)
			{
				for (note in 0...strumLineNotes.members.length)
				{
					if (note >= 4)
					{
						strumLineNotes.members[note].visible = ModCharts.bfNotesVisible;
					}
					else
					{
						strumLineNotes.members[note].visible = ModCharts.dadNotesVisible;
					}
				}
			}
			notes.forEachAlive(function(daNote:Note)
			{
				// THIS SUCKS (slightly less) DICK (than before)
				if (ModCharts.stickNotes == true)
				{
					var noteNum:Int = 0;
					if (daNote.mustPress)
					{
						noteNum += 4; // set to bfs notes instead
					}
					noteNum += daNote.noteData;
					if (!ModCharts.dadNotesVisible && !daNote.mustPress)
					{
						daNote.visible = false;
					}
					if (!ModCharts.bfNotesVisible && daNote.mustPress)
					{
						daNote.visible = false;
					}
					//daNote.x = strumLineNotes.members[noteNum].x;
				}

				if (daNote.tooLate)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					// mag not be retarded challange(failed instantly)
					if (daNote.mustPress)
					{
						daNote.visible = ModCharts.bfNotesVisible;
						daNote.active = true;
					}
					else
					{
						daNote.visible = ModCharts.dadNotesVisible;
						daNote.active = true;
					}
				}

				if (FlxG.save.data.downscroll)
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal( !usingCustomScrollSpeed ? SONG.speed : FlxG.save.data.customscrollspeed / 10, 2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal( !usingCustomScrollSpeed ? SONG.speed : FlxG.save.data.customscrollspeed / 10, 2));
						if(daNote.isSustainNote)
						{
							// Remember = minus makes notes go up, plus makes them go down
							if (!FlxG.save.data.squarenotes) {
							if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
								daNote.y += daNote.prevNote.height;
							else
								daNote.y += daNote.height / 2;
							}
								if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
									swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
						}
					}else
					{
						if (daNote.mustPress)
							daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(!usingCustomScrollSpeed ? SONG.speed : FlxG.save.data.customscrollspeed / 10, 2));
						else
							daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal( !usingCustomScrollSpeed ? SONG.speed : FlxG.save.data.customscrollspeed / 10, 2));
						if(daNote.isSustainNote)
						{
							daNote.y -= daNote.height / 2;

								if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
								{
									// Clip to strumline
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
						}
					}


				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

					switch (Math.abs(daNote.noteData))
					{
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
					}
					player2Strums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(daNote.noteData) == spr.ID)
						{
							spr.animation.play('confirm');
							sustain2(spr.ID, spr, daNote);
						}
					});
					if (ModCharts.dadNotesDoDamage) {
						if (!(health - ModCharts.damageFromDadNotes < 0.001)) {
							health -= ModCharts.damageFromDadNotes;
							updateInfo();
						} else {
							if (ModCharts.dadNotesCanKill) {
								health -= ModCharts.damageFromDadNotes;
							}
						}
					}

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				player2Strums.forEach(function(spr:FlxSprite)
				{
					if (strumming2[spr.ID])
					{
						spr.animation.play("confirm");
					}

					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
				if (daNote.mustPress)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote) {
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
							if (daNote.nType == 1) {
								daNote.x -= 130;
								daNote.y -= 60;
							}
						} else {
							daNote.x += 35;
						}
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote) {
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
							if (daNote.nType == 1) {
								daNote.x -= 130;
								daNote.y -= 60;
							}
						} else {
							daNote.x += 35;
						}
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				if ((daNote.mustPress && daNote.tooLate && !FlxG.save.data.downscroll || daNote.mustPress && daNote.tooLate && FlxG.save.data.downscroll) && daNote.mustPress)
					{
							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
							}
							else
							{
								if (daNote.nType != 1) {
									health -= 0.075;

									if (!daNote.isSustainNote) {
										songNotesMissed++;
									}
									trace(daNote.nType);
									vocals.volume = 0;
									if (theFunne)
										trace("nut initiated");
										noteMiss(daNote.noteData, daNote, true);
									updateInfo();
								}
							}

							daNote.visible = false;
							daNote.kill();
							notes.remove(daNote, true);
						}
			});
		}

		if (!inCutscene) // why does this look so confusing
			if (!boyfriend.stunned)
				keyShit();
			else if (!FlxG.save.data.stunsblockinputs) // not fucking up again LMAO
				keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	public function nextSong():Void {
		if (isStoryMode)
			{
				campaignScore += songScore;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					FlxG.switchState(new StoryMenuState());

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					trace('[ProjectFNF] Loading song ' + SONG.song.toLowerCase());
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					if (SONG.song.toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}
					if (SONG.song.toLowerCase() == 'south')
					{
						var whiteShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 100, FlxG.height * 100, FlxColor.WHITE);
						whiteShit.scrollFactor.set();
						add(whiteShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('thunder_2'));
					}

					if (SONG.song.toLowerCase() == 'south' || SONG.song.toLowerCase() == 'eggnog')
					{
						FlxTransitionableState.skipNextTransIn = false;
						FlxTransitionableState.skipNextTransOut = false;
					}
					else
					{
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
					}
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				trace('[ProjectFNF] Returned to Freeplay');
				FlxG.switchState(new FreeplayState());
			}
	}

	public function endSong():Void
	{
		trace("Song1");
/*openSubState(new EndScreenSubstate(totalAccuracy, songNotesHit, songNotesMissed, miss, shit, bad, good, sick, songScore, camHUD));
		persistentUpdate = false;
		persistentDraw = false;*/
		canPause = false;
		paused = true;
		inCutscene = true;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			trace("Song2");
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

        var blackBox:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);
		blackBox.alpha = 0;
		FlxTween.tween(blackBox, {alpha: 0.7}, 0.3, {ease: FlxEase.expoInOut});
		blackBox.cameras = [camHUD];
		trace("Song3");
		var stats = new FlxText(-100, -100, 0, "Stats: LOADING....");
		stats.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, LEFT);
		add(stats);
		// rating
		var accuracy = FlxMath.roundDecimal((totalAccuracy / (songNotesHit + songNotesMissed) * 100), 2);

		trace("Song4");
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

		trace("Song4.5");
		stats.text = 'Overall Rating: ' + rating + '\n Accuracy: ' + accuracy + '%\n Sicks: ' + sick + '\n Goods:' + good + '\n Bads:' + bad + '\n Shits:' + shit + '\n Misses: ' + songNotesMissed + '\n Final Score: ' + songScore + '\n Press ENTER to continue.';
		stats.screenCenter();
		stats.cameras = [camHUD];
		trace("Song5");

		// transferring to next song(or back to menu)
		endingSong = true;
		trace("SONG6???");
	}

	private function popUpScore(strumtime:Float):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 500; // hehe

		var daRating:String = "";

		daRating = Ratings.CalculateRating(noteDiff);
		score = 100; // till i stop being a lazy cunt
		switch(daRating) {
			case "miss":
				songNotesMissed++;
				totalAccuracy += 0;
				score = -100;
				trace("miss added");
			case "shit":
				shit++;
				totalAccuracy += 3 / 10; // absolute dogshit
				score = -50;
				//trace("shit added");
			case "bad":
				bad++;
				totalAccuracy += 5 / 10; // ass. 50%
				score = 30;
				//trace("bad added");
			case "good":
				good++;
				totalAccuracy += 9 / 10; // u aight
				score = 100;
			//	trace("good added");
			case "sick":
				sick++;
				totalAccuracy += 1; // swag shit homie
				score = 200;
				//trace("sick added");
			default:
				trace("oop");
		}

		// idk hopefully this works
		if (totalAccuracy > (songNotesMissed + songNotesHit)) {
			totalAccuracy = (songNotesMissed + songNotesHit);
		}
		/*if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'shit';
			score = 50;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'bad';
			score = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			daRating = 'good';
			score = 200;
		}*/

		songScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		var comboSplit:Array<String> = (combo + "").split('');

		if (comboSplit.length == 2)
			seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

		for(i in 0...comboSplit.length)
		{
			var str:String = comboSplit[i];
			seperatedScore.push(Std.parseInt(str));
		}

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/*
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];
		// FlxG.watch.addQuick('asdfa', upP);
	if (generatedMusic) {
		if ((upP || rightP || downP || leftP) || FlxG.save.data.botplay)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				//if (perfectMode)
				//noteCheck(true, daNote);
				//goodNoteHit(daNote);

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (controlArray[coolNote.noteData] || FlxG.save.data.botplay)
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (controlArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!inIgnoreList)
									badNoteCheck(coolNote);
							}
					}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(controlArray[daNote.noteData], daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(controlArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					noteCheck(controlArray[daNote.noteData], daNote);
				}
				/*
					if (controlArray[daNote.noteData])
						goodNoteHit(daNote);
				 */
				// trace(daNote.noteData);
				/*
						switch (daNote.noteData)
						{
							case 2: // NOTES YOU JUST PRESSED
								if (upP || rightP || downP || leftP)
									noteCheck(upP, daNote);
							case 3:
								if (upP || rightP || downP || leftP)
									noteCheck(rightP, daNote);
							case 1:
								if (upP || rightP || downP || leftP)
									noteCheck(downP, daNote);
							case 0:
								if (upP || rightP || downP || leftP)
									noteCheck(leftP, daNote);
						}
					//this is already done in noteCheck / goodNoteHit
					if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				 */
				}
			else
			{
				badNoteCheck("none");
			}
		}
	}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
					{
						if (FlxG.save.data.botplay) {

						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 0:
								goodNoteHit(daNote);
							case 1:
								goodNoteHit(daNote);
							case 2:
								goodNoteHit(daNote);
							case 3:
								goodNoteHit(daNote);
						}
					} else {
					if (up || right || down || left) {
							switch (daNote.noteData)
							{
								// NOTES YOU ARE HOLDING
								case 0:
									if (left)
										goodNoteHit(daNote);
								case 1:
									if (down)
										goodNoteHit(daNote);
								case 2:
									if (up)
										goodNoteHit(daNote);
								case 3:
									if (right)
										goodNoteHit(daNote);
							}
				}
			}
					}
				});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}
		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (!FlxG.save.data.botplay) {
			switch (spr.ID)
			{
				case 0:
					if (leftP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (leftR)
						spr.animation.play('static');
				case 1:
					if (downP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (downR)
						spr.animation.play('static');
				case 2:
					if (upP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (upR)
						spr.animation.play('static');
				case 3:
					if (rightP && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (rightR)
						spr.animation.play('static');
			}
		} else {
			if (strumming2[spr.ID])
			{
				spr.animation.play("confirm");
			}
		}
		try {
		if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
		{
			spr.centerOffsets();
			spr.offset.x -= 13;
			spr.offset.y -= 13;
		}
		else {
			spr.centerOffsets();
		}
		} catch(e) {
			trace("oh shit daddy~ smtn went wrong uwu~ lil fucky wucky teehee~");
		}
		});
	}

	function noteMiss(direction:Int = 1, note:Note, fromfall:Bool = false):Void
		{
			trace("BALLS");
		//	trace(boyfriend.stunned);
			try {
				if (note.nType == 1) { return; }
			} catch (e) {
				trace("idk smtn");
			}
			trace(FlxG.save.data.ghosttapping);
			trace(boyfriend.stunned);
			if (!FlxG.save.data.ghosttapping) {
			if (!boyfriend.stunned)
			{
				trace('balls');
				health -= 0.04;
				if (combo > 5 && gf.animOffsets.exists('sad'))
				{
					gf.playAnim('sad');
				}
				combo = 0;
				if (!note.isSustainNote)
					songNotesMissed++;
				trace("Misse added at notemiss");

				//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
				//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

				songScore -= 10;

				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
				// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
				// FlxG.log.add('played imss note');

				boyfriend.stunned = true;
							// get stunned for 5 seconds
				new FlxTimer().start(5, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});

				if (FlxG.save.data.enablemissanimations) {
				switch (direction)
				{
					case 0:
						boyfriend.playAnim('singLEFTmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
					case 1:
						boyfriend.playAnim('singDOWNmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
					case 2:
						boyfriend.playAnim('singUPmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
					case 3:
						boyfriend.playAnim('singRIGHTmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
				}
			}
			updateInfo();
			}
		} else {
			if (fromfall && !boyfriend.stunned) {
				boyfriend.stunned = true;
							// get stunned for 5 seconds
				new FlxTimer().start(5, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});
			}
			if (FlxG.save.data.enablemissanimations) {
				switch (direction)
				{
					case 0:
						boyfriend.playAnim('singLEFTmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
					case 1:
						boyfriend.playAnim('singDOWNmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
					case 2:
						boyfriend.playAnim('singUPmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
					case 3:
						boyfriend.playAnim('singRIGHTmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
				}
			}
		}
		}


/*	function noteMiss(direction:Int = 1):Void
	{
		if (FlxG.save.data.ghosttapping == false)
		{
			songNotesMissed += 1;

			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
					if (Config.MISSFX = true)
						FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
					if (Config.MISSFX = true)
						FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, Y);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
					if (Config.MISSFX = true)
						FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, Y);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
					if (Config.MISSFX = true)
						FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
			}
		}
	}*/

	function badNoteCheck(note:Any)
	{
		// its 5 am lol
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		if (FlxG.save.data.botplay)
			return; // sike

		// SEXY FAILSAFE (THANKS VM U A REAL ONE)
		if (note == 'none') {
			if (FlxG.save.data.ghosttapping) {
			if (FlxG.save.data.enablemissanimations) { // indenting worked out in the end *holds hands with family*
				if (leftP) {
					boyfriend.playAnim('singLEFTmiss', true);
					if (FlxG.save.data.missshake)
						FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
				}
				if (downP) {
					boyfriend.playAnim('singDOWNmiss', true);
					if (FlxG.save.data.missshake)
						FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
				}
				if (upP) {
					boyfriend.playAnim('singUPmiss', true);
					if (FlxG.save.data.missshake)
						FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
				}
				if (rightP) {
					boyfriend.playAnim('singRIGHTmiss', true);
					if (FlxG.save.data.missshake)
						FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
				}
			}
			} else { // ehh fuck it
				health -= 0.04;
				if (combo > 5 && gf.animOffsets.exists('sad'))
				{
					gf.playAnim('sad');
				}
				combo = 0;
				songNotesMissed++;

				songScore -= 10;

				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));

				boyfriend.stunned = true;
							// get stunned for 5 seconds
				new FlxTimer().start(5, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});
				if (FlxG.save.data.enablemissanimations) { // indenting worked out in the end *holds hands with family*
					if (leftP) {
						boyfriend.playAnim('singLEFTmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
					}
					if (downP) {
						boyfriend.playAnim('singDOWNmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
					}
					if (upP) {
						boyfriend.playAnim('singUPmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
					}
					if (rightP) {
						boyfriend.playAnim('singRIGHTmiss', true);
						if (FlxG.save.data.missshake)
							FlxG.camera.shake(Config.MISSINTENSITY, 0.1, null, true, X);
					}
			updateInfo();
			}
		}
			return;
		}

		if (leftP)
			noteMiss(0, note);
		if (downP)
			noteMiss(1, note);
		if (upP)
			noteMiss(2, note);
		if (rightP)
			noteMiss(3, note);
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
			if (keyP || FlxG.save.data.botplay)
				goodNoteHit(note);
			else
			{
				badNoteCheck(note);
			}
			if (note.nType != 1 && !note.isSustainNote) {
				trace("note shit OWO");
				songNotesHit += 1;
			}
			if (FlxG.save.data.hitsounds) {
				//trace("ayo ima play hitsound ahahah");
				FlxG.sound.play(Paths.sound("hitsound"), 0.5);
			}
	}

	function goodNoteHit(note:Note):Void
	{
		if (note.nType == 1) {
			if (FlxG.save.data.botplay)
				return;
			trace("FIRE NOTE OH SHTIT");
			health -= 1;
		}
			if (!note.wasGoodHit)
			{
				if (!note.isSustainNote)
				{
					popUpScore(note.strumTime);
					combo += 1;
				}

				if (note.noteData >= 0)
				{
					if (FlxG.save.data.nohealthgain == 0)
						health += FlxG.save.data.hardmode ? 0.007 : 0.023;
					if (combo == 10 || combo == 50 || combo == 100 || combo == 200 || combo == 300)
						gf.playAnim('cheer', true);
				}
				else
				{
					if (FlxG.save.data.nohealthgain == 0)
						health += 0.004;
					if (combo == 10 || combo == 50 || combo == 100 || combo == 200 || combo == 300)
						gf.playAnim('cheer', true);
				}

				switch (note.noteData)
				{
					case 0:
						boyfriend.playAnim('singLEFT', true);
					case 1:
						boyfriend.playAnim('singDOWN', true);
					case 2:
						boyfriend.playAnim('singUP', true);
					case 3:
						boyfriend.playAnim('singRIGHT', true);
				}

				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						spr.animation.play('confirm', true);
					}
				});

				note.wasGoodHit = true;
				vocals.volume = 1;

				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
			}
			updateInfo();
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if (!FlxG.save.data.maxoptimization) {
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{if (!FlxG.save.data.maxoptimization) {
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
			camera.shake(0.002, 0.1, null, true, X);
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}


	function lightningStrikeShit():Void
	{
		if (!FlxG.save.data.maxoptimization) {
			FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
			halloweenBG.animation.play('lightning');
			camera.shake(0.003, 2.3, null, true, Y);

			lightningStrikeBeat = curBeat;
			lightningOffset = FlxG.random.int(8, 24);

			boyfriend.playAnim('scared', true);
			gf.playAnim('scared', true);
		}
	}


	/**
	* Runs every section. Used for modcharting but will work for everything
	**/
	function sectionHit() {
		// shiet modchart code but it doesnt run often so it should be fine
		// bandaid
		try {
		if (SONG.notes[Math.floor(curStep / 16)].cameracancel) {
			ModCharts.cancelCamera(FlxG.camera);
			ModCharts.tweenCameraAngle(0, 1, FlxG.camera);
		}

		if (SONG.notes[Math.floor(curStep / 16)].camerabounce) {
			ModCharts.cameraBounce(camGame, Conductor.crochet / 1000, 200);
		}

		if (SONG.notes[Math.floor(curStep / 16)].cameraflip) {
			ModCharts.tweenCameraAngle(180, 1, FlxG.camera);
		}

		if (SONG.notes[Math.floor(curStep / 16)].cancel) {
			lastModchart = false;
			for (note in 0...strumLineNotes.members.length) {
				ModCharts.cancelMovement(strumLineNotes.members[note]);
				if (strumLineNotes.members[note].alpha != 1) {
					ModCharts.fadeInObject(strumLineNotes.members[note]);
				}
			}
		}
		if (SONG.notes[Math.floor(curStep / 16)].fadein) {
			lastModchart = false;
			for (note in 0...strumLineNotes.members.length) {
				ModCharts.fadeInObject(strumLineNotes.members[note]);
			}
		}
			if (SONG.notes[Math.floor(curStep / 16)].circle) {
				FlxG.log.add("Circle is true");
					FlxG.log.add("Starting circle");
					lastModchart = true;
					for (note in 0...strumLineNotes.members.length) {
						ModCharts.circleLoop(strumLineNotes.members[note], 100, 3);
					}
			}
			if (SONG.notes[Math.floor(curStep / 16)].fadeout) {
					lastModchart = true;
					for (note in 0...strumLineNotes.members.length) {
						ModCharts.fadeOutObject(strumLineNotes.members[note]);
					}
			}
			 if (SONG.notes[Math.floor(curStep / 16)].bounce) {
					lastModchart = true;
					strumLineNotes.forEach(function(note)
					{
						ModCharts.bounceLoop(note, Conductor.crochet / 1000);
					});
			}
		} catch(err) {
			trace("TRIED TO RUN CHART AT END OF SONG???");
		}
	}
	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20 && !paused)
		{
			resyncVocals();
		}

		step++;
		if (step > 15) {
			sectionHit();
			step = 0;
		}
		// might represent steps?
		// this is shitty but im tired

		//if (SONG.notes[Math.floor(curStep / 16)].circle) {
		//	for (note in 0...strumLineNotes.members.length) {
		//		ModCharts.circleLoop(strumLineNotes.members[note], 100, 3);
		//	}
		//}
		// modcharting
		if (modcharting) {
			// i doubt its this easy
		//	trace(modchart);
			//trace(PlayState.instance.strumLineNotes.getFirstAlive().x);
			var parser = new hscript.Parser();
			var ast = parser.parseString(modchart);
			var interp = new hscript.Interp();
			interp.variables.set("stepping", true);
			interp.variables.set("beatShit", curBeat);
			interp.variables.set("stepShit", curStep);
			interp.variables.set("ModCharts", ModCharts);
			interp.variables.set("game", PlayState.instance);
			interp.variables.set("strumLineNotes", strumLineNotes);
			interp.variables.set("strumLineNotes", strumLineNotes);
			interp.variables.set("playerStrums", playerStrums);
			interp.variables.set("player2Strums", player2Strums);
			interp.variables.set("dad", dad);
			interp.variables.set("boyfriend", boyfriend);
			interp.variables.set("gf", gf);
			interp.variables.set("notes", notes);
			interp.variables.set("mainCamera", FlxG.camera);
			interp.variables.set("camHUD", camHUD);
			interp.variables.set("iconP1", iconP1);
			interp.variables.set("iconP2", iconP2);
			interp.variables.set("assets", Assets);
			// shit i *cough* stole *cough* borrowed.
			interp.variables.set("FlxSprite", flixel.FlxSprite);
			interp.variables.set("FlxTimer", FlxTimer);
			interp.variables.set("Math", Math);
			interp.variables.set("Std", Std);
			interp.variables.set("FlxTween", FlxTween);
			interp.variables.set("FlxText", FlxText);

			interp.execute(ast);
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

				// modcharting
				if (modcharting) {
					// i doubt its this easy
				//	trace(modchart);
					var parser = new hscript.Parser();
					var ast = parser.parseString(modchart);
					var interp = new hscript.Interp();
					interp.variables.set("stepping", false);
					interp.variables.set("beatShit", curBeat);
					interp.variables.set("stepShit", curStep);
					interp.variables.set("ModCharts", ModCharts);

					// i hate my life
					interp.variables.set("strumLineNotes", strumLineNotes);
					interp.variables.set("strumLineNotes", strumLineNotes);
					interp.variables.set("playerStrums", playerStrums);
					interp.variables.set("player2Strums", player2Strums);
					interp.variables.set("dad", dad);
					interp.variables.set("boyfriend", boyfriend);
					interp.variables.set("gf", gf);
					interp.variables.set("notes", notes);
					interp.variables.set("mainCamera", FlxG.camera);
					interp.variables.set("camHUD", camHUD);
					interp.variables.set("iconP1", iconP1);
					interp.variables.set("iconP2", iconP2);
					interp.variables.set("assets", Assets);
					// shit i *cough* stole *cough*
					interp.variables.set("FlxSprite", flixel.FlxSprite);
					interp.variables.set("FlxTimer", FlxTimer);
					interp.variables.set("Math", Math);
					interp.variables.set("Std", Std);
					interp.variables.set("FlxTween", FlxTween);
					interp.variables.set("FlxText", FlxText);
					interp.execute(ast);
				}

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (!FlxG.save.data.maxoptimization) {
		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			// idk im lazy asf
			strumLineNotes.forEach(function(note)
			{
				ModCharts.quickSpin(note);
			});
			boyfriend.playAnim('hey', true);
			gf.playAnim('cheer', true);
		}
		if (SONG.song.toLowerCase() == "cocoa")
			switch (curBeat)
			{
				case 31 | 47 | 63 | 143:
					gf.playAnim('cheer', true);
				case 180:
					boyfriend.playAnim('hey', true);
			}
		if (curBeat == 47 && curSong == 'Spookeez')
		{
			gf.playAnim('cheer', true);
		}
		if (curBeat == 15 && curSong == 'Fresh')
			gf.playAnim('cheer', true);
		if (curBeat == 159 && curSong == 'Fresh')
			gf.playAnim('cheer', true);

		if (curBeat == 77 || curBeat == 95 || curBeat == 105 || curBeat == 110 || curBeat == 127 || curBeat == 150) // Scary lemon scares the bitchass female
			if (curSong == 'Monster')
				gf.playAnim('scared', true);
		if (curBeat == 195 || curBeat == 138 || curBeat == 232 || curBeat == 248 || curBeat == 312)
			if (curSong == 'Monster')
				boyfriend.playAnim('hey', true);
		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}
		if (SONG.song.toLowerCase() == 'thorns')
		{
			switch (curBeat)
			{
				case 94:
					ModCharts.circleLoop(dad, 50, 7);
					strumLineNotes.forEach(function(note)
					{
						ModCharts.quickSpin(note);
					});
				case 160:
					ModCharts.cancelMovement(dad);
				case 320:
					strumLineNotes.forEach(function(note)
					{
						ModCharts.quickSpin(note);
					});
					ModCharts.fadeOutObject(dad);
			}
		}
		if (!FlxG.save.data.maxoptimization) {
		switch (curStage)
		{
			case 'school':
				bgGirls.dance();
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(20) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}
		}
	}
	var curLight:Int = 0;
}
