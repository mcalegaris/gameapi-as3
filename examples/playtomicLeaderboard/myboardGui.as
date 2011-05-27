﻿package playtomicLeaderboard{
	import flash.display.MovieClip;
	import Playtomic.type.Response;
	import Playtomic.Leaderboards;
	import Playtomic.type.MODE;
	import Playtomic.type.PrivateBoard;
	
	public class myboardGui extends MovieClip{
		
		public var permalink = "http://www.url.com/mygame?leaderboard=";
		
		public function myboardGui(){
			trace("myboardGui constructor");
			Hide();
			
			createPrompt.action = createBoard;
			removePrompt.action = removeBoard;
			addBtn.action = clickAdd;
			removeBtn.action = clickRemove;
			//cb
			
			createPrompt.visible=false;
			removePrompt.visible=false;
		}
		public function Hide():void{
			visible=false;
		}
		public function Show():void{
			trace("SHOW MyBoardGUI");
			visible=true;
			init();
		}
		
		private function init():void{
			if(soDATA.myboardIDs.length > 0){
				trace("soDATA.myboardIDs[0]: "+soDATA.myboardIDs[0]);
				ListScreen.MyBoardList(soDATA.myboardIDs[0])
			}else{
				ListScreen.Clear();
				createPrompt.tweenIn();
			}
			
			/*/v2/leaderboards/load.aspx?swfid=x + post groupid=xxxxxx*/ //post id returns boardname.
		}
		
		private function clickAdd():void{
			createPrompt.tweenIn();
		}
		private function clickRemove():void{
			removePrompt.tweenIn();
		}
		private function createBoard():void{
			var boardName:String = createPrompt.txt.text;
			//boards by the same name are allowed.
			Leaderboards.CreatePrivateLeaderboard(boardName, permalink, MyBoardCreated);
		}
		private function removeBoard():void{
			var boardID:String = createPrompt.txt.text;
			
			soDATA.myboardIDs.split( findBoard(boardID) ,1);
			soDATA.saveSO();
		}
		private function findBoard(boardID:String):int{
			var count:int = soDATA.myboardIDs.length;
			for(var n:int = 0; n<count; n++){
				if(soDATA.myboardIDs[n] == boardID){
					return n;
				}
			}
			
			return -1;
		}
		
		private function requestBoardNameById(id:String):void{
			Leaderboards.LoadPrivateLeaderboard(id, onBoardNameById);
		}
		private function onBoardNameById(dat:PrivateBoard, response:Response):void{
			
		}
		
		
		private function MyBoardCreated(dat:PrivateBoard, response:Response){
			//recieved unique id.
			if(response.Success){
				soDATA.myboardIDs.push(dat.TableId);
				soDATA.saveSO();
				trace("dat: "+dat);
				mbLink.text = dat.Bitly;
			}
			
			SendScreen.SaveToTable(dat.RealName);
			
			//post id returns boardname.
			//SaveAndList to MyBoard.
		}
		
	}
}