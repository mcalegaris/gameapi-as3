package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import Playtomic.*;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Test extends MovieClip
	{
		private var seconds:int = 0;
		
		public function Test()
		{
			var tick:Function = function()
			{
				seconds++;
				t.text = seconds.toString();
				
			}
			
			// test swf
			var swfid = 1339;
			var guid = "e24ff1548e204607";
			
			// brian's swf
			//swfid = 2145;
			//guid = "ecb52a20151d462a";
			
			
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, tick);
			timer.start();
			
			Log.View(swfid, guid, root.loaderInfo.loaderURL);

			
			this.Button7.addEventListener(MouseEvent.CLICK, this.Link);
			
					
			/*GeoIP.Lookup(this.Country);

			Data.Views(this.DataLoaded);
			Data.Plays(this.DataLoaded);
			Data.PlayTime(this.DataLoaded);
			Data.CustomMetric("hi", this.DataLoaded);
			
			GameVars.Load(this.GameVarsLoaded);*/
			
			this.Button1.addEventListener(MouseEvent.CLICK, this.List);
			this.Button2.addEventListener(MouseEvent.CLICK, this.Save);
			this.Button3.addEventListener(MouseEvent.CLICK, this.Load);
			this.Button4.addEventListener(MouseEvent.CLICK, this.Rate);
			this.Button5.addEventListener(MouseEvent.CLICK, this.ListScores);
			this.Button6.addEventListener(MouseEvent.CLICK, this.SaveScore);
		}
		
		private function Link(e:MouseEvent):void
		{
			Playtomic.Link.Open("http://notdoppler.com/", "NotDoppler", "Sponsor");
		}
		
		private function DataLoaded(data:Object, response:Object):void
		{
			if(response.Success)
			{
				trace("Data loaded");
				
				for(var x in data)
				{
					trace(" -> " + x + " = " + data[x]);
				}				
			}
			else
			{
				trace("Data failed to load (" + response.ErrorCode + ")");
			}
		}
		
		private function ListScores(e:MouseEvent):void
		{
			Leaderboards.List("highscores", this.ShowScores, {page: 1, perpage: 50, customfilters: {Character: "Barbarian"}});
		}
		
		private function ShowScores(scores:Array, numscores:int, response:Object):void
		{					
			if(response.Success)
			{
				trace("Scores recent " + scores.length + " scores returned out of " + numscores);
				trace("---------------------------------------------------");
				
				var customdata = function(dict:Object):String
				{
					if(dict == null)
						return "";
						
					var str = "";
					
					for(var key:String in dict)
					{
						str += key + ": " + dict[key] + "\t";
					}
					
					return str;
				}
				
				for each(var score:PlayerScore in scores)
				{
					trace(score.Name + "\t" + score.Points + "\t" + score.SDate + "\t" + score.RDate + "\t" + score.Website + "\t" + customdata(score.CustomData));
				}
			}
			else
			{
				trace("Score didn't load (" + response.ErrorCode + ")");		
			}
		}
		
		private var basescore:int = 1;
		
		private function SaveScore(e:MouseEvent):void
		{
			basescore++;
			var score:PlayerScore = new PlayerScore();
			score.Name = "Fred";
			score.Points = basescore;
			
			trace(score.Points);
			
			Leaderboards.Save(score, "highscores", this.SaveScoreComplete);
		}
		
		private function SaveScoreComplete(score:PlayerScore, response:Object):void
		{
			if(response.Success)
			{
				trace("Score saved!");		
			}
			else
			{
				trace("Score saving failed (" + response.ErrorCode + ")");
			}			
		}
		
		// geoip
		private function Country(country:Object, response:Object):void
		{
			if(response.Success)
			{
				trace("GeoIP Succeeded: " + country.Code + " aka " + country.Name);	
			}
			else
			{
				trace("GeoIP lookup failed (" + response.ErrorCode + ")");
			}			
		}
		
		// gamevars
		private function GameVarsLoaded(vars:Object, response:Object):void
		{
			if(response.Success)
			{
				trace("GameVars loaded");
				
				for(var x in vars)
					trace(" -> " + x + ": " + vars[x]);
						
			}
			else
			{
				trace("GameVars failed to load (" + response.ErrorCode + ")");
			}
		}
		
		// player levels
		private function Rate(e:MouseEvent):void
		{
			trace("Rating 4cce3282cf1e8c2108000017");
			PlayerLevels.Rate("4cce3282cf1e8c2108000017", 8, this.RateComplete);
		}
		
		private function RateComplete(response:Object):void
		{
			if(response.Success)
			{
				trace("Rating complete");
			}
			else
			{
				trace("Rating failed (" + response.ErrorCode + ")");
			}
		}	

		private function List(e:MouseEvent):void
		{
			PlayerLevels.List(this.ListLoaded, {mode: "newest", customfilters: {difficulty: "hard"}});
		}
		
		private function ListLoaded(levels:Array, numlevels:int, response:Object):void
		{
			if(response.Success)
			{
				trace("Loaded " + levels.length + " out of " + numlevels + " levels in total");
				
				for each(var level:PlayerLevel in levels)
				{
					trace(" -> " + level.LevelId + ": " + level.Name + " / " + level.CustomData["difficulty"]);
				}
			}
			else
			{
				trace("Levels failed to load (" + response.ErrorCode + ")");
			}
		}		
		
		private function Save(e:MouseEvent):void
		{
			var level:PlayerLevel = new PlayerLevel();
			level.PlayerId = 0;
			level.PlayerName = "usera";
			level.Name = "asdfsdafasdf " + Math.random();
			level.Data = "asdfsdafasdf";
			level.CustomData["difficulty"] = Math.random() < 0.5 ? "hard" : "easy";
			
			PlayerLevels.Save(level, this.SampleThumb, this.SaveComplete);
		}
		
		private function SaveComplete(level:PlayerLevel, response:Object):void
		{
			if(response.Success)
			{
				trace("Save complete: " + level.LevelId);
			}
			else
			{
				trace("Level failed to save (" + response.ErrorCode + ")");
			}
		}
		
		private function Load(e:MouseEvent):void
		{
			PlayerLevels.Load("4cce32a4cf1e8c2108000019", this.LoadComplete);
		}
		
		private function LoadComplete(level:PlayerLevel, response:Object):void
		{
			if(response.Success)
			{
				trace("Load complete: " + level.LevelId);
			}
			else
			{
				trace("An error occurred loading the level (" + response.ErrorCode + ")");
			}
		}
	}
}