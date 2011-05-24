﻿//  This file is part of the official Playtomic API for ActionScript 3 games.  
//  Playtomic is a real time analytics platform for casual games 
//  and services that go in casual games.  If you haven't used it 
//  before check it out:
//  http://playtomic.com/
//
//  Created by ben at the above domain on 2/25/11.
//  Copyright 2011 Playtomic LLC. All rights reserved.
//
//  Documentation is available at:
//  http://playtomic.com/api/as3
//
// PLEASE NOTE:
// You may modify this SDK if you wish but be kind to our servers.  Be
// careful about modifying the analytics stuff as it may give you 
// borked reports.
//
// If you make any awesome improvements feel free to let us know!
//
// -------------------------------------------------------------------------
// THIS SOFTWARE IS PROVIDED BY PLAYTOMIC, LLC "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package Playtomic
{
	import flash.events.IOErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;

	public final class Data
	{
		// ------------------------------------------------------------------------------
		// General stats
		// ------------------------------------------------------------------------------
		public static function Views(callback:Function, options:Object=null):void
		{
			if(options == null)
				options = new Object();
				
			var day:int = options.hasOwnProperty("day") ? options["day"] : 0;
			var month:int = options.hasOwnProperty("month") ? options["month"] : 0;
			var year:int = options.hasOwnProperty("year") ? options["year"] : 0;
			
			General("Views", callback, day, month, year);
		}
		
		public static function Plays(callback:Function, options:Object=null):void
		{
			if(options == null)
				options = new Object();
				
			var day:int = options.hasOwnProperty("day") ? options["day"] : 0;
			var month:int = options.hasOwnProperty("month") ? options["month"] : 0;
			var year:int = options.hasOwnProperty("year") ? options["year"] : 0;
			
			General("Plays", callback, day, month, year);
		}
		
		public static function PlayTime(callback:Function, options:Object=null):void
		{
			if(options == null)
				options = new Object();
			
			var day:int = options.hasOwnProperty("day") ? options["day"] : 0;
			var month:int = options.hasOwnProperty("month") ? options["month"] : 0;
			var year:int = options.hasOwnProperty("year") ? options["year"] : 0;
			
			General("Playtime", callback, day, month, year);
		}
		
		private static function General(type:String, callback:Function, day:int, month:int, year:int):void
		{
			var handled:Boolean = false;
			
			var bridge:Function = function():void
			{	
				if(callback == null || handled)
					return;
					
				handled = true;
							
				var data:XML = XML(sendaction["data"]);
				var status:int = parseInt(data["status"]);
				var errorcode:int = parseInt(data["errorcode"]);
				
				if(status == 1)
				{				
					result.Value = int(data["value"]);
				}
				
				callback(result, {Success: status == 1, ErrorCode: errorcode});
			}
				
			var fail:Function = function():void
			{
				if(callback == null || handled)
					return;
			
				handled = true;

				callback(result, {Success: false, ErrorCode: 1});
			}

			var httpstatusignore:Function = function():void
			{

			}

			var result:Object = {Name: type, Day: day, Month: month, Year: year, Value: 0};
			
			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(Event.COMPLETE, bridge);
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, fail);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatusignore);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
			sendaction.load(new URLRequest("http://g" + Log.GUID + ".api.playtomic.com/data/" + type + ".aspx?swfid=" + Log.SWFID + "&day=" + day + "&month=" + month + "&year=" + year + "&" + Math.random()));
		}

		// ------------------------------------------------------------------------------
		// Custom metrics
		// ------------------------------------------------------------------------------
		public static function CustomMetric(metric:String, callback:Function, options:Object = null):void
		{
			if(options == null)
				options = new Object();
				
			var day:int = options.hasOwnProperty("day") ? options["day"] : 0;
			var month:int = options.hasOwnProperty("month") ? options["month"] : 0;
			var year:int = options.hasOwnProperty("year") ? options["year"] : 0;
			var handled:Boolean = false;
			
			var bridge:Function = function():void
			{	
				if(callback == null || handled)
					return;
					
				handled = true;
				
				var data:XML = XML(sendaction["data"]);
				var status:int = parseInt(data["status"]);
				var errorcode:int = parseInt(data["errorcode"]);
				
				if(status == 1)
				{
					result.Value = int(data["value"]);
				}
				
				callback(result, {Success: status == 1, ErrorCode: errorcode});
			}
			
			var fail:Function = function():void
			{
				if(callback == null || handled)
					return;
					
				handled = true;
				callback(result, {Success: false, ErrorCode: 1});
			}
			
			var httpstatusignore:Function = function():void
			{
			}

			var result:Object = {Name: "CustomMetric", Metric: metric, Day: day, Month: month, Year: year, Value: 0};
			
			var sendaction:URLLoader = new URLLoader();
			sendaction.addEventListener(Event.COMPLETE, bridge);
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, fail);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatusignore);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
			sendaction.load(new URLRequest("http://g" + Log.GUID + ".api.playtomic.com/data/custommetric.aspx?swfid=" + Log.SWFID + "&metric=" + escape(metric) + "&day=" + day + "&month=" + month + "&year=" + year + "&" + Math.random()));
		}
		
		// ------------------------------------------------------------------------------
		// Level metrics
		// ------------------------------------------------------------------------------
		public static function LevelCounterMetric(metric:String, level:*, callback:Function, options:Object = null):void
		{
			if(options == null)
				options = new Object();
				
			var day:int = options.hasOwnProperty("day") ? options["day"] : 0;
			var month:int = options.hasOwnProperty("month") ? options["month"] : 0;
			var year:int = options.hasOwnProperty("year") ? options["year"] : 0;
			var bridge:Function = null;
			var handled:Boolean = false;
			
			if(callback != null)
			{			
				bridge = function(sendaction:URLLoader):void
				{	
					if(callback == null || handled)
						return;
						
					handled = true;
					
					var data:XML = XML(sendaction["data"]);
					var status:int = parseInt(data["status"]);
					var errorcode:int = parseInt(data["errorcode"]);
					
					if(status == 1)
					{					
						result.Value = int(data["value"]);
					}
					
					callback(result, {Success: status == 1, ErrorCode: errorcode});
				}
			}
			
			var fail:Function = function():void
			{
				if(callback == null || handled)
					return;
					
				handled = true;
				callback(result, {Success: false, ErrorCode: 1});
			}

			var result:Object = {Name: "LevelCounterMetric", Metric: metric, Level: level, Day: day, Month: month, Year: year, Value: 0};
			
			LevelMetric("Counter", metric, level, bridge, fail, day, month, year);
		}
		
		public static function LevelRangedMetric(metric:String, level:*, callback:Function, options:Object = null):void
		{
			if(options == null)
				options = new Object();
				
			var day:int = options.hasOwnProperty("day") ? options["day"] : 0;
			var month:int = options.hasOwnProperty("month") ? options["month"] : 0;
			var year:int = options.hasOwnProperty("year") ? options["year"] : 0;
			var bridge:Function = null;
			var handled:Boolean = false;
			
			if(callback != null)
			{			
				bridge = function(sendaction:URLLoader):void
				{	
					if(callback == null || handled)
						return;
						
					handled = true;
	
					var data:XML = XML(sendaction["data"]);
					var status:int = parseInt(data["status"]);
					var errorcode:int = parseInt(data["errorcode"]);
					
					if(status == 1)
					{					
						var values:Array = new Array();
						var list:XMLList = data["value"];
						var n:XML;
						
						for each(n in list)
							result.Values.push({Value: int(n.@trackvalue), Occurances: int(n)});	
					}
					
					callback(result, {Success: status == 1, ErrorCode: errorcode});
				}
			}
			
			var fail:Function = function():void
			{
				if(callback == null || handled)
					return;
					
				handled = true;
				
				callback(result, {Success: false, ErrorCode: 1});
			}	
			
			var result:Object = {Name: "LevelRangedMetric", Metric: metric, Level: level, Day: day, Month: month, Year: year, Values: []};
			
			LevelMetric("Ranged", metric, level, bridge, fail, day, month, year);
		}
		
		public static function LevelAverageMetric(metric:String, level:*, callback:Function, options:Object = null):void
		{
			if(options == null)
				options = new Object();
				
			var day:int = options.hasOwnProperty("day") ? options["day"] : 0;
			var month:int = options.hasOwnProperty("month") ? options["month"] : 0;
			var year:int = options.hasOwnProperty("year") ? options["year"] : 0;		
			var bridge:Function = null;
			var handled:Boolean = false;
			
			if(callback != null)
			{			
				bridge = function(sendaction:URLLoader):void
				{	
					if(callback == null || handled)
						return;
						
					handled = true;
	
					var data:XML = XML(sendaction["data"]);
					var status:int = parseInt(data["status"]);
					var errorcode:int = parseInt(data["errorcode"]);
					
					if(status == 1)
					{
						result.Min = int(data["min"]);
						result.Max = int(data["max"]);
						result.Average = int(data["average"]);
						result.Total = Number(data["total"]);
					}
					
					callback(result, {Success: status == 1, ErrorCode: errorcode});
				}
			}

			var fail:Function = function():void
			{
				if(callback == null || handled)
					return;
					
				handled = true;
					
				callback(result, {Success: false, ErrorCode: 1});
			}

			var result:Object = {Name: "LevelAverageMetric", Metric: metric, Level: level, Day: day, Month: month, Year: year, Min: 0, Max: 0, Average: 0, Total:0};
			
			LevelMetric("Average", metric, level, bridge, fail, day, month, year);
		}
		
		private static function LevelMetric(type:String, metric:String, level:*, callback:Function, fail:Function, day:int, month:int, year:int):void
		{
			var httpstatusignore:Function = function():void
			{
			}
			
			var sendaction:URLLoader = new URLLoader();
			
			if(callback != null)
			{
				var bridge:Function = function():void
				{
					if(callback == null)
						return;

					callback(sendaction);
				}
			
				sendaction.addEventListener(Event.COMPLETE, bridge);
			}
				
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, fail);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatusignore);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
			sendaction.load(new URLRequest("http://g" + Log.GUID + ".api.playtomic.com/data/levelmetric" + type + ".aspx?swfid=" + Log.SWFID + "&metric=" + escape(metric) + "&level=" + escape(level) + "&day=" + day + "&month=" + month + "&year=" + year + "&" + Math.random()));
		}
	}
}