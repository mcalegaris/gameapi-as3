package LeaderBoardsAPI{
	public class Save extends main{
		
		public var facebook:Boolean = false;
		public var allowduplicates:Boolean = false;
		public var score:PlayerScore;
		public var highest:Boolean = true;
		
		override public function start():void{
			if(score == null || !score is PlayerScore){
				trace("ERROR: please set score to an instance of PlayerScore.as");
			}
			
			_facebook = facebook;
			_allowduplicates = allowduplicates;
			_score = score;
			_highest = highest;
			
			super.start();
		}
		
		override protected function setURLRequest():void{
			request = new URLRequest("http://g" + Log.GUID +".api.playtomic.com/leaderboards/save.aspx?swfid=" + Log.SWFID + "&url=" + (global || Log.SourceUrl == null ? "global" : Log.SourceUrl) + "&r=" + Math.random());
		}
		override protected function updatePostData():void{
			updateSavePostData();
		}
		override protected function failCallback():void{
			callback(score, {Success: false, ErrorCode: 1});
		}
		override protected function successCallback(){
			//callback signature: callback(scores:Array, response:Object):void
			callback(rData.score, {Success: rData.status == 1, ErrorCode: rData.errorcode})
		}
		
		override protected function bridge():void{
			if(callback == null || handled){
				stop();
				return;
			}
				
			handled = true;
			
			successCallback();
			stop();
		}
		
	}
}