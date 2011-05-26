package Playtomic.type{
	public class cplResponse extends Object{
		
		public var TableId:String;
		public var Name:String;
		public var Bitly:String;
		public var Permalink:String;
		public var Highest:Boolean = true;
		public var RealName:String;
		
		public function cplResponse(TableId:String=null, Name:String=null, Bitly:String=null, Permalink:String=null, Highest:Boolean = false, RealName:String=null){
			this.TableId=TableId;
			this.Name=Name;
			this.Bitly=Bitly;
			this.Permalink=Permalink;
			this.Highest=Highest;
			this.RealName=RealName;
		}
		
		public function toString():String{
			var str:String = "::SaveOptions::\n";
			str += " Name: "+Name;
			str += "\n";
			str += " Bitly: "+Bitly;
			str += "\n";
			str += " Permalink: "+Permalink;
			str += "\n";
			str += " Highest: "+Highest;
			str += "\n";
			str += " RealName: "+RealName;
			return str;
		}
		
	}
}