package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import Playtomic.LeaderboardsAPI.Save;
	import Playtomic.LeaderboardsAPI.List;
	import Playtomic.LeaderboardsAPI.ListFB;
	import Playtomic.LeaderboardsAPI.SaveAndList;
	
	import Playtomic.type.MODE;
	import Playtomic.type.ERROR;
	import Playtomic.type.Response;
	
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
			
			saveBtn.addEventListener(MouseEvent.CLICK, testSave);
			listBtn.addEventListener(MouseEvent.CLICK, testList);
			listfbBtn.addEventListener(MouseEvent.CLICK, testListFB);
			saveandlistBtn.addEventListener(MouseEvent.CLICK, testSaveAndList);
		}
		//////////////////////////////////////////////////
		private function testSave(me:MouseEvent=null):void{
			trace(":::testSave init");
			var score:PlayerScore = new PlayerScore();
			score.Name = save_name.text;
			score.Points = save_points.value;
			score.FBUserId = save_fbuserid.text;
			score.CustomData = {fruit:"apple", veggi:"carrot"};//save_customdata.text;
			
			if(save_uselegacy.selected){
				Leaderboards.Save(score, save_table.text, saveComplete, {allowduplicates:save_allowduplicates.selected, facebook:save_facebook.selected, highest:save_highest.selected});//LEGACY
			}else{
				//NEW
				_save = new Save(score, save_table.text, saveComplete);//construct
				_save.allowduplicates = save_allowduplicates.selected;//set options
				_save.facebook = save_facebook.selected;
				_save.highest = save_highest.selected;
				_save.start();//start
			}
			trace(":::testSave sent");
		}
		private function saveComplete(score:PlayerScore, response:Object):void{
			trace(":::testSave callback");
			trace(score);
			trace(response);
		}
		//////////////////////////////////////////////////
		private function testList(me:MouseEvent=null):void{
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
			trace(response);
		}
		private function testListFB(me:MouseEvent=null):void{//not fully tested
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
			trace(response);
		}
		//////////////////////////////////////////////////
		private function testSaveAndList(me:MouseEvent=null):void{//not tested with server side yet.
			var score:PlayerScore = new PlayerScore();
			score.Name = "name";
			score.Points = 100;
			
			//NEW
			_saveandlist = new SaveAndList(score, _tableName, saveandlistComplete);//construct
			_saveandlist.pageofscore=true;
			_saveandlist.start();//start
			
		}
		private function saveandlistComplete(scores:Array, numscores:int, score:PlayerScore, rank:int, response:Response):void{
			trace("scores: "+scores);
			trace("numscores: "+numscores);
			trace("score: "+score);
			trace("rank: "+rank);
			trace(response);
		}
	}
}