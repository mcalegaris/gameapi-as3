package playtomicLeaderboard{
	import flash.display.MovieClip;
	import Playtomic.Leaderboards;
	import Playtomic.PlayerScore;
	import flash.events.MouseEvent;
	import Playtomic.type.MODE;
	import flash.events.Event;
	import Playtomic.type.Response;
	import Playtomic.type.ListOptions;
	
	public class ListScreen extends screen{
		
		private static var self:ListScreen;
		
		private var table:String = "highscores";
		
		private var lsRanks:Array = new Array;
		private var lsScores:Array = new Array;
		private var lsNames:Array = new Array;
		
		public var page:int = 1;
		public const perpage:int = 10;
		
		private var Modes:Object;
		private var _Mode:String = "alltime";
		public function get selectedMode():String{
			return _Mode;
		}
		public function set selectedMode(val:String){
			Modes[_Mode].gotoAndStop(1);
			Modes[_Mode].Selected=false;
			Modes[val].gotoAndStop(2);
			Modes[val].Selected=true;
			_Mode = val;
		}
		public static function Clear():void{
			self.listScores([]);
		}
		public static function MyBoardList(table:String=null):void{
			trace("--MyBoardList");
			self.List(table, "alltime");
		}
		public static function SaveAndListCallback(scores:Array, numscores:int, response:Response):void{
			trace("SaveAndListCallback");
			self.Show();
			trace(response);
			
			self.updatePageBtns(numscores);
			self.listScores(scores);
		}
		public function ListCallback(scores:Array, numscores:int, response:Response):void{
			trace("ListCallback");
			trace(response);
			trace("scores: "+scores);
			trace("numscores: "+numscores);
			updatePageBtns(numscores);
			listScores(scores);
		}
		
		public function ListScreen(){
			self=this;
			
			visible=false;
			
			//for tweens.
			START.y += 480
			OUT.y += -480;
			
			//btns
			rightPageBtn.action = pageUp;
			leftPageBtn.action = pageDown;
			
			alltime.action = alltimeClick;
			month.action = monthClick;
			week.action = weekClick;
			day.action = dayClick;
			newest.action = newestClick;
			myboard.action = myboardClick;
			
			Modes = {alltime:alltime, last30days:month, last7days:week, today:day, newest:newest, myboard:myboard};//, friends:friends};
			
			//find and sort text fields.
			for(var n:int = 0; n<10; n++){
				lsRanks.push(ranks.getChildAt(n));
				lsScores.push(scores.getChildAt(n));
				lsNames.push(names.getChildAt(n));
			}
			lsRanks.sortOn("y", Array.NUMERIC)
			lsScores.sortOn("y", Array.NUMERIC)
			lsNames.sortOn("y", Array.NUMERIC)
			
			closeBtn.action = Hide;
			
			setupForSharedObject();
		}
		
		private function pageUp():void{changePage(1)}
		private function pageDown():void{changePage(-1)}
		private function changePage(dir:int = 1):void{
			page += dir;
			List(table, selectedMode);
		}
		
		private function alltimeClick(me:MouseEvent=null):void{changeMode(MODE.ALL)}
		private function monthClick(me:MouseEvent=null):void{changeMode(MODE.MONTH)}
		private function weekClick(me:MouseEvent=null):void{changeMode(MODE.WEEK)}
		private function dayClick(me:MouseEvent=null):void{changeMode(MODE.DAY)}
		private function newestClick(me:MouseEvent=null):void{changeMode(MODE.NEWEST)}
		private function myboardClick(me:MouseEvent=null):void{
			trace("click myboardClick");
			changeMode("myboard");
			myboardgui.Show();
		}
		
		private function List(_table:String, _mode:String):void{
			trace("--@List: "+_mode);
			trace("--@List: "+_table);
			
			var lo:ListOptions = new ListOptions();
			lo.mode = _mode;
			Leaderboards.List(_table, ListCallback, lo);
		}
		
		private function changeMode(modeName:String):void{
			if(!isShown)return;
			myboardgui.Hide();
			
			if(selectedMode == modeName){
				selectedMode = modeName;//will select the tab anyway, but not do any Listing.
				return;
			}
			
			selectedMode = modeName;
			
			page = 1;
			List(table, selectedMode);
			
			soDATA.saveSO();
		}
		
		public override function Show():void{
			super.Show();
			Modes[selectedMode].mClick();
		}
		public override function Hide():void{
			OUT.onComplete = main.quit;
			super.Hide();
		}
		
		public function updatePageBtns(numscores:int):void{
			leftPageBtn.visible=true;
			rightPageBtn.visible=true;
			if(page <= 1) leftPageBtn.visible=false;
			if(page >= Math.ceil(numscores/perpage)) rightPageBtn.visible=false;
		}
		public function listScores(scores:Array):void{
			for(var i:int=0; i<10; i++)
			{
				if(i < scores.length){
					lsRanks[i].text = (i+1) + (page-1)*perpage +")";
					var score:PlayerScore = scores[i];
					lsScores[i].text = score.Points;
					lsNames[i].text = score.Name;
				}else{
					lsRanks[i].text = "";
					lsScores[i].text = "";
					lsNames[i].text = "";
				}
			}
		}
		
		
		//FOR SHARED OBJECT
		private function setupForSharedObject():void{
			soDATA.saveListScreen = saveListScreen;
			soDATA.loadListScreen = loadListScreen;
		}
		private function saveListScreen():Object{
			var obj:Object = new Object;
			obj.Mode = selectedMode;
			return obj;
		}
		private function loadListScreen(obj:Object):void{
			Modes[obj.Mode].mClick();
		}
	}
}