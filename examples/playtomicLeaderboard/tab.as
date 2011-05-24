package playtomicLeaderboard{
	
	import flash.events.MouseEvent;
	
	public class tab extends btn{
		
		public var Selected:Boolean = false;
		
		protected override function mOver(me:MouseEvent=null):void{
			if(Selected)return;
			
			super.mOver();
		}
		protected override function mOut(me:MouseEvent=null):void{
			if(Selected)return;
			
			super.mOut();
		}
		public override function mClick(me:MouseEvent=null):void{
			if(Selected)return;
			mOut();
			//Selected = true; //handled by ListScreen.as along with deselection;
			
			super.mClick();
		}
		
	}
}