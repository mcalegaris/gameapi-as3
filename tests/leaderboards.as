package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import Playtomic.type.MODE;
	import Playtomic.type.ERROR;
	import Playtomic.type.Response;
	
	import Playtomic.type.SaveOptions;
	import Playtomic.type.ListOptions;
	import Playtomic.type.SaveAndListOptions;
	import Playtomic.type.PrivateBoard;
	
	import Playtomic.PlayerScore;
	import Playtomic.Log;
	
	import Playtomic.Leaderboards;
	
	

//only imported for testing LEGACY
	
	public class leaderboards extends MovieClip{
		
		private var _tableName:String = "highscore";
		
		public function leaderboards(){
			Log.View(2261, "8389db1c29914bbf");
			
			saveBtn.addEventListener(MouseEvent.CLICK, testSave);
			listBtn.addEventListener(MouseEvent.CLICK, testList);
			salBtn.addEventListener(MouseEvent.CLICK, testSaveAndList);
			
			cplBtn.addEventListener(MouseEvent.CLICK, testCreatePrivateLeaderboard);
			lplBtn.addEventListener(MouseEvent.CLICK, testLoadPrivateLeaderboard);
			gplBtn.addEventListener(MouseEvent.CLICK, testGetPrivateLeaderboardFromUrl);
			
			cb_mode.selectedIndex = 3;
		}
		
		private function testCreatePrivateLeaderboard(me:MouseEvent=null):void{
			trace("start create");
			Leaderboards.CreatePrivateLeaderboard(txt_TableAlias.text, txt_Permalink.text, onCreatePrivateLeaderboard);
		}
		private function onCreatePrivateLeaderboard(dat:PrivateBoard, response:Response){
			trace("end create");
			trace(dat);
			trace(response);
		}
		private function testLoadPrivateLeaderboard(me:MouseEvent=null):void{
			trace("start load");
			Leaderboards.LoadPrivateLeaderboard(txt_TableID.text, onLoadPrivateLeaderboard);
		}
		private function onLoadPrivateLeaderboard(dat:PrivateBoard, response:Response){
			trace("end load");
			trace(dat);
			trace(response);
		}
		private function testGetPrivateLeaderboardFromUrl(me:MouseEvent=null):void{
			trace("boardID: "+Leaderboards.GetLeaderboardFromUrl(txt_URL.text) );
		}
		
		
		//////////////////////////////////////////////////
		private function testSave(me:MouseEvent=null):void{
			trace(":::testSave init");
			var score:PlayerScore = new PlayerScore(txt_name.text, num_points.value);
			score.FBUserId = txt_fbuserid.text;
			score.CustomData = stringToObject(txt_customdata.text);
			
			var saveOptions:SaveOptions = new SaveOptions(chk_highest.selected, chk_allowduplicates.selected);
			
			Leaderboards.Save(score, txt_table.text, saveComplete, saveOptions);
			trace(":::testSave sent");
		}
		private function saveComplete(score:PlayerScore, response:Object):void{
			trace(":::testSave callback");
			trace(score);
			trace(response);
		}
		//////////////////////////////////////////////////
		private function testList(me:MouseEvent=null):void{
			var listOptions:ListOptions = new ListOptions(chk_global.selected, chk_highest.selected, cb_mode.value, stringToObject(txt_customfilters.text), num_page.value, num_perpage.value, chk_facebook.selected, stringToArray(txt_friendslist.text));
			Leaderboards.List(txt_table.text, listComplete, listOptions);
			trace("test list");
		}
		private function listComplete(scores:Array, numscores:int, response:Object):void{
			trace("scores: "+scores);
			trace("numscores: "+numscores);
			trace(response);
		}
		//////////////////////////////////////////////////
		private function testSaveAndList(me:MouseEvent=null):void{//not tested with server side yet.
			var score:PlayerScore = new PlayerScore(txt_name.text, num_points.value);
			score.CustomData = stringToObject(txt_customdata.text);
			score.FBUserId = txt_fbuserid.text;
			
			trace("txt_fbuserid.text: "+txt_fbuserid.text);
			var salOptions:SaveAndListOptions = new SaveAndListOptions(chk_allowduplicates.selected, chk_global.selected, chk_highest.selected, cb_mode.value, stringToObject(txt_customfilters.text), num_perpage.value, stringToArray(txt_friendslist.text));
			trace("txt_table.text: "+txt_table.text);
			Leaderboards.SaveAndList(score, txt_table.text, saveandlistComplete, salOptions);
			
		}
		
		//, score:PlayerScore, rank:int
		private function saveandlistComplete(scores:Array, numscores:int, response:Response):void{
			trace("scores: "+scores);
			trace("numscores: "+numscores);
			/*trace("score: "+score);
			trace("rank: "+rank);*/
			trace(response);
		}
		
		private function stringToObject(str:String):Object{
			//example format:  fruit=apple,veggie=carrot
			var obj:Object = new Object();
			while(str.indexOf("=")>=0){
				var eqIndex:int = str.indexOf("=");
				var cIndex:int = str.indexOf(",");
				if(cIndex == -1) cIndex = int.MAX_VALUE;
				
				var param:String = str.substring(0,eqIndex);
				var val:String = str.substring(eqIndex+1,cIndex);
				
				obj[param]=val;
				
				str = str.substr(cIndex+1);
			}
			return obj;
		}
		private function stringToArray(str:String):Array{
			if(str == "") return new Array();
			if(str.indexOf(",")<0) return [str];
			
			return str.split(",");
		}
	}
}