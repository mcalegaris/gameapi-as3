package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import Playtomic.type.MODE;
	import Playtomic.type.ERROR;
	import Playtomic.type.Response;
	
	import Playtomic.type.SaveOptions;
	import Playtomic.type.ListOptions;
	import Playtomic.type.ListFBOptions;
	import Playtomic.type.SaveAndListOptions;
	
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
			listfbBtn.addEventListener(MouseEvent.CLICK, testListFB);
			salBtn.addEventListener(MouseEvent.CLICK, testSaveAndList);
			
			list_mode.selectedIndex = 3;
		}
		//////////////////////////////////////////////////
		private function testSave(me:MouseEvent=null):void{
			trace(":::testSave init");
			var score:PlayerScore = new PlayerScore(save_name.text, save_points.value);
			score.FBUserId = save_fbuserid.text;
			score.CustomData = stringToObject(save_customdata.text);
			
			var saveOptions:SaveOptions = new SaveOptions(save_facebook.selected, save_highest.selected, save_allowduplicates.selected);
			
			Leaderboards.Save(score, save_table.text, saveComplete, saveOptions);
			trace(":::testSave sent");
		}
		private function saveComplete(score:PlayerScore, response:Object):void{
			trace(":::testSave callback");
			trace(score);
			trace(response);
		}
		//////////////////////////////////////////////////
		private function testList(me:MouseEvent=null):void{
			trace("list_perpage.value: "+list_perpage.value);
			var listOptions:ListOptions = new ListOptions(list_global.selected, list_highest.selected, list_mode.value, stringToObject(list_customfilters.text), list_page.value, list_perpage.value);
			Leaderboards.List(list_table.text, listComplete, listOptions);
			trace("test list");
		}
		private function listComplete(scores:Array, numscores:int, response:Object):void{
			trace("scores: "+scores);
			trace("numscores: "+numscores);
			trace(response);
		}
		private function testListFB(me:MouseEvent=null):void{//not fully tested
			var listfbOptions:ListFBOptions = new ListFBOptions(listfb_global.selected, listfb_highest.selected, listfb_mode.value, stringToObject(listfb_customfilters.text), listfb_page.value, listfb_perpage.value, stringToArray(listfb_friendslist.text));
			Leaderboards.ListFB(listfb_table.text, listfbComplete, listfbOptions);
			trace("test list");
		}
		private function listfbComplete(scores:Array, numscores:int, response:Object):void{
			trace("scores: "+scores);
			trace("numscores: "+numscores);
			trace(response);
		}
		//////////////////////////////////////////////////
		private function testSaveAndList(me:MouseEvent=null):void{//not tested with server side yet.
			var score:PlayerScore = new PlayerScore(sal_name.text, sal_points.value);
			score.FBUserId = sal_fbuserid.text;
			score.CustomData = stringToObject(sal_customdata.text);
			
			var salOptions:SaveAndListOptions = new SaveAndListOptions(sal_facebook.selected, sal_allowduplicates.selected, sal_global.selected, sal_highest.selected, sal_mode.value, stringToObject(sal_customfilters.text), sal_perpage.value, stringToArray(sal_friendslist.text));
			
			Leaderboards.SaveAndList(score, sal_table.text, saveandlistComplete, salOptions);
			
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
			return str.split(",");
		}
	}
}