package playtomicLeaderboard{
	public class prompt extends panel{
		
		public var action:Function;
		
		public function prompt(){
			closeBtn.action = tweenOut;
			goBtn.action = doAction;
			//txt.text
		}
		
		private function doAction():void{
			action();
			tweenOut();
		}
		
	}
}