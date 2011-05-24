package playtomicLeaderboard{
	import flash.display.MovieClip;
	import Playtomic.Leaderboards;
	import Playtomic.PlayerScore;
	import flash.events.MouseEvent;
	import Playtomic.type.MODE;
	import flash.events.Event;
	
	public class ListScreen extends screen{
		
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
		
		public function ListScreen(){
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
			//friends.action = friendsClick;
			
			Modes = {alltime:alltime, last30days:month, last7days:week, today:day, newest:newest};//, friends:friends};
			
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
			dispatchEvent(new Event("REQUEST"));
		}
		
		private function alltimeClick(me:MouseEvent=null):void{changeMode(MODE.ALL)}
		private function monthClick(me:MouseEvent=null):void{changeMode(MODE.MONTH)}
		private function weekClick(me:MouseEvent=null):void{changeMode(MODE.WEEK)}
		private function dayClick(me:MouseEvent=null):void{changeMode(MODE.DAY)}
		private function newestClick(me:MouseEvent=null):void{changeMode(MODE.NEWEST)}
		//private function friendsClick(me:MouseEvent=null):void{changeMode("friends")}
		
		private function changeMode(modeName:String):void{
			if(!isShown)return;
			
			selectedMode = modeName;
			page = 1;
			dispatchEvent(new Event("REQUEST"));
			
			soDATA.saveSO();
		}
		
		public override function Show():void{
			super.Show();
			Modes[selectedMode].mClick();
		}
		public override function Hide():void{
			OUT.onComplete = quit;
			super.Hide();
		}
		private function quit():void{
			dispatchEvent(new Event("QUIT"));
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