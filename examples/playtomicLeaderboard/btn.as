package playtomicLeaderboard{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	
	public class btn extends MovieClip{
		
		private var UP:Object = {_brightness:0, time:10, useFrames:true}
		private var OVER:Object = {_brightness:-0.5, time:10, useFrames:true}
		public var action:Function;
		
		public function btn(){
			ColorShortcuts.init();
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, kill);
		}
		private function init(e:Event=null):void{
			buttonMode=true;
			mouseChildren=false;
			addEventListener(MouseEvent.MOUSE_OVER, mOver);
			addEventListener(MouseEvent.MOUSE_OUT, mOut);
			addEventListener(MouseEvent.CLICK, mClick);
		}
		private function kill(e:Event=null):void{
			removeEventListener(MouseEvent.MOUSE_OVER, mOver);
			removeEventListener(MouseEvent.MOUSE_OUT, mOut);
			removeEventListener(MouseEvent.CLICK, mClick);
			
			Tweener.removeTweens(this);
		}
		protected function mOver(me:MouseEvent=null):void{
			Tweener.addTween(this, OVER);
		}
		protected function mOut(me:MouseEvent=null):void{
			Tweener.addTween(this, UP);
		}
		public function mClick(me:MouseEvent=null):void{
			//gotoAndStop("down");  //most of the buttons i use only have up and over.
			if(action != null){
				action();//you could send the mouse event through if you have a need for it.
			}
		}
	}
}