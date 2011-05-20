package Playtomic.type{
	public class ERROR{
		//http://playtomic.com/api/as3#ErrorCodes
		public static function descriptionByCode(code:int):String{
			return description[code];
		}
		private static const description:Object = new Object();
		//General Errors
		description[0] = "No error";
		description[1] = "General error, this typically means the player is unable to connect to the Playtomic servers";
		description[2] = "Invalid game credentials. Make sure you use your SWFID and GUID from the `API` section in the dashboard.";
		
		//GeoIP Errors
		description[100] = "GeoIP API has been disabled. This may occur if your game is faulty or overwhelming the Playtomic servers.";
		
		//Leaderboard Errors
		description[200] = "Leaderboard API has been disabled. This may occur if your game is faulty or overwhelming the Playtomic servers.";
		description[201] = "The source URL or name weren't provided when saving a score. Make sure the player specifies a name and the game is initialized before anything else using the code in the `Set your game up` section.";
		description[202] = "Invalid auth key. You should not see this normally, players might if they tamper with your game.";
		description[203] = "No Facebook user id on a score specified as a Facebook submission.";
		
		//GameVars Errors
		description[300] = "GameVars API has been disabled. This may occur if your game is faulty or overwhelming the Playtomic servers.";
		
		//LevelSharing Errors
		description[400] = "Level sharing API has been disabled. This may occur if your game is faulty or overwhelming the Playtomic servers.";
		description[401] = "Invalid rating value (must be 1 - 10).";
		description[402] = "Player has already rated that level.";
		description[403] = "The level name wasn't provided when saving a level.";
		description[404] = "Invalid image auth. You should not see this normally, players might if they tamper with your game.";
		description[405] = "Invalid image auth (again). You should not see this normally, players might if they tamper with your game.";
		
		//Data API Errors
		description[500] = "Data API has been disabled. This may occur if the Data API is not enabled for your game, or your game is faulty or overwhelming the Playtomic servers.";
	}
}