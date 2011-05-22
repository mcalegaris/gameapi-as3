package Playtomic.type{
	public class Response{
		public var Success:Boolean = false;
		public var ErrorCode:int = -2;
		
		public function Response(success:Boolean, errorcode:int){
			Success = success;
			ErrorCode = errorcode;
		}
		
		public function toString():String{
			var str:String = "::Response::\n";
			str += " Success: "+Success;
			str += "\n";
			str += " ErrorCode: "+ErrorCode;
			str += "\n";
			str += " Error-Description: "+ERROR.descriptionByCode(ErrorCode);
			return str;
		}
	}
}