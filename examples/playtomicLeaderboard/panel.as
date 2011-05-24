package playtomicLeaderboard{
	import flash.display.MovieClip;
	
	import caurina.transitions.Tweener;
	
	
	public class panel extends MovieClip{
		
		public var IN:Object = {x:0, y:0, time:30, useFrames:true, onComplete:null};
		public var OUT:Object = {x:0, y:0, time:30, useFrames:true, onComplete:visibleFalse};
		public var START:Object = {x:0, y:0, time:0, useFrames:true, onComplete:null};
		
		public function panel(){
			IN.x += x; IN.y += y; OUT.x += x; OUT.y += y; START.x += x; START.y += y;
			//Tweener.addTween(this, {delay:0, useFrames:true, onComplete:setStart});
			//setStart();
		}
		public function setStart():void{
			Tweener.addTween(this, START);
		}
		
		public function tweenIn():void{
			visible=true;
			setStart();
			Tweener.addTween(this, IN);
		}
		public function tweenOut():void{
			Tweener.addTween(this, OUT);
		}
		public function visibleFalse():void{
			Tweener.addTween(this, START);
			visible=false;
		}
		
	}
}