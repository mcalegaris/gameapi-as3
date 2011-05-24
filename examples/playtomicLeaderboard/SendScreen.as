package playtomicLeaderboard{
	import flash.display.MovieClip;
	import Playtomic.PlayerScore;
	import Playtomic.Leaderboards;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class SendScreen extends screen{
		
		private var busy:Boolean = false;
		
		public function SendScreen():void{
			START.y += 480
			OUT.y += -480;
			
			soDATA.saveSendScreen = saveSendScreen;
			soDATA.loadSendScreen = loadSendScreen;
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
			sendBtn.action = sendScore;
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
			OUT.onComplete = quit;
			super.Hide();
		}
		private function quit():void{
			dispatchEvent(new Event("QUIT"));
		}
		
		private function sendScore(me:MouseEvent=null):void{
			dispatchEvent(new Event("REQUEST"));
		}
	}
}