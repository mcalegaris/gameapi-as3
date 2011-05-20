package{
	import flash.display.MovieClip;
	
	import Playtomic.LeaderboardsAPI.Save;
	import Playtomic.LeaderboardsAPI.List;
	import Playtomic.LeaderboardsAPI.ListFB;
	import Playtomic.LeaderboardsAPI.SaveAndList;
	
	import Playtomic.type.MODE;
	import Playtomic.type.ERROR;
	
	import Playtomic.PlayerScore;
	import Playtomic.Log;
	
	import Playtomic.Leaderboards;
	

//only imported for testing LEGACY
	
	public class leaderboards extends MovieClip{
		
		private var _tableName:String = "highscore";
		
		private var _save:Save;
		private var _list:List;
		private var _listfb:ListFB;
		private var _saveandlist:SaveAndList;
		
		public function leaderboards(){
			Log.View(2261, "8389db1c29914bbf");
			
			
			
			//testSave();
			testList();
			//testListFB();
			//testSaveAndList();
		}
		//////////////////////////////////////////////////
		private function testSave():void{
			var score:PlayerScore = new PlayerScore();
			score.Name = "name";
			score.Points = 100;
			
			//NEW
			_save = new Save(score, _tableName, saveComplete);//construct
			_save.allowduplicates=true;//set options
			_save.start();//start
			
			//Leaderboards.Save(score, _tableName, saveComplete, {});//LEGACY
			
			trace("test save");
		}
		private function saveComplete(score:PlayerScore, response:Object):void{
			trace("score: "+score);
			trace("Success: "+response.Success);
			trace("ErrorCode: "+response.ErrorCode);
			trace("Error-Description: "+ERROR.descriptionByCode(response.ErrorCode) );
		}
		//////////////////////////////////////////////////
		private function testList():void{
			//NEW
			_list = new List(_tableName, listComplete);//construct
			_list.mode=MODE.MONTH;//set options
			_list.start();//start
			
			//Leaderboards.List(_tableName, listComplete, {});//LEGACY
			trace("test list");
		}
		private function listComplete(scores:Array, numscores:int, response:Object):void{
			trace("scores: "+scores);
			trace("numscores: "+numscores);
			trace("Success: "+response.Success);
			trace("ErrorCode: "+response.ErrorCode);
			trace("Error-Description: "+ERROR.descriptionByCode(response.ErrorCode) );
		}
		private function testListFB():void{//not fully tested
			//NEW
			_listfb = new ListFB(_tableName, listfbComplete);//construct
			_listfb.mode=MODE.MONTH;//set options
			_listfb.start();//start
			
			//Leaderboards.ListFB(_tableName, listfbComplete, {});//LEGACY
			trace("test list");
		}
		private function listfbComplete(scores:Array, numscores:int, response:Object):void{
			trace("scores: "+scores);
			trace("numscores: "+numscores);
			trace("Success: "+response.Success);
			trace("ErrorCode: "+response.ErrorCode);
			trace("Error-Description: "+ERROR.descriptionByCode(response.ErrorCode) );
		}
		//////////////////////////////////////////////////
		private function testSaveAndList():void{//not tested with server side yet.
			var score:PlayerScore = new PlayerScore();
			score.Name = "name";
			score.Points = 100;
			
			//NEW
			_saveandlist = new SaveAndList(score, _tableName, saveandlistComplete);//construct
			_saveandlist.pageOfScore=true;
			_saveandlist.start();//start
			
		}
		private function saveandlistComplete(scores:Array, numscores:int, score:PlayerScore, rank:int, response:Object):void{
			trace("scores: "+scores);
			trace("numscores: "+numscores);
			trace("score: "+score);
			trace("rank: "+rank);
			trace("Success: "+response.Success);
			trace("ErrorCode: "+response.ErrorCode);
			trace("Error-Description: "+ERROR.descriptionByCode(response.ErrorCode) );
		}
	}
}