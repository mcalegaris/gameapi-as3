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
	
	public class playtomicLeaderboard extends MovieClip {
		
		private const table:String = "highscores";
		
		private var startTime:int = 0;
		private var _playerScore:PlayerScore;
		
		public function playtomicLeaderboard() {
			listen();
			
			test();
		}
		private function test(e:Event=null):void{//settings and events that would normally be handled by your game.
			Log.View(2261, "8389db1c29914bbf", root.loaderInfo.loaderURL);
			sendScreen.score.text = int(Math.random()*1000).toString();
			sendScreen.Show();
		}
		
		private function listen():void{
			sendScreen.addEventListener("REQUEST", SaveScore);
			sendScreen.addEventListener("QUIT", quit);
			
			listScreen.addEventListener("REQUEST", ListScores);
			listScreen.addEventListener("QUIT", quit);
		}
		
		private function quit(e:Event=null):void{
			visible=false;
		}
		
		public function SaveScore(e:Event=null):void{
			trace("SAVE SCORE");
			startTime = getTimer();
			_playerScore = new PlayerScore(sendScreen.userName.text, int(sendScreen.score.text));
			
			Leaderboards.Save(_playerScore, "highscores", SaveComplete, new SaveOptions());
		}
		public function SaveComplete(score:PlayerScore, response:Response):void
		{
			trace("SAVE COMPLETE");
			var responseTime:Number = (getTimer()-startTime)/1000;
			trace("save response time: "+responseTime.toFixed(3)+" seconds");
			sendScreen.Hide();
			listScreen.Show();
			
			trace(response);
			
			trace("Score saved!");
		}
		
		public function ListScores(e:Event=null):void{
			startTime = getTimer();
			
			Leaderboards.List("highscores", ListComplete, new ListOptions(true,true,listScreen.selectedMode));
		}
		public function ListComplete(scores:Array, numscores:int, response:Response):void{
			var responseTime:Number = (getTimer()-startTime)/1000;
			trace("list response time: "+responseTime.toFixed(3)+" seconds");
			
			trace(response);
			
			listScreen.updatePageBtns(numscores);
			listScreen.listScores(scores);
		}
		
	}
}
