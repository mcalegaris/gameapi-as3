package Playtomic.LeaderboardsAPI{
	
	import flash.net.URLLoader;
	import Playtomic.PlayerScore;
	
	public class responseData{
		
		private var data:XML;
		public var status:int;
		public var errorcode:int;
		public var numscores:int;
		public var results:Array = new Array();
		
		public var rank:int;//only in SaveAndList
		
		public function responseData(loader:URLLoader):void{ //parse the listed scores
			data = XML(loader["data"]);
			status = parseInt(data["status"]);
			errorcode = parseInt(data["errorcode"]);
			numscores = parseInt(data["numscores"]);
			rank = parseInt(data["rank"]);
			
			if(status == 1)
			{
				var entries:XMLList = data["score"];
				var datestring:String;
				var year:int;
				var month:int;
				var day:int;
							
				for each(var item:XML in entries) 
				{
					datestring = item["sdate"];				
					year = int(datestring.substring(datestring.lastIndexOf("/") + 1));
					month = int(datestring.substring(0, datestring.indexOf("/")));
					day = int(datestring.substring(datestring.indexOf("/" ) +1).substring(0, 2));
					
					var aScore:PlayerScore = new PlayerScore();
					aScore.SDate = new Date(year, month-1, day);
					aScore.RDate = item["rdate"];
					aScore.Name = item["name"];
					aScore.Points = item["points"];
					aScore.Website = item["website"];
					
					if(item["fbuserid"]) aScore.FBUserId = item["fbuserid"];
					
					if(item["custom"])
					{			
						var custom:XMLList = item["custom"];
						
						for each(var cfield:XML in custom.children())
						{
							aScore.CustomData[cfield.name()] = cfield.text();
						}
					}
					
					results.push(aScore);
				}
			}
		}
	}
}