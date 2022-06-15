package 
{
	
	import org.flixel.*;
	
	public class Dancer extends FlxSprite {
		
		private var _currentDanceFrame:uint = 0;
		private var _currentSpeed:Number = Globals.SPEEDS[0];
		private var _currentAnimName:String = "dance" + _currentSpeed.toString();
		
		private var _animating:Boolean = false;
		private var _failing:Boolean = false;
		private var _idling:Boolean = false;
		
		public function Dancer(X:int,Y:int,SHEET:Class) {
			super(X,Y,null);
			this.loadGraphic(SHEET,true,false,100,100,false);
			this.addAnimation("dance"+_currentSpeed.toString(),Assets.DANCE_FRAMES,_currentSpeed,true);
			//this.play("dance1.5");
			this.frame = 0 + Assets.IDLE_OFFSET;
			this._idling = true;
		}
		
		public override function update():void {
			super.update();
			if (_animating) {
				_currentDanceFrame = this.frame;
			}
		}
		
		public function changeSpeed(newSpeed:Number):void {
			if (newSpeed > _currentSpeed) {
				_currentSpeed = newSpeed;
				this.addAnimation("dance"+_currentSpeed.toString(),Assets.DANCE_FRAMES,_currentSpeed,true);
				if (_animating) this.playFromFrame("dance" + _currentSpeed.toString(),true,_currentDanceFrame);
			}
		}
		
		public function process(step:int):void {
			if (step == UI.FAIL_STEP) {
				failStep();
			}
			else if (step == UI.SUCCESS_STEP) {
				successStep();
			}
			else if (step == UI.NO_STEP) {
				// Do nothing
			}
			else if (step == UI.GAME_OVER) {
				fail();
			}
		}
		
		public function idle():void {
			if (!_failing) {
				this.frame = _currentDanceFrame + Assets.IDLE_OFFSET;
				this._animating = false;
				this._failing = false;
				this._idling = true;
			}
		}
		
		public function fail():void {
			this.frame = _currentDanceFrame + Assets.FAIL_OFFSET;
			this._animating = false;
			this._failing = true;
			this._idling = false;
		}
		
		public function victory():void {
			this.frame = _currentDanceFrame + Assets.VICTORY_OFFSET;
			this._animating = false;
			this._failing = false;
			this._idling = false;
		}
		
		public function successStep():void {
			if (_failing) {
				_idling = true;
				_failing = false;
				_animating = false;
				this.frame = _currentDanceFrame + Assets.IDLE_OFFSET;
			}
			else if (_idling) {
				_idling = false;
				_failing = false;
				_animating = true;
				this.playFromFrame("dance"+_currentSpeed.toString(),false,_currentDanceFrame);
			}
		}
		
		public function failStep():void {
			if (_idling || _animating) {
				_failing = true;
				_idling = false;
				_animating = false;
				this.frame = _currentDanceFrame + Assets.FAIL_OFFSET;
			}
		}
		
		public override function destroy():void {
			super.destroy();
		}
	}
}