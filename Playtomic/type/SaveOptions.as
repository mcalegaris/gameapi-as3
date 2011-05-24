package Playtomic.type{
	public class SaveOptions extends Object{
		public var facebook:Boolean = false;
		public var highest:Boolean = true;
		public var allowduplicates:Boolean = false;
		
		public function SaveOptions(facebook:Boolean = false, highest:Boolean = true, allowduplicates:Boolean = false){
			this.facebook=facebook;
			this.highest=highest;
			this.allowduplicates=allowduplicates;
		}
		
		public function toString():String{
			var str:String = "::SaveOptions::\n";
			str += " facebook: "+facebook;
			str += "\n";
			str += " highest: "+highest;
			str += "\n";
			str += " allowduplicates: "+allowduplicates;
			return str;
		}
		
	}
}