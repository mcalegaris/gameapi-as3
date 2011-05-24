//  This file is part of the official Playtomic API for ActionScript 3 games.  
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
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import Playtomic.type.Response;

	public class Leaderboards
	{
		//, score:PlayerScore, rank:int (should eventually be in the callback)
		//callback signature: callback(scores:Array, numscores:int, response:Response):void
		public static function SaveAndList(score:PlayerScore, table:String, callback:Function = null, options:Object=null):void
		{
			if(options == null)
				options = new Object();
			
			var facebook:Boolean = options.hasOwnProperty("facebook") ? options["facebook"] : false;
			var allowduplicates:Boolean = options.hasOwnProperty("allowduplicates") ? options["allowduplicates"] : false;
			var global:Boolean = options.hasOwnProperty("global") ? options["global"] : true;
			var highest:Boolean = options.hasOwnProperty("highest") ? options["highest"] : true;
			var mode:String = options.hasOwnProperty("mode") ? options["mode"] : "alltime";
			var customfilters:Object = options.hasOwnProperty("customfilters") ? options["customfilters"] : {};
			var page:int = options.hasOwnProperty("page") ? options["page"] : 1;
			var perpage:int = options.hasOwnProperty("perpage") ? options["perpage"] : 20;
			var friendslist:Array = options.hasOwnProperty("friendslist") ? options["friendslist"] : new Array();
			
			var sendaction:URLLoader = new URLLoader();
			var handled:Boolean = false;

			if(callback != null)
			{
				var bridge:Function = function():void
				{	
					if(callback == null || handled)
						return;
						
					handled = true;
					ProcessScores(sendaction, callback);
				}

				sendaction.addEventListener(Event.COMPLETE, bridge);
			}

			var fail:Function = function():void
			{
				if(callback == null || handled)
					return;
					
				handled = true;
					
				callback([], 0, new Response(false,  1));
			}
			
			var httpstatusignore:Function = function():void
			{
				
			}
			
			var postdata:URLVariables = new URLVariables();			
			var numcustomfilters:int = 0;
			
			if(customfilters != null)
			{
				for(var key:String in customfilters)
				{
					postdata["ckey" + numcustomfilters] = key;
					postdata["cdata" + numcustomfilters] = escape(customfilters[key]);
					numcustomfilters++;
				}
			}
						
			var request:URLRequest = new URLRequest("http://g" + Log.GUID +".api.playtomic.com/leaderboards/saveandlist.aspx?swfid=" + Log.SWFID + "&url=" + (global || Log.SourceUrl == null ? "global" : Log.SourceUrl) + "&r=" + Math.random());
			request.data = postdata;
			request.method = URLRequestMethod.POST;			
			
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, fail);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatusignore);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
			sendaction.load(request);
		}
		
		//callback signature: callback(scores:Array, numscores:int, response:Response):void
		public static function List(table:String, callback:Function, options:Object = null):void
		{
			if(options == null)
				options = new Object();

			var global:Boolean = options.hasOwnProperty("global") ? options["global"] : true;
			var highest:Boolean = options.hasOwnProperty("highest") ? options["highest"] : true;
			var mode:String = options.hasOwnProperty("mode") ? options["mode"] : "alltime";
			var customfilters:Object = options.hasOwnProperty("customfilters") ? options["customfilters"] : {};
			var page:int = options.hasOwnProperty("page") ? options["page"] : 1;
			var perpage:int = options.hasOwnProperty("perpage") ? options["perpage"] : 20;
			var sendaction:URLLoader = new URLLoader();
			var handled:Boolean = false;

			if(callback != null)
			{
				var bridge:Function = function():void
				{	
					if(callback == null || handled)
						return;
						
					handled = true;
					ProcessScores(sendaction, callback);
				}

				sendaction.addEventListener(Event.COMPLETE, bridge);
			}

			var fail:Function = function():void
			{
				if(callback == null || handled)
					return;
					
				handled = true;
					
				callback([], 0, new Response(false,  1));
			}
			
			var httpstatusignore:Function = function():void
			{
				
			}
			
			var postdata:URLVariables = new URLVariables();			
			var numcustomfilters:int = 0;
			
			if(customfilters != null)
			{
				for(var key:String in customfilters)
				{
					postdata["ckey" + numcustomfilters] = key;
					postdata["cdata" + numcustomfilters] = escape(customfilters[key]);
					numcustomfilters++;
				}
			}
			
			//will be swiching to using postdata more, once Vx/list.aspx is ready.
			//var request:URLRequest = new URLRequest("http://g" + Log.GUID +".api.playtomic.com/leaderboards/list.aspx?swfid=" + Log.SWFID + "&url=" + (global || Log.SourceUrl == null ? "global" : Log.SourceUrl) + "&r=" + Math.random());
			
			var request:URLRequest = new URLRequest("http://g" + Log.GUID + ".api.playtomic.com/leaderboards/list.aspx?swfid=" + Log.SWFID + "&table=" + table + "&mode=" + mode + "&filters=" + numcustomfilters + "&url=" + (global || Log.SourceUrl == null ? "global" : Log.SourceUrl) + "&highest=" + (highest ? "y" : "n") + "&page=" + page + "&perpage=" + perpage + "&" + Math.random());
			request.data = postdata;
			request.method = URLRequestMethod.POST;			
			
			sendaction.addEventListener(IOErrorEvent.IO_ERROR, fail);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatusignore);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
			sendaction.load(request);
		}
		
		//callback signature: callback(scores:Array, numscores:int, response:Response):void
		public static function ListFB(table:String, callback:Function, options:Object = null):void
		{
			if(options == null)
				options = new Object();
			
			var global:Boolean = options.hasOwnProperty("global") ? options["global"] : true;
			var highest:Boolean = options.hasOwnProperty("highest") ? options["highest"] : true;
			var friendslist:Array = options.hasOwnProperty("friendslist") ? options["friendslist"] : new Array();
			var mode:String = options.hasOwnProperty("mode") ? options["mode"] : "alltime";
			var customfilters:Object = options.hasOwnProperty("customfilters") ? options["customfilters"] : new Object();
			var page:int = options.hasOwnProperty("page") ? options["page"] : 1;
			var perpage:int = options.hasOwnProperty("perpage") ? options["perpage"] : 20;
			var sendaction:URLLoader = new URLLoader();
			var handled:Boolean = false;
			
			if(callback != null)
			{
				var bridge:Function = function():void
				{	
					if(callback == null || handled)
						return;
						
					handled = true;
					ProcessScores(sendaction, callback);
				}

				sendaction.addEventListener(Event.COMPLETE, bridge);
			}

			var fail:Function = function():void
			{
				if(callback == null || handled)
					return;
					
				handled = true;
					
				callback([], 0, new Response(false,  1));
			}
			
			var httpstatusignore:Function = function():void
			{
				
			}
			
			var postdata:URLVariables = new URLVariables();
			postdata["friendslist"] = friendslist.join(",");
			
			var numcustomfilters:int = 0;
			
			if(customfilters != null)
			{
				for(var key:String in customfilters)
				{
					postdata["ckey" + numcustomfilters] = key;
					postdata["cdata" + numcustomfilters] = escape(customfilters[key]);
					numcustomfilters++;
				}
			}
			
			//will be swiching to using postdata more, once Vx/list.aspx is ready.
			//var request:URLRequest = new URLRequest("http://g" + Log.GUID +".api.playtomic.com/leaderboards/listfb.aspx?swfid=" + Log.SWFID + "&url=" + (global || Log.SourceUrl == null ? "global" : Log.SourceUrl) + "&r=" + Math.random());
			
			var request:URLRequest = new URLRequest("http://g" + Log.GUID + ".api.playtomic.com/leaderboards/listfb.aspx?swfid=" + Log.SWFID + "&table=" + table + "&mode=" + mode + "&filters=" + numcustomfilters + "&url=" + (global || Log.SourceUrl == null ? "global" : Log.SourceUrl) + "&highest=" + (highest ? "y" : "n") + "&page=" + page + "&perpage=" + perpage + "&" + Math.random());
			request.data = postdata;
			request.method = URLRequestMethod.POST;

			sendaction.addEventListener(IOErrorEvent.IO_ERROR, fail);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatusignore);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
			sendaction.load(request);
		}
		
		//callback signature: callback(score:PlayerScore, response:Response):void
		public static function Save(score:PlayerScore, table:String, callback:Function = null, options:Object = null):void
		{
			if(options == null)
				options = new Object();
				
			var facebook:Boolean = options.hasOwnProperty("facebook") ? options["facebook"] : false;
			var allowduplicates:Boolean = options.hasOwnProperty("allowduplicates") ? options["allowduplicates"] : false;
			var highest:Boolean = options.hasOwnProperty("highest") ? options["highest"] : true;
			var sendaction:URLLoader = new URLLoader();
			var handled:Boolean = false;

			if(callback != null)
			{
				var bridge:Function = function():void
				{
					if(callback == null || handled)
						return;
						
					handled = true;
					
					var data:XML = XML(sendaction["data"]);
					var status:int = parseInt(data["status"]);
					
					if(status == 1)
					{					
						score.SDate = new Date();
						score.RDate = "Just now";
					}
					
					callback(score, new Response(status == 1,  parseInt(data["errorcode"])));
				}

				sendaction.addEventListener(Event.COMPLETE, bridge);
			}

			var fail:Function = function():void
			{
				if(callback == null || handled)
					return;
										
				handled = true;
				callback(score, new Response(false, 1));
			}
			
			var httpstatusignore:Function = function():void
			{
				
			}

			// save the score
			var s:String = score.Points.toString();
			
			if(s.indexOf(".") > -1)
				s = s.substring(0, s.indexOf("."));
			
			var postdata:URLVariables = new URLVariables();
			postdata["table"] = escape(table);
			postdata["highest"] = highest ? "y" : "n";
			postdata["name"] = escape(score.Name);
			postdata["points"] = s;
			postdata["allowduplicates"] = allowduplicates ? "y" : "n";
			postdata["auth"] = Encode.MD5(Log.SourceUrl + s);
			postdata["fb"] = facebook ? "y" : "n";
			postdata["fbuserid"] = score.FBUserId;
			
			var customfields:int = 0;
			
			if(score.CustomData != null)
			{
				for(var key:String in score.CustomData)
				{
					postdata["ckey" + customfields] = key;
					postdata["cdata" + customfields] = escape(score.CustomData[key]);
					customfields++;
				}
			}
						
			postdata["customfields"] = customfields;
			
			trace("POSTDATA: "+postdata.toString());

			var request:URLRequest = new URLRequest("http://g" + Log.GUID + ".api.playtomic.com/leaderboards/save.aspx?swfid=" + Log.SWFID + "&url=" + Log.SourceUrl + "&r=" + Math.random());
			request.data = postdata;
			request.method = URLRequestMethod.POST;

			sendaction.addEventListener(IOErrorEvent.IO_ERROR, fail);
			sendaction.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpstatusignore);
			sendaction.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
			sendaction.load(request);
		}

		private static function ProcessScores(loader:URLLoader, callback:Function):void
		{			
			var data:XML = XML(loader["data"]);
			var status:int = parseInt(data["status"]);
			var errorcode:int = parseInt(data["errorcode"]);
			var numscores:int = parseInt(data["numscores"]);
			var results:Array = new Array();
			
			if(status == 1)
			{
				var entries:XMLList = data["score"];
				var datestring:String;
				var year:int;
				var month:int;
				var day:int;
							
				for each(var item:XML in entries) 
				{
					datestring = item["sdate"];				
					year = int(datestring.substring(datestring.lastIndexOf("/") + 1));
					month = int(datestring.substring(0, datestring.indexOf("/")));
					day = int(datestring.substring(datestring.indexOf("/" ) +1).substring(0, 2));
					
					var score:PlayerScore = new PlayerScore();
					score.SDate = new Date(year, month-1, day);
					score.RDate = item["rdate"];
					score.Name = item["name"];
					score.Points = item["points"];
					score.Website = item["website"];
					
					if(item["fbuserid"])
						score.FBUserId = item["fbuserid"];
					
					if(item["custom"])
					{			
						var custom:XMLList = item["custom"];
						
						for each(var cfield:XML in custom.children())
						{
							score.CustomData[cfield.name()] = cfield.text();
						}
					}
					
					results.push(score);
				}
			}
			
			
			callback(results, numscores, new Response(status == 1, errorcode));
		}
	}
}