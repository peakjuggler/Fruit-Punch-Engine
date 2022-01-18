package;

#if windows
import Sys.sleep;
import discord_rpc.DiscordRpc;

using StringTools;

class DiscordClient
{
	public function new()
	{
		trace("Fruit Punch Discord Flavor is Mixing...");
		DiscordRpc.start({
			clientID: "932842439809568798", // change this to what ever the fuck you want lol
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Fruit Punch Discord Flavor has been Mixed!");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
			//trace("Discord Client Update");
		}

		DiscordRpc.shutdown();
	}

	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}

	static function onReady()
	{
		DiscordRpc.presence({
			details: "MAIN MENU",
			state: null,
			largeImageKey: 'fruitpunchlogo',
			largeImageText: "frootpunch"
		});
	}

	static function onError(_code:Int, _message:String)
	{
		trace('you fucked something up! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('lmao connect to the internet! $_code : $_message');
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Fruit Punch has been Mixed");
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}
	//booty me down pls -Breezys IRL friend 
	// hi breezys friend
		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'fruitpunchlogo',
			largeImageText: "frootpunch",
			smallImageKey : smallImageKey,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp : Std.int(startTimestamp / 1000),
            endTimestamp : Std.int(endTimestamp / 1000)
		});

		//trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');
	}
}
#end
