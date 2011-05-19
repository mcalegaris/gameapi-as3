package LeaderBoardsAPI{
	public class main{
		
		//Save
		protected var _facebook:Boolean = false;
		protected var _allowduplicates:Boolean = false;
		protected var _score:PlayerScore;
		
		//List
		protected var _global:Boolean = true;//not in ListFB
		protected var _mode:String = "alltime";
		protected var _customfilters:Object = {};
		protected var _page:int = 1;
		protected var _perpage:int = 20;
		protected var _friendslist:Array = new Array();//not in List
		
		//Both
		protected var _highest:Boolean = true;
		
		protected var sendaction:URLLoader = new URLLoader;
		protected var handled:Boolean = false;
		
		protected var table:String;
		protected var callback:Function;
		protected var postdata:URLVariables;
		
		protected var request:URLRequest
		
		
		public function main(_table:String, _callback:Function):void{
			table = _table;
			callback = _callback;
		}
		
		public function start():void{
			updatePostData();
			
			request.data = postdata;
			request.method = URLRequestMethod.POST;
		
			listen();
			sendaction.load(request);
		}
		protected function setURLRequest():void{
			
		}
		public function stop():void{
			unlisten();
			handled=true;
			postdata=null;
			callback=null;
			sendaction=null;
			request=null;
			_score=null;
			_customfilters=null;
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
			
		}
		protected function updateListPostData():void{
			postdata["mode"] = _mode;
			postdata["page"] = _page;
			postdata["perpage"] = _perpage;
			postdata["friendslist"] = _friendslist.join(",");
			postdata["highest"] = _highest ? "y" : "n";
			
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
		protected function updateSavePostData():void{
			postdata = new URLVariables();
			postdata["table"] = escape(table);
			postdata["highest"] = _highest ? "y" : "n";
			postdata["name"] = escape(_score.Name);
			postdata["points"] = _score.Points.toString();
			postdata["allowduplicates"] = _allowduplicates ? "y" : "n";
			postdata["auth"] = Encode.MD5(Log.SourceUrl + s);
			postdata["fb"] = _facebook ? "y" : "n";
			postdata["fbuserid"] = _score.FBUserId;
			
			var numcustomfields:int = 0;
			
			if(_score.CustomData != null)//CustomData from PlayerScore.as
			{
				for(var key:String in _score.CustomData)
				{
					postdata["ckey" + numcustomfields] = key;
					postdata["cdata" + numcustomfields] = escape(_score.CustomData[key]);
					numcustomfields++;
				}
			}
						
			postdata["customfields"] = numcustomfields;
		}
		protected function httpstatusignore():void{
		}
		
		protected function bridge():void{
			if(callback == null || handled){
				stop();
				return;
			}
				
			handled = true;
			
			rData = new responseData(loader);//not for Save.as;
			
			successCallback();
			stop();
		}
		protected function fail():void
		{
			if(callback == null || handled){
				stop();
				return;
			}
									
			handled = true;
			
			failCallback();
			stop();
		}
		protected function failCallback():void{
			
		}
		protected function successCallback(){
			
		}
		
	}
}