package playtomicLeaderboard{
	import flash.display.MovieClip;
	import Playtomic.type.Response;
	import Playtomic.Leaderboards;
	import Playtomic.type.MODE;
	import Playtomic.type.PrivateBoard;
	import Playtomic.GameVars;
	import flash.events.Event;
	
	public class myboardGui extends MovieClip{
		
		public var permalink:String = "http://www.example.com/mygame?leaderboard=";
		public var debugUrl:String = "http://www.example.com/mygame?leaderboard=4ddf21a5c164500a38cae8b9";
		
		public function myboardGui(){
			trace("myboardGui constructor");
			Hide();
			
			createPrompt.action = createBoard;
			removePrompt.action = removeBoard;
			addBtn.action = clickAdd;
			removeBtn.action = clickRemove;
			
			createPrompt.visible=false;
			removePrompt.visible=false;
			
			setupComboBox();
			
			addEventListener(Event.ENTER_FRAME, setup);
		}
		private function setup(e:Event=null):void{
			removeEventListener(Event.ENTER_FRAME, setup);
			
			var linkBoardId:String = Leaderboards.GetLeaderboardFromUrl()//debugUrl);
			requestBoardNameById(linkBoardId);
			
			GameVars.Load(onGameVars);
		}
		private function onGameVars(result:Object, response:Object):void{
			if(response.Success){
				if(result.permalink!=null){
					permalink = result.permalink;
					trace("got permalink from gamevars: "+permalink);
				}
			}
		}
		public function Hide():void{
			visible=false;
		}
		public function Show():void{
			trace("SHOW MyBoardGUI");
			visible=true;
			
			updateMyBoardList();
			init();
			
		}
		
		private function init():void{
			if(soDATA.myboardIDs.length > 0){
				trace("~~~ HAS A MyBoard");
				ListScreen.MyBoardList(soDATA.myboardIDs[0].RealName)
			}else{
				trace("~~~ HAS NO MyBoard");
				ListScreen.Clear();
				createPrompt.tweenIn();
			}
			
			/*/v2/leaderboards/load.aspx?swfid=x + post groupid=xxxxxx*/ //post id returns boardname.
		}
		
		private function clickAdd():void{
			createPrompt.tweenIn();
		}
		private function clickRemove():void{
			removePrompt.txt.text = cb.selectedLabel;
			removePrompt.tweenIn();
		}
		private function createBoard():void{
			createPrompt.tweenOut();
			var boardName:String = createPrompt.txt.text;
			//boards by the same name are allowed.
			Leaderboards.CreatePrivateLeaderboard(boardName, permalink, MyBoardCreated);
		}
		private function removeBoard():void{
			removePrompt.tweenOut();
			var boardID:String = removePrompt.txt.text;
			
			soDATA.myboardIDs.splice( findBoard(boardID) ,1);
			soDATA.saveSO();
			
			updateMyBoardList();
			
			ListScreen.Clear();
			if(soDATA.myboardIDs.length>0){
				ListScreen.MyBoardList(soDATA.myboardIDs[0].RealName)
			}
		}
		private function findBoard(boardID:String):int{
			var count:int = soDATA.myboardIDs.length;
			for(var n:int = 0; n<count; n++){
				if(soDATA.myboardIDs[n].Name == boardID){
					return n;
				}
			}
			
			return -1;
		}
		
		private function requestBoardNameById(id:String):void{
			if(id!=null){
				Leaderboards.LoadPrivateLeaderboard(id, onBoardNameById);
			}
		}
		private function onBoardNameById(pb:PrivateBoard, response:Response):void{
			trace("response: "+response);
			trace("dat: "+pb);
			
			if(response.Success){
				//store Loaded PrivateBoard
				soDATA.myboardIDs.unshift(pb);
				soDATA.saveSO();
				
				updateMyBoardList();
			}
		}
		
		
		private function MyBoardCreated(pb:PrivateBoard, response:Response){
			trace("dat: "+pb);
			
			if(response.Success){
				//store Created PrivateBoard
				soDATA.myboardIDs.unshift(pb);
				soDATA.saveSO();
				mbLink.text = pb.Bitly;
				updateMyBoardList();
				
				//save to your new board.
				SendScreen.SaveToTable(pb.RealName);
			}
		}
		
		private function updateMyBoardList():void{
			cb.removeAll();
			var count:int = soDATA.myboardIDs.length;
			for(var n:int = 0; n<count; n++){
				cb.addItem({label:soDATA.myboardIDs[n].Name, data:soDATA.myboardIDs[n]});
				soDATA.myboardIDs
			}
			
			if(count == 0){
				removeBtn.visible=false;
				ListScreen.Clear();
				createPrompt.tweenIn();
			}else{
				removeBtn.visible=true;
				mbLink.text = soDATA.myboardIDs[0].Bitly;
			}
		}
		private function setupComboBox():void{
			cb.addEventListener(Event.CHANGE, cbChange);
		}
		private function cbChange(e:Event=null):void{
			//bump the chosen board to the top of the list.
			var count:int = soDATA.myboardIDs.length;
			for(var n:int = 0; n<count; n++){
				soDATA.myboardIDs[n].order++;
			}
			soDATA.myboardIDs[findBoard(cb.selectedLabel)].order = 1;
			soDATA.myboardIDs.sortOn("order", Array.NUMERIC);
			
			//rewrite the list in the combo box
			updateMyBoardList();
			//show the top board.
			ListScreen.MyBoardList(soDATA.myboardIDs[0].RealName)
		}
		
	}
}