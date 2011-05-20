package{
	import flash.display.MovieClip;
	
	import Playtomic.LeaderboardsAPI.Save;
	import Playtomic.PlayerScore;
	import Playtomic.LeaderboardsAPI.List;
	
	import Playtomic.Log;
	
	import Playtomic.Leaderboards;
	
	public class leaderboards extends MovieClip{
		
		private var _tableName:String = "highscore";
		
		private var _save:Save;
		private var _list:List;
		
		public function leaderboards(){
			Log.View(2261, "8389db1c29914bbf");
			
			testSave();
			//testList();
		}
		private function testSave():void{
			var score:PlayerScore = new PlayerScore();
			score.Name = "name";
			score.Points = 100;
			
			_save = new Save(score, _tableName, saveComplete);
			_save.start();
			
			//Leaderboards.Save(score, _tableName, saveComplete);
			
			trace("test save");
		}
		private function saveComplete(score:PlayerScore, response:Object):void{
			trace("score: "+score);
			trace("Success: "+response.Success);
			trace("ErrorCode: "+response.ErrorCode);
		}
		private function testList():void{
			_list = new List(_tableName, listComplete);
			_list.start();
			trace("test list");
		}
		private function listComplete(scores:Array, numscores:int, response:Object):void{
			trace("scores: "+scores);
			trace("numscores: "+numscores);
			trace("Success: "+response.Success);
			trace("ErrorCode: "+response.ErrorCode);
		}
	}
}