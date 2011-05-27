package playtomicLeaderboard{
	import flash.display.MovieClip;
	import Playtomic.PlayerScore;
	import Playtomic.Leaderboards;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import Playtomic.type.SaveAndListOptions;
	import Playtomic.type.Response;
	
	
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
			trace("--@Save: "+ListScreen.SelectedMode);
			trace("--@Save: "+"highscores");
			
			var score:PlayerScore = new PlayerScore(userName.text, int(score.text));
			
			//SaveAndList to the board we are going to see, and save to the rest.
			if(ListScreen.SelectedMode == "myboard"){
				if(soDATA.myboardIDs.length>0){
					Leaderboards.SaveAndList(score, soDATA.myboardIDs[0].RealName, ListScreen.SaveAndListCallback);
					saveToOtherMyBoards(score);
					Leaderboards.Save(score, "highscores");
				}else{
					ListScreen.SaveAndListCallback([],0,new Response(true,0));
				}
			}else{
				saveToAllMyBoards(score);
				var salOptions:SaveAndListOptions = new SaveAndListOptions();
				salOptions.mode = ListScreen.SelectedMode;
				Leaderboards.SaveAndList(score, "highscores", ListScreen.SaveAndListCallback, salOptions);
			}
			
			Hide();
		}
		private function saveToAllMyBoards(score:PlayerScore):void{
			if(soDATA.myboardIDs.length > 0){
				Leaderboards.Save(score, soDATA.myboardIDs[0].RealName);
				saveToOtherMyBoards(score);
			}
		}
		private function saveToOtherMyBoards(score:PlayerScore):void{
			var count:int = soDATA.myboardIDs.length;
			for(var n:int = 1; n<count; n++){
				Leaderboards.Save(score, soDATA.myboardIDs[n].RealName);
			}
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