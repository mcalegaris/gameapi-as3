package playtomicLeaderboard{
	
	import flash.display.MovieClip;
	import Playtomic.Log;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import Playtomic.Leaderboards;
	
	import flash.utils.getTimer;
	import Playtomic.PlayerScore;
	import Playtomic.type.Response;
	import Playtomic.type.ListOptions;
	import Playtomic.type.SaveOptions;
	
	public class main extends MovieClip {
		
		private var startTime:int = 0;
		private var _playerScore:PlayerScore;
		
		private static var self:main;
		
		public static function quit():void{
			self.visible=false;
		}
		
		public function main() {
			self=this;
			test();
		}
		private function test(e:Event=null):void{//settings and events that would normally be handled by your game.
			Log.View(2261, "8389db1c29914bbf", root.loaderInfo.loaderURL);
			trace("Log.GUID: "+Log.GUID);
			sendScreen.score.text = int(Math.random()*1000).toString();
			trace("sendScreen.score.text: "+sendScreen.score.text);
			sendScreen.Show();
		}
		
	}
}
