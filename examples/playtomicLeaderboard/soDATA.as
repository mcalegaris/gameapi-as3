package playtomicLeaderboard{
	
	import flash.net.SharedObject;
	
	public class soDATA{
		
		private static var so:SharedObject = SharedObject.getLocal( "rosedragoness/sketchbookgames/PLB", "/" );//all Leaderboards
		
		public static var loadSendScreen:Function;
		public static var saveSendScreen:Function;
		public static var loadListScreen:Function;
		public static var saveListScreen:Function;
		
		public static function clearSO():void{
			so.clear();
			so.flush();
		}
		
		public static function loadSO():void{
			//clearSO();
			if(so.data && so.data.Send && so.data.List){
				loadSendScreen( so.data.Send );
				loadListScreen( so.data.List );
			}
		}
		public static function saveSO():void{
			so.data.Send = saveSendScreen();
			so.data.List = saveListScreen();
			so.flush(); 
		}
	}
}