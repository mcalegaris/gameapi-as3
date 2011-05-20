package Playtomic.LeaderboardsAPI{
	import Playtomic.PlayerScore;
	import Playtomic.Log;
	import flash.net.URLRequest;
	import Playtomic.type.MODE;
	
	public class SaveAndList extends main{
		
		public var global:Boolean = true;
		public var mode:String = MODE.ALL;
		public var customfilters:Object = {};
		public var page:int = 1;
		public var perpage:int = 20;
		public var highest:Boolean = true;
		public var friendslist:Array = new Array();
		
		public var facebook:Boolean = false;
		public var allowduplicates:Boolean = false;
		//public var highest:Boolean = true;
		
		public var pageOfScore:Boolean = false;//return the page that includes the sent player score.
		
		public function SaveAndList(_score:PlayerScore, _table:String, _callback:Function):void{
			score = _score;
			super(_table, _callback);
		}
		
		override public function start():void{
			
			_global = global;
			_mode = mode;
			_customfilters = customfilters;
			_page = page;
			_perpage = perpage;
			_friendslist = friendslist;
			_highest = highest;
			_facebook = facebook;
			_allowduplicates = allowduplicates;
			_highest = highest;
			
			if(facebook){
				global = true; //facebook is always global;
			}else{
				friendslist = new Array(); //no facebook means no friendslist;
			}
			
			if(pageOfScore) page = -1;
			super.start();
		}
		
		override protected function setURLRequest():void{
			request = new URLRequest("http://g" + Log.GUID +".api.playtomic.com/leaderboards/saveandlist.aspx?swfid=" + Log.SWFID + "&url=" + (global || Log.SourceUrl == null ? "global" : Log.SourceUrl) + "&r=" + Math.random());
		}
		override protected function updatePostData():void{
			updateListPostData();
			updateSavePostData();
		}
		override protected function failCallback():void{
			//callback signature: callback(scores:Array, numscores:int, score:PlayerScore, rank:int, response:Object):void
			callback([], 0, score, 0, {Success: false, ErrorCode: 1});
		}
		override protected function successCallback(){
			//callback signature: callback(scores:Array, numscores:int, score:PlayerScore, rank:int, response:Object):void
			callback(rData.results, rData.numscores, score, rData.rank, {Success: rData.status == 1, ErrorCode: rData.errorcode})
		}
		
	}
}