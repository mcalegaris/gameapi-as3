package Playtomic 
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	import flash.utils.ByteArray;
	
	public final class Request extends URLLoader
	{
		private static var Pool:Vector.<Request>;
		private static var Queue:Vector.<Request>;
		private static var URLStub:String;
		private static var URLTail:String;
		private static var URL:String;
		
		private var urlRequest:URLRequest = new URLRequest();
		private var complete:Function;
		private var callback:Function;
		private var handled:Boolean;
		private var logging:Boolean;
		private var postdata:Object;
		private var time:int;
		
		internal static function Initialise():void
		{
			Pool = new Vector.<Request>();
			Queue = new Vector.<Request>();
			URLStub = "http://g" + Log.GUID + ".apitest.playtomic.com";
			URLTail = "swfid=" + Log.SWFID;
			URL = URLStub + "/v3/api.aspx?" + URLTail;
						
			var reqtimer:Timer = new Timer(500);
			reqtimer.addEventListener("timer", TimeoutHandler);
			reqtimer.start();
			
			for(var i:int=0; i<20; i++)
				Pool.push(new Request());
		}
		
		internal static function SendStatistics(complete:Function, url:String):void
		{
			var request:Request = Pool.length > 0 ? Pool.pop() : new Request();
			request.time = 0;
			request.handled = false;
			request.complete = complete;
			request.callback = null;
			request.logging = true;
			request.urlRequest.url = URLStub + url + (url.indexOf("?") > -1 ? "&" : "?") + URLTail + "&" + Math.random() + "Z";
			request.urlRequest.method = "GET";
			request.urlRequest.data = null;
			request.postdata = null;
			request.load(request.urlRequest);
			Queue.push(request);
		}
		
		internal static function Load(section:String, action:String, complete:Function, callback:Function, postdata:Object = null):void
		{
			trace("Request.Load " + section + " " + action);
			var request:Request = Pool.length > 0 ? Pool.pop() : new Request();
			request.time = 0;
			request.handled = false;
			request.complete = complete;
			request.callback = callback;
			request.logging = false;

			var url:String = URL + "&r=" + Math.random() + "Z";
			var timestamp:String = String(new Date().time).substring(0, 10);
			var nonce:String = Encode.MD5(new Date().time * Math.random() + Log.GUID);
			
			var pd:Array = new Array();
			pd.push("nonce=" + nonce);
			pd.push("timestamp=" + timestamp);
			
			for(var key:String in postdata)
				pd.push(key + "=" + encodeURIComponent(postdata[key]));
				
			trace("\npresig\n" + pd.join("\n"));
				
			GenerateKey("section", section, pd);
			GenerateKey("action", action, pd);
			GenerateKey("signature", nonce + timestamp + section + action + url + Log.GUID, pd);
			
			trace("\nposting\n" + pd.join("\n"));
			
			var pda:ByteArray = new ByteArray();
			pda.writeUTFBytes(pd.join("&"));
			pda.position = 0;
			
			var postvars:URLVariables = new URLVariables();
			postvars["data"] = escape(Encode.Base64(pda));
			
			request.urlRequest.url = url;
			request.urlRequest.method = "POST";
			request.urlRequest.data = postvars;
			request.postdata = postdata;
			
			//trace("posting data to " + url);

			request.load(request.urlRequest);
			Queue.push(request);
		}
		
		private static function GenerateKey(name:String, key:String, arr:Array):void
		{
			arr.sort();

			if(name == "section")
				trace("joined is " + arr.join("&"));
				
			arr.push(name + "=" + Encode.MD5(arr.join("&") + key));
		}

		private static function TimeoutHandler(e:Event):void
		{
			var request:Request;

			for(var n:int=Queue.length-1; n>-1; n--)
			{
				request = Queue[n];

				if(!request.handled)
				{
					request.time++;
	
					if(request.time < 1200)
						continue;
						
					if(request.logging)
						request.complete(false);
					else
						request.complete(request.callback, request.postdata, null, new Response(0, 3));
				}

				Queue.splice(n, 1);
				Dispose(request);
			}
		}

		public function Request()
		{
			addEventListener("ioError", Fail);
			addEventListener("networkError", Fail);
			addEventListener("verifyError", Fail);
			addEventListener("diskError", Fail);
			addEventListener("securityError", Fail);
			addEventListener("httpStatus", HTTPStatusIgnore);
			addEventListener("complete", Complete);
		}
				
		private static function Complete(e:Event):void
		{
			var request:Request = e.target as Request;

			if(request.handled)
				return;
				
			request.handled = true;
			
			if(request.logging)
			{
				request.complete(true);
				return;
			}
			
			trace(request.data);
			
			var data:XML = XML(request.data);
			var status:int = parseInt(data["status"]);
			var errorcode:int = parseInt(data["errorcode"]);

			request.complete(request.callback, request.postdata, data, new Response(status, errorcode));
		}
		
		private static function Fail(e:Event):void
		{
			trace("fail");
			var request:Request = e.target as Request;
			
			if(request.handled)
				return;
				
			request.handled = true;
			
			if(request.logging)
				request.complete(false);
			else
				request.complete(request.callback, request.postdata, null, new Response(0, 1));
		}

		private static function HTTPStatusIgnore(e:Event):void
		{
		}
		
		private static function Dispose(request:Request):void
		{
			if(!request.handled)
			{
				request.handled = true;
				request.close();
			}

			Pool.push(request);
		}		
	}
}
