package
{
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import org.flixel.*;
	
	public class Music {
		
		public static const NO_STEP:int = -1;
		public static const SONG_COMPLETE:int = -2;
		public static const PLAYER_1_STEP:int = 0;
		public static const PLAYER_2_STEP:int = 1;
		public static const BOTH_PLAYERS_STEP:int = 2;
		
		//private const OFFSET:uint = 220;
		//private const OFFSET:uint = 120;
		private const OFFSET:uint = 0;
		
		private var _turn:uint = 0;
		private var _steps:uint = 0;
		private var _turnsIndex:uint = 0;
		
		private var _time:Number = 0.0;
		private var _stepTimesIndex:uint = 0;
		
		private var _speeds:Array = new Array();
		
		private var _checkedStart:Boolean = false;
		private var _playing:Boolean = false;
		private var _zorbaSongExists:Boolean = false;
		
		public function Music() {
			
			// Randomly decide who will start
			if (Math.random() < 0.6) _turn = 0;
			else _turn = 1;
			
			// Set the stepTimesIndex based on the OFFSET
			for (var i:int = 0; i < Globals.STEP_TIMES.length; i++) {
				if (Globals.STEP_TIMES[i] >= OFFSET) {
					_stepTimesIndex = i;
					return;
				}
			}
		}
		
		public function play():void {
			Assets._zorbaChannel = Assets._zorbaSong.play(OFFSET*1000);
			_zorbaSongExists = true;
		}
		
		private function songComplete(e:Event):void {
			_playing = false;
		}
		
		public function getSpeed():Number {
			return Globals.SPEEDS[_turnsIndex];
		}
		
		public function step():int {
			
			var result:int = NO_STEP; // Default is -1 which means either the song hasn't start or there's no step
			
			if (!_zorbaSongExists) return -1;
			
			if (_checkedStart && _time + OFFSET >= (3 * 60) + 47.4) { // If the song started, but now is finished then indicate with -2
				_playing = false;
				return SONG_COMPLETE; // -2 means the song has finished
			}
			
			trace("AMP: " + Assets._zorbaChannel.rightPeak);
			if (!_checkedStart && Assets._zorbaChannel.rightPeak > 0) { // Check for whether the song has started by amplitude
				_checkedStart = true;
				_playing = true;
				trace("MUSIC OFFICIALLY PLAYING.");
			}
			
			if (_playing) _time += FlxG.elapsed; // Monitor the elapsed play time so we can synch
			
			// Check whether the current elapsed time matches up with a step time
			if (_stepTimesIndex < Globals.STEP_TIMES.length && 
				_time + Globals.STEP_DELAY + Globals.DELAY + OFFSET >= Globals.STEP_TIMES[_stepTimesIndex]) {
				
				// Increment counters that track where we're up to
				_stepTimesIndex++;				
				_steps++;
				
				// Check what result we should return (either together, or the appropriate turn)
				if (Globals.TURN_LENGTHS[_turnsIndex] == 75 || Globals.TURN_LENGTHS[_turnsIndex] == -1) {
					result = BOTH_PLAYERS_STEP;
				}
				else {
					result = _turn;
				}
				
				// Check if we've seen all the steps for this turn
				if (_steps == Globals.TURN_LENGTHS[_turnsIndex]) {
					_turn = (1 - _turn); // Change turns (this should work after "together" too)
					_steps = 0; // Start counting again
					_turnsIndex++; // Check against next turn length
				}
			}
			
			if (result != -1) trace("In step() returned " + result);
			
			return result;
		}
		
		public function trueStep():int {
			if (_time + Globals.DELAY + OFFSET + 0.3 >= Globals.STEP_TIMES[0]) {
				return 0;
			}
			return 1;
		}
		
		public function stop():void {
			if (Assets._zorbaChannel != null) {
				Assets._zorbaChannel.stop();
			}
		}
		
		public function destroy():void {
			stop();
			//FlxG.state.remove(Assets._zorbaSong);
		}
	}
}