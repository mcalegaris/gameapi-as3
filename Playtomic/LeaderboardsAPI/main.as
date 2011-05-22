package Playtomic.LeaderboardsAPI{
	
	import Playtomic.PlayerScore;
	import Playtomic.Encode;
	import Playtomic.Log;
	import Playtomic.type.MODE;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	
	
	public class main{
		
		//Save
		protected var _facebook:Boolean = false;
		protected var _allowduplicates:Boolean = false;
		
		//List
		protected var _global:Boolean = true;
		protected var _mode:String = MODE.ALL;
		protected var _customfilters:Object = {};
		protected var _page:int = 1;
		protected var _perpage:int = 20;
		protected var _friendslist:Array = new Array();//not in List
		
		//Both
		protected var _highest:Boolean = true;
		
		//run time
		protected var sendaction:URLLoader = new URLLoader;
		protected var handled:Boolean = false;
		protected var postdata:URLVariables = new URLVariables();
		protected var rData:responseData;
		protected var request:URLRequest = new URLRequest();
		
		//constructor
		protected var table:String;//REQUIRED
		protected var callback:Function;//REQUIRED
		protected var score:PlayerScore;
		
		
		
		public function main(_table:String, _callback:Function):void{
			table = _table;
			callback = _callback;
		}
		
		public function start():void{
			updatePostData();
			
			setURLRequest();
			
			trace("request.url: "+request.url);
			trace("POSTDATA: "+postdata.toString());
			
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
			score=null;
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
			
			if(_customfilters != null)
			{
				for(var key:String in _customfilters)
				{
					postdata["ckey" + numcustomfilters] = key;
					postdata["cdata" + numcustomfilters] = escape(_customfilters[key]);
					numcustomfilters++;
				}
			}
			postdata["customfilters"] = numcustomfilters;
		}
		protected function updateSavePostData():void{
			postdata = new URLVariables();
			postdata["table"] = escape(table);
			postdata["highest"] = _highest ? "y" : "n";
			postdata["name"] = escape(score.Name);
			postdata["points"] = score.Points.toString();
			postdata["allowduplicates"] = _allowduplicates ? "y" : "n";
			postdata["auth"] = Encode.MD5(Log.SourceUrl + score.Points.toString());
			postdata["fb"] = _facebook ? "y" : "n";
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
		}
		protected function httpstatusignore(e:Event=null):void{
		}
		
		protected function bridge(e:Event=null):void{
			if(callback == null || handled){
				stop();
				return;
			}
				
			handled = true;
			
			rData = new responseData(sendaction);//mostly for Listing, but Save also uses it for response:Object
			
			successCallback();
			stop();
		}
		protected function fail(e:Event=null):void
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