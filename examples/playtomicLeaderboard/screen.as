package playtomicLeaderboard{
	import flash.display.MovieClip;
	
	public class screen extends panel{
		
		public var isShown:Boolean = false;
		
		public function Show():void{
			if(!visible) tweenIn();
			
			isShown=true;
			visible=true;
			
		}
		public function Hide():void{
			if(!isShown){
				visible=false;
			}
			isShown=false;
			tweenOut();
		}
		
	}
}