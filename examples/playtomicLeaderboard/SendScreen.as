package playtomicLeaderboard{
	import flash.display.MovieClip;
	import Playtomic.PlayerScore;
	import Playtomic.Leaderboards;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class SendScreen extends screen{
		
		private var busy:Boolean = false;
		
		private static var self:SendScreen;
		
		public function SendScreen():void{
			self=this;
			
			START.y += 480
			OUT.y += -480;
			
			soDATA.saveSendScreen = saveSendScreen;
			soDATA.loadSendScreen = loadSendScreen;
			
			sendBtn.action = Save;
		}
		
		public static function SaveToTable(table:String){
			var ps:PlayerScore = new PlayerScore(self.userName.text, int(self.score.text));
			Leaderboards.SaveAndList(ps, table, ListScreen.SaveAndListCallback);
		}
		
		public function Save():void{
			trace("--@Save: "+"alltime");
			trace("--@Save: "+"highscores");
			
			var score:PlayerScore = new PlayerScore(userName.text, int(score.text));
			trace("score: "+score);
			Leaderboards.SaveAndList(score, "highscores", ListScreen.SaveAndListCallback);
			
			Hide();
		}
		
		private function saveSendScreen():Object{
			var obj:Object = new Object;
			obj.userName = userName.text;
			return obj;
		}
		private function loadSendScreen(obj:Object):void{
			userName.text = obj.userName;
		}
		
		public override function Show():void{
			sendBtn.action = Save;
			closeBtn.action = Quit;
			userName.text = "guest"
			
			soDATA.loadSO();
			
			super.Show();
		}
		public override function Hide():void{
			OUT.onComplete = null;
			super.Hide();
		}
		
		private function Quit():void{
			OUT.onComplete = main.quit;
			super.Hide();
		}
	}
}