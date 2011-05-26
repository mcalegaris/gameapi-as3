package Playtomic.type{
	public class SaveOptions extends Object{
		public var fbuserid:String;
		public var highest:Boolean = true;
		public var allowduplicates:Boolean = false;
		
		public function SaveOptions(highest:Boolean = true, allowduplicates:Boolean = false){
			this.highest=highest;
			this.allowduplicates=allowduplicates;
		}
		
		public function toString():String{
			var str:String = "::SaveOptions::\n";
			str += " highest: "+highest;
			str += "\n";
			str += " allowduplicates: "+allowduplicates;
			return str;
		}
		
	}
}