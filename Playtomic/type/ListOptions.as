package Playtomic.type{
	
	import Playtomic.type.MODE;
	import flash.utils.getQualifiedClassName;
	
	public class ListOptions extends Object{
		public var global:Boolean = true;
		public var highest:Boolean = true;
		public var mode:String = MODE.ALL;
		public var customfilters:Object = {};
		public var page:int = 1;
		public var perpage:int = 20;
		public var facebook:Boolean = false;
		public var friendslist:Array = [];
		
		
		public function ListOptions(global:Boolean = true, highest:Boolean = true, mode:String = "MODE.ALL", customfilters:Object = null, page:int = 1, perpage:int = 20, facebook:Boolean=false, friendslist=null){
			if(mode == "MODE.ALL") mode = MODE.ALL;
			
			this.global=global;
			this.highest=highest;
			this.mode=mode;
			this.customfilters=customfilters;
			this.page=page;
			this.perpage=perpage;
			this.facebook=facebook;
			this.friendslist=friendslist;
		}
		public function toString():String{
			var str:String = "::PlayerScore::\n";
			str += " global: "+global;
			str += "\n";
			str += " highest: "+highest;
			str += "\n";
			str += " mode: "+mode;
			str += "\n";
			str += " customfilters>>\n"
			for(var val:* in customfilters){
				str += "   "+val+":"+getQualifiedClassName(customfilters[val])+" = "+customfilters[val];
				str += "\n";
			}
			str += " <<customfilters"
			str += " page: "+page;
			str += "\n";
			str += " perpage: "+perpage;
			str += "\n";
			str += " friendslist: "+friendslist;
			
			return str;
		}
	}
}