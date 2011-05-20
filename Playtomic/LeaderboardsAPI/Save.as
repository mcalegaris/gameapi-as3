package Playtomic.LeaderboardsAPI{
	
	import Playtomic.PlayerScore;
	import Playtomic.Log;
	import flash.net.URLRequest;
	
	public class Save extends main{
		
		public var global:Boolean = true;
		public var facebook:Boolean = false;
		public var allowduplicates:Boolean = false;
		public var highest:Boolean = true;
		
		public function Save(_score:PlayerScore, _table:String, _callback:Function):void{
			score = _score;
			super(_table, _callback);
		}
		
		override public function start():void{
			if(score == null || !score is PlayerScore){
				trace("ERROR: please set score to an instance of PlayerScore.as");
			}
			
			_global = global;
			_facebook = facebook;
			_allowduplicates = allowduplicates;
			_highest = highest;
			
			super.start();
		}
		
		override protected function setURLRequest():void{
			trace("Log.SourceUrl: "+Log.SourceUrl);
			request = new URLRequest("http://g" + Log.GUID + ".api.playtomic.com/leaderboards/save.aspx?swfid=" + Log.SWFID + "&url=" + Log.SourceUrl + "&r=" + Math.random());
			//request = new URLRequest("http://g" + Log.GUID + ".api.playtomic.com/leaderboards/save.aspx?swfid=" + Log.SWFID + "&url=" + (global || Log.SourceUrl == null ? "global" : Log.SourceUrl) + "&r=" + Math.random());
		}
		override protected function updatePostData():void{
			updateSavePostData();
			trace("Save-POSTDATA: "+postdata.toString());
		}
		override protected function failCallback():void{
			callback(score, {Success: false, ErrorCode: 1});
		}
		override protected function successCallback(){
			//callback signature: callback(score:PlayerScore, response:Object):void
			callback(score, {Success: rData.status == 1, ErrorCode: rData.errorcode})
		}
		
	}
}