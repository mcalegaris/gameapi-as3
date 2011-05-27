package playtomicLeaderboard{
	
	import flash.net.SharedObject;
	
	public class soDATA{
		
		private static var so:SharedObject = SharedObject.getLocal( "playtomic/example/leaderboard", "/" );//all Leaderboards
		
		public static var loadSendScreen:Function;
		public static var saveSendScreen:Function;
		public static var loadListScreen:Function;
		public static var saveListScreen:Function;
		
		public static var myboardIDs:Array = new Array();
		
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
			if(so.data && so.data.myboardIDs){
				trace("so.data.myboardIDs: "+so.data.myboardIDs);
				myboardIDs = so.data.myboardIDs;
			}
			trace("myboardIDs: "+myboardIDs.length);
		}
		public static function saveSO():void{
			so.data.Send = saveSendScreen();
			so.data.List = saveListScreen();
			so.data.myboardIDs = myboardIDs; //this gets converted to an Object and doesn't get converted back. :(
			so.flush(); 
			
			trace("myboardIDs: "+myboardIDs.length);
		}
	}
}