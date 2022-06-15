package
{
	
	import org.flixel.*;
	
	public class Cookie
	{	
		private static var _save:FlxSave;
		private static var _loaded:Boolean = false;
		
		private static var _tempName:String = "";	
		private static var _tempHiScore:uint = 0;
		private static var _longestDanceTemp:uint = 0;
		
		public function Cookie() {
		}
		
		public static function load():void {
			
			_save = new FlxSave();
			_loaded = _save.bind("ZorbaZorbaZorba");
			if (_loaded && _save.data.name == null) _save.data.name = "";
			if (_loaded && _save.data.hiScore == null) _save.data.hiScore = 0;
			if (_loaded && _save.data.longestDance == null) _save.data.longestDance = 0;
		}
		
		public static function flush():void {
			if (_loaded) _save.flush();
		}
		
		public static function erase():void {
			if (_loaded) _save.erase();
		}
		
		public static function set name(value:String):void {
			if (_loaded) {
				_save.data.name = value;
			}
			else {
				_tempName = value;
			}
		}
		
		public static function get name():String {
			if (_loaded)
			{
				return _save.data.name;
			}
			else
			{
				return _tempName;
			}
		}
		
		public static function set hiScore(value:uint):void {
			if (_loaded) {
				_save.data.hiScore = value;
			}
			else {
				_tempHiScore = value;
			}
		}
		
		public static function get hiScore():uint {
			if (_loaded)
			{
				return _save.data.hiScore;
			}
			else
			{
				return _tempHiScore;
			}
		}
		
		
		public static function set longestDance(value:uint):void {
			if (_loaded) {
				_save.data.longestDance = value;
			}
			else {
				_longestDanceTemp = value;
			}
		}
		
		public static function get longestDance():uint {
			if (_loaded)
			{
				return _save.data.longestDance;
			}
			else
			{
				return _longestDanceTemp;
			}
		}		
	}
}