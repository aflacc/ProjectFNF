package;

import flixel.text.FlxText;
import Sys.sleep;
import discord_rpc.DiscordRpc;

using StringTools;

class DiscordClient
{
	public static var rpc:Array<String> = [
		"among us", "Now with 10% more issues!", "Did I leave the stove on?", "I am spain without the P", "Subscribe to aflac", "Now lactose free!",
		"I'm wanted for several accounts of homicide and murder!", "Swear Word!", "That would be your mother!", "Wait why is this here again?",
		"AAAAAAAAAAAAAAAAAAA", "I have flooded your room with a lethal neurotoxin", ":troll:", "When the", "hello", "ur stinky"
	];

	public function new()
	{
		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: "826545851395866645",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});

		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
			// trace("Discord Client Update");
		}

		DiscordRpc.shutdown();
	}

	static function onReady()
	{
		var rpcsplash:String = rpc[Math.floor(Math.random() * rpc.length)];
		DiscordRpc.presence({
			details: "Launching the Game...",
			state: null,
			largeImageKey: 'icon',
			largeImageText: Config.ModName,
			smallImageText: rpcsplash
		});
	}

	static function onError(_code:Int, _message:String)
	{
		trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Disconnected! $_code : $_message');
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Discord Client initialized");
	}

	public static var rpcsplash:String = rpc[Math.floor(Math.random() * rpc.length)];

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
	{
		var startTimestamp:Float = if (hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: Config.ModName,
			smallImageKey: smallImageKey,
			smallImageText: rpcsplash,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp: Std.int(startTimestamp / 1000),
			endTimestamp: Std.int(endTimestamp / 1000)
		});

		// trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');
	}
}
