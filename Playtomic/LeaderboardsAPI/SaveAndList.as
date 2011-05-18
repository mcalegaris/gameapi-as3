package LeaderBoardsAPI{
	public class SaveAndList{
		
		//Save
		public var facebook:Boolean = false;
		public var allowduplicates:Boolean = false;
		
		//Load
		public var global:Boolean = true;
		public var mode:String = "alltime";
		public var customfilters:Object = {};
		public var page:int = 1;
		public var perpage:int = 20;
		public var friendslist:Array = new Array();
		
		//Both
		public var highest:Boolean = true;
		public var pageOfScore:Boolean = false;//returns the page that includes the sent player score.
		
		protected var sendaction:URLLoader = new URLLoader;
		protected var handled:Boolean = false;
		
		protected var score:PlayerScore;
		protected var table:String;
		protected var callback:Function;
		protected var postdata:URLVariables;
		
		public function SaveAndList(_score:PlayerScore, _table:String, _callback:Function = null){
			score = _score;
			table = _table;
			callback = _callback;
		}
		public function start():void{
			if(pageOfScore) page = -1;
			
			updatePostData();
			
			var request:URLRequest = new URLRequest("http://g" + Log.GUID +".api.playtomic.com/leaderboards/saveandlist.aspx?swfid=" + Log.SWFID + "&url=" + (global || Log.SourceUrl == null ? "global" : Log.SourceUrl) + "&r=" + Math.random());
			
			request.data = postdata;
			request.method = URLRequestMethod.POST;
		
			listen();
			sendaction.load(request);
		}
		public function stop():void{
			unlisten();
			handled=true;
			postdata=null;
			callback=null;
			score=null;
			sendaction=null;
			customfilters=null;
		}
		protected function listen():void{
			sendaction.addEventListener(Event.COMPLETE, bridge);
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, fail);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatusignore);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
		}
		protected function unlisten():void{
			sendaction.removeEventListener(Event.COMPLETE, bridge);
			sendaction.removeEventListener(IOErrorEvent.IO_ERROR, fail);
			sendaction.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatusignore);
			sendaction.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
		}
		protected function updatePostData():void{
			//SAVE//
			postdata = new URLVariables();
			postdata["table"] = escape(table);
			postdata["highest"] = highest ? "y" : "n";
			postdata["name"] = escape(score.Name);
			postdata["points"] = score.Points.toString();
			postdata["allowduplicates"] = allowduplicates ? "y" : "n";
			postdata["auth"] = Encode.MD5(Log.SourceUrl + s);
			postdata["fb"] = facebook ? "y" : "n";
			postdata["fbuserid"] = score.FBUserId;
			
			var numcustomfields:int = 0;
			
			if(score.CustomData != null)//CustomData from PlayerScore.as
			{
				for(var key:String in score.CustomData)
				{
					postdata["ckey" + numcustomfields] = key;
					postdata["cdata" + numcustomfields] = escape(score.CustomData[key]);
					numcustomfields++;
				}
			}
						
			postdata["customfields"] = numcustomfields;
			
			
			//LIST//
			postdata["mode"] = mode;
			postdata["page"] = page;
			postdata["perpage"] = perpage;
			postdata["friendslist"] = friendslist.join(",");
			
			var numcustomfilters:int = 0;
			
			if(customfilters != null)
			{
				for(var key:String in customfilters)
				{
					postdata["ckey" + numcustomfilters] = key;
					postdata["cdata" + numcustomfilters] = escape(customfilters[key]);
					numcustomfilters++;
				}
			}
			postdata["customfilters"] = numcustomfilters;
			
		}
		protected function bridge():void{
			if(callback == null || handled){
				stop();
				return;
			}
				
			handled = true;
			
			ProcessScores(sendaction, callback);
		}
		protected function fail():void
		{
			if(callback == null || handled){
				stop();
				return;
			}
									
			handled = true;
			//callback signature: callback(scores:Array, numscores:int, score:PlayerScore, rank:int, response:Object):void
			callback([], 0, score, 0, {Success: false, ErrorCode: 1});
			stop();
		}
		
		protected function httpstatusignore():void
		{
			
		}
		
		private static function ProcessScores(loader:URLLoader, callback:Function):void
		{			
			var data:XML = XML(loader["data"]);
			var status:int = parseInt(data["status"]);
			var errorcode:int = parseInt(data["errorcode"]);
			var numscores:int = parseInt(data["numscores"]);
			var rank:int = parseInt(data["rank"]);
			var results:Array = new Array();
			
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
			
			//callback signature: callback(scores:Array, numscores:int, score:PlayerScore, rank:int, response:Object):void
			callback(results, numscores, score, rank, {Success: status == 1, ErrorCode: errorcode})
			stop();
		}