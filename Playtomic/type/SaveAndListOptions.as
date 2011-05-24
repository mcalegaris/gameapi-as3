package Playtomic.type{
	
	import Playtomic.type.MODE;
	import flash.utils.getQualifiedClassName;
	
	public class SaveAndListOptions extends Object{
		public var facebook:Boolean = false;
		public var allowduplicates:Boolean = false;
		public var global:Boolean = true;
		public var highest:Boolean = true;
		public var mode:String = MODE.ALL;
		public var customfilters:Object = {};
		//public var page:int = 1;
		public var perpage:int = 20;
		
		public var friendslist:Array = new Array();
		
		
		
		public function SaveAndListOptions(allowduplicates:Boolean=false, global:Boolean = true, highest:Boolean = true, mode:String = "MODE.ALL", customfilters:Object = null, perpage:int = 20){
			if(mode == "MODE.ALL") mode = MODE.ALL;
			
			//this.facebook=facebook;
			this.allowduplicates=allowduplicates
			this.global=global;
			this.highest=highest;
			this.mode=mode;
			this.customfilters=customfilters;
			//this.page=page;
			this.perpage=perpage;
			//this.friendslist=friendslist;
		}
		public function toString():String{
			var str:String = "::PlayerScore::\n";
			str += " facebook: "+facebook;
			str += "\n";
			str += " allowduplicates: "+allowduplicates;
			str += "\n";
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
			str += " perpage: "+perpage;
			str += "\n";
			str += " friendslist: "+friendslist;
			
			return str;
		}
	}
}