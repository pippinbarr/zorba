package
{
	
	import org.flixel.*;
	
	public class AI {
		
		private const MAX_HISTORY:uint = 5;
		
		private var _history:Array = new Array();
		private var _timeSinceLast:Number = 0.0;
		private var _name:String;
		private var _intelligence:Number;
		private var _reliability:Number;
		private var _toughness:Number;
		private var _fluster:Number;
		
		private var _conceded:Boolean = false; // Whether or not the AI gives up
		private var _conceding:Boolean = false; // Whether or not the AI is in the process of giving up
		
		private var _disconnected:Boolean = false;
		
		private var _concedeTimer:FlxTimer;
		private var _disconnectTimer:FlxTimer;
		
		public function AI(name:String,intelligence:Number,fluster:Number) {
			_name = name;
			_intelligence = intelligence;
			_fluster = fluster;
			
			_toughness = 10;
			_reliability = 0.7;
			
			_concedeTimer = new FlxTimer();
			_disconnectTimer = new FlxTimer();
		}
		
		public function setup():void {
			if (Math.random() > _reliability) {
				_disconnectTimer.start(Math.random() * ((3 * 60) + 40));
			}
		}
		
		public function update():void {
			_timeSinceLast += FlxG.elapsed;
		}
		
		public function success():Boolean {
			var roll:Number = Math.random();
			var result:Boolean;
			if (_timeSinceLast < 0.5) {
				result = roll < _intelligence - (0.5 - _timeSinceLast)*_fluster;
			}
			else {
				result = roll < _intelligence;
			}
			_history.push(result);
			if (_history.length > MAX_HISTORY) _history.shift();
			_timeSinceLast = 0.0;
			return result;
		}
		
		public function concede():Boolean {
			if (!_conceding) {
				// Set a timer for until the AI is willing to concede as a
				// random percentage of their toughness (+1 for the delay)
				if (Math.random() < 0.1) {
					// Never concedes
				}
				else {
					_concedeTimer.start(1 + _toughness * Math.random(),1,setConceded);
				}
				_conceding = true;
				return false;					
			}
			return _conceded;
		}
		
		private function setConceded(t:FlxTimer):void {
			_conceded = true;
		}
		
		private function setDisconnected(t:FlxTimer):void {
			_disconnected = true;
		}
		
		public function disconnected():Boolean {
			return _disconnected;
		}
		
		public function getName():String {
			return _name;
		}
		
	}
}