package
{
	
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class UI extends FlxGroup
	{
		
		public static const SUCCESS_STEP:int = 1;
		public static const FAIL_STEP:int = 0;
		public static const NO_STEP:int = -1;
		public static const GAME_OVER:int = -2;
		
		private var _ai:AI;
		
		private var _arrowBG:FlxSprite;
		private var _hitZone:FlxSprite;
		
		private var _incoming:Array = new Array();
		private var _incomingTimes:Array = new Array();
		private var _outgoing:Array = new Array();
		private var _outgoingTimes:Array = new Array();
		private var _healthBar:FlxSprite;
		
		private var _score:uint;
		private var _scoreText:TextField;
		private var _concedeText:TextField;
		private var _leftFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"left");
		private var _hiScoreText:TextField;
		private var _rightFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"right");
		private var _centerFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center");
		private var _leftHiScoreFormat:TextFormat = new TextFormat("COMMODORE",24,0x000000,null,null,null,null,null,"left");
		private var _rightHiScoreFormat:TextFormat = new TextFormat("COMMODORE",24,0x000000,null,null,null,null,null,"right");
		private var _multiplierFormat:TextFormat = new TextFormat("COMMODORE",40,0x000000,null,null,null,null,null,"center");
		private var _multiplier:uint = 1;
		private var _multiplierTextField:TextField;
		
		private var _name:String;
		private var _nameText:TextField;
		
		private var _successes:uint = 0;
		private var _healthRegenerationTimer:Number = 0.0;
		private var _healthRegenerationIncrementTimer:Number = 0.0;
		
		private var _dancing:Boolean = true;
		private var _currentFrame:uint = 0;
		
		private var _firstTime:Boolean = true;
		private var _fallen:Boolean = false;
		private var _standing:Boolean = true;
		private var _animating:Boolean = false;
		
		private var _swap:Boolean = false;
		
		private var _playing:Boolean = false;
		private var _conceded:Boolean = false;
				
		private var _timer:FlxTimer;
		
		private var _stepResult:int = NO_STEP;
		
		private var _practice:Boolean;
		private var _player:Boolean; // Whether this UI belongs to the player
		
		private var _multiplierVisible:Boolean = false;
		
		private var _symbolType:String;
		private var _arrowCodes:Array = new Array(37,38,40,39);
		private var _letterCodes:Array = new Array(Keyboard.A,Keyboard.W,Keyboard.S,Keyboard.D);
		
		private var _location:String;
		
		public function UI(name:String,player:Boolean,practice:Boolean,ai:AI,symbolType:String="ARROWS",location:String="",MaxSize:uint=0) {
			super(MaxSize);
			
			_symbolType = symbolType;
			
			_timer = new FlxTimer();
			
			_name = name;
			_player = player;
			_practice = practice;
			_ai = ai;
			_location = location;
			
			if (_ai != null) location == "RIGHT";						
		}
		
		private function setUpGameElements():void {
			_arrowBG = new FlxSprite();
			_arrowBG.makeGraphic(40,FlxG.height,0xAA333333);
			if (_location != "RIGHT") {
				_arrowBG.x = 0;
			}
			else {
				_arrowBG.x = FlxG.width - _arrowBG.width;
			}
			_arrowBG.y = 0;
			add(_arrowBG);
			
			_hitZone = new FlxSprite();
			_hitZone.loadGraphic(Assets.HITZONE_SHEET,true,false,40,10,false);
			_hitZone.addAnimation("fail",[2,0],10,false);
			_hitZone.addAnimation("success",[1,0],10,false);
			_hitZone.frame = 0;
			
			if (_location != "RIGHT") {
				_hitZone.x = 0;
			}
			else {
				_hitZone.x = FlxG.width - _hitZone.width;
			}
			_hitZone.y =  175;
			add(_hitZone);
			
			if (!_practice) {
				_healthBar = new FlxSprite();
				_healthBar.loadGraphic(Assets.HEALTHBAR_SHEET,true,false,120,5);
				_healthBar.addAnimation("fail",[1,0],10,false);
				_healthBar.frame = 0;
				_healthBar.scale.x = 1;
				
				if (_location != "RIGHT") {
					_healthBar.x = _arrowBG.width + 10; 
				}
				else {
					_healthBar.x = FlxG.width - 10 - _arrowBG.width - _healthBar.width;
					_healthBar.origin.x = _healthBar.width;
				}
				_healthBar.y = 0;
				_healthBar.origin.x = 0; _healthBar.origin.y = 0;
				add(_healthBar);
				
				_score = 0;
				if (_location != "RIGHT") {
					_nameText = Helpers.makeTextField(_healthBar.x,5,_healthBar.width,32,_name,_leftFormat);
					_scoreText = Helpers.makeTextField(_healthBar.x,20,_healthBar.width,32,_score.toString(),_leftFormat);
					_hiScoreText = Helpers.makeTextField(_healthBar.x,35,150,10,"HIGH SCORE!",_leftHiScoreFormat);
				}
				else {
					_nameText = Helpers.makeTextField(_healthBar.x,5,_healthBar.width,32,_name,_rightFormat);
					_scoreText = Helpers.makeTextField(_healthBar.x,20,_healthBar.width,32,_score.toString(),_rightFormat);
					_hiScoreText = Helpers.makeTextField(_healthBar.x,35,150,10,"HIGH SCORE!",_rightHiScoreFormat);
				}
			
				
				FlxG.stage.addChild(_scoreText);
				FlxG.stage.addChild(_nameText);
				
				if (_location != "RIGHT") {
					_multiplierTextField = Helpers.makeTextField((FlxG.width / 3) - 60,FlxG.height/2-20,120,32,"",_multiplierFormat);
				}
				else {
					_multiplierTextField = Helpers.makeTextField((2*FlxG.width / 3) - 60,FlxG.height/2-20,120,32,"",_multiplierFormat);	
				}				
			}
		}
		
		public function startDancing():void {
			_playing = true;
			setUpGameElements();
			
			if (_ai == null) {
				if (_player) {
					FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, playerDanceKeyDown);
				}
				else {
					FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, opponentDanceKeyDown);
				}
			}
		}
		
		public override function update():void {
			super.update();
			
			if (!_practice && _multiplierVisible) {
				_multiplierTextField.alpha -= 0.02;
				_multiplierTextField.y -= 2;
				if (_multiplierTextField.alpha <= 0.0) {
					FlxG.stage.removeChild(_multiplierTextField);
					_multiplierVisible = false;
				}
			}
			
			if (_playing) {
				
				moveOutgoing();
				
				moveIncoming();
				
				handleAIIncoming();
				
				if (!_practice) checkGameOver();
				
			}
			else {
				for (var i:uint = 0; i < _incoming.length; i++) {
					_incomingTimes[i] += FlxG.elapsed;
					_incoming[i].y = (0 - _incoming[i].height) + (_incomingTimes[i] / Globals.STEP_DELAY) * (_hitZone.y);
				}
				for (var j:uint = 0; j < _outgoing.length; j++) {
					_outgoingTimes[j] += FlxG.elapsed;
					_outgoing[j].y = (0 - _outgoing[j].height) + (_outgoingTimes[j] / Globals.STEP_DELAY) * (_hitZone.y);
				}
			}
			
		}
		
		public function stepResult():int {
			var result:int = _stepResult;
			_stepResult = NO_STEP;
			return result;
		}
		
		private function moveOutgoing():void {
			if (_outgoing.length > 0) {
				// Move along the outgoing sprites
				for (var j:uint = 0; j < _outgoing.length; j++) {
					_outgoingTimes[j] += FlxG.elapsed;
					_outgoing[j].y = (0 - _outgoing[j].height) + (_outgoingTimes[j] / Globals.STEP_DELAY) * (_hitZone.y);
				}
				// Check if the lowest outgoing sprite is offscreen
				if (_outgoing[0].y >= FlxG.height) {
					remove(_outgoing[0]);
					_outgoing.shift();
					_outgoingTimes.shift();
				}
			}
		}
		
		private function moveIncoming():void {
			if (_incoming.length > 0) {
				// Move down the incoming keys
				for (var i:uint = 0; i < _incoming.length; i++) {
					_incomingTimes[i] += FlxG.elapsed;
					_incoming[i].y = (0 - _incoming[i].height) + (_incomingTimes[i] / Globals.STEP_DELAY) * (_hitZone.y);
				}
				// Check if any incoming keys have moved below hitzone
				if (_dancing && _incoming[0].y >= _hitZone.y + _hitZone.height) {
					if (_player) Cookie.totalStepsMissed++;
					failure();
					_incoming[0].frame += Assets.RED_SYMBOL_OFFSET;
					_outgoing.push(_incoming.shift());
					_outgoingTimes.push(_incomingTimes.shift());
				}	
			}
		}
		
		private function handleAIIncoming():void {
			// Check if lowest incoming key is handled by the AI
			if (_ai != null && _incoming.length > 0) {
				if (_dancing && _incoming[0].overlapsAt(_incoming[0].x,_incoming[0].y-_incoming[0].height,_hitZone)) {
					if (!_ai.success()) {
						failure();
						// And remove it from _incoming so it can't be failed again
						_incoming[0].frame += Assets.RED_SYMBOL_OFFSET;
						_outgoing.push(_incoming.shift());
						_outgoingTimes.push(_incomingTimes.shift());
					}
					else {
						success();
					}
				}
			}
			
		}
		
		public function gameOver():void {
			_playing = false;
			_dancing = false;
			if (_ai == null) {
				if (_player) {
					FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, playerDanceKeyDown);
				}
				else {
					FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, opponentDanceKeyDown);
				}
			}		
		}
		
		private function checkGameOver():void {
			if (_healthBar.scale.x <= 0) {
				_dancing = false;
				_playing = false;
				if (_ai == null) {
					if (_player) {
						FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, playerDanceKeyDown);
					}
					else {
						FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, opponentDanceKeyDown);
					}
				}				}
		}
		
		public function addSymbol():void {
			trace("addSymbol called!");
			if (!_dancing) return;
			var arrowType:uint = Math.floor(Math.random()*4);
			_incoming.push(newSymbol(arrowType,true));
			_incomingTimes.push(0.0);
			add(_incoming[_incoming.length-1]);
		}
		
		private function newSymbol(type:uint,player:Boolean):FlxSprite {
			var symbol:FlxSprite = new FlxSprite();
			if (_symbolType == "LETTERS") {
				symbol.loadGraphic(Assets.LETTERS_SHEET,true,false,10,10);
			}
			else if (_symbolType == "ARROWS") {
				symbol.loadGraphic(Assets.ARROWS_SHEET,true,false,10,10);
			}
			symbol.frame = type;
			if (_location != "RIGHT") {
				symbol.x = 0 + (type * 10);
			}
			else {
				symbol.x = FlxG.width - _hitZone.width + (type * 10);
			}
			symbol.y = 0 - symbol.height;
			return symbol;
		}
		
		private function success():void {
			_stepResult = SUCCESS_STEP;
			Assets._successSound.play(true);
			_hitZone.play("success",true);
			
			_incoming[0].frame += Assets.GREEN_SYMBOL_OFFSET;
			_outgoing.push(_incoming.shift());
			_outgoingTimes.push(_incomingTimes.shift());
			
			if (!_practice) {
				incrementScore();
			}
			
			_successes++;
			if (_player) Cookie.totalStepsMade++;
			if (_player && _successes > Cookie.mostConsecutiveSteps) {
				Cookie.mostConsecutiveSteps = _successes;
			}
			if (!_practice && _successes % 20 == 0) {
				_multiplier *= 2;
				_multiplierTextField.text = _multiplier.toString() + "X";
				_multiplierTextField.alpha = 1.0;
				_multiplierTextField.y = (FlxG.height/2 * Globals.ZOOM) - 20;
				FlxG.stage.addChild(_multiplierTextField);
				_multiplierVisible = true;
			}
		}
		
		private function failure():void {
			
			_stepResult = FAIL_STEP;
			Assets._failSound.play(true);
			_hitZone.play("fail",true);
			if (!_practice) _healthBar.play("fail",true);
			
			_successes = 0;
			
			if (!_practice) {
				_multiplier = 1;
				_multiplierTextField.text = _multiplier.toString() + "X";
				_multiplierTextField.alpha = 1.0;
				_multiplierTextField.y = (FlxG.height/2 * Globals.ZOOM) - 20;
				FlxG.stage.addChild(_multiplierTextField);
				_multiplierVisible = true;
				
				loseHealth();
			}			
		}
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// SCORING / HEALTH
		///////////////////////////////////////////////////////////////////////////////////////////
		
		
		private function incrementScore():void {
			_score += (10 * _multiplier);
			_scoreText.text = _score.toString();
			if (_score > Cookie.hiScore && _player && !_practice) {
				Cookie.hiScore = _score;
				if (!FlxG.stage.contains(_hiScoreText)) FlxG.stage.addChild(_hiScoreText);
			}
		}
		
		private function regenerateHealth():void {
			if (_successes % Globals.HEALTH_REGENERATION_THRESHOLD == 0) {
				_healthBar.scale.x += 0.01;
			}
		}
		
		private function loseHealth():void {
			if (_healthBar.scale.x > 0) _healthBar.scale.x -= 0.05;
		}
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// GETTERS / SETTERS
		///////////////////////////////////////////////////////////////////////////////////////////
		
		public function dancing():Boolean {
			return _dancing;
		}
		
		public function playing():Boolean {
			return _playing;
		}
		
		public function conceded():Boolean {
			return _conceded;
		}
		
		public function getScore():uint {
			return _score;
		}
		
		public function getName():String {
			return _name;
		}
		
		public function noIncoming():Boolean {
			return _incoming.length == 0;
		}
		
		public function isPlayer():Boolean {
			return _player;
		}
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// EVENT HANDLERS 
		///////////////////////////////////////////////////////////////////////////////////////////		
		
		private function playerDanceKeyDown(e:KeyboardEvent):void {
			if (_incoming.length == 0) return;
			
			// Check if the key pressed was even relevant
			if (_symbolType == "ARROWS" && _arrowCodes.indexOf(e.keyCode) == -1) {
				return;
			}
			else if (_symbolType == "LETTERS" && _letterCodes.indexOf(e.keyCode) == -1) {
				return;
			}
						
			if (_incoming[0].overlaps(_hitZone)) {
				if (_symbolType == "ARROWS") {
					// If the keycode matches the current key
					//if ((e.keyCode - 37 == _incoming[0].frame)) {
					if (e.keyCode == _arrowCodes[_incoming[0].frame]) {
						success();
					}
					// If the keycode matches one of their keys, but is wrong
					else {
						failure();
					}
				}
				else if (_symbolType == "LETTERS") {
					if ((e.keyCode == _letterCodes[_incoming[0].frame])) {
						success();
					}
					else {
						failure();
					}
				}
			}
			else {
				failure();
				// But don't move anything out of _incoming
			}
		}
		
		
		
		private function opponentDanceKeyDown(e:KeyboardEvent):void {
			if (_incoming.length == 0) return;
			
			// Check if the key pressed was even relevant
			if (_symbolType == "ARROWS" && _arrowCodes.indexOf(e.keyCode) == -1) {
				return;
			}
			else if (_symbolType == "LETTERS" && _letterCodes.indexOf(e.keyCode) == -1) {
				return;
			}
			
			if (_incoming[0].overlaps(_hitZone)) {
				if (_symbolType == "ARROWS") {
					// If the keycode matches the current key
					//if ((e.keyCode - 37 == _incoming[0].frame)) {
					if (e.keyCode == _arrowCodes[_incoming[0].frame]) {
						success();
					}
						// If the keycode matches one of their keys, but is wrong
					else {
						failure();
					}
				}
				else if (_symbolType == "LETTERS") {
					if ((e.keyCode == _letterCodes[_incoming[0].frame])) {
						success();
					}
					else {
						failure();
					}
				}
			}
			else {
				failure();
				// But don't move anything out of _incoming
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////
		// CLEAN UP 
		///////////////////////////////////////////////////////////////////////////////////////////
		
		public function removeText():void {
			// Clear away the textfields
			if (_scoreText != null && FlxG.stage.contains(_scoreText)) FlxG.stage.removeChild(_scoreText);
			if (_hiScoreText != null && FlxG.stage.contains(_hiScoreText)) FlxG.stage.removeChild(_hiScoreText);
			if (_nameText != null && FlxG.stage.contains(_nameText)) FlxG.stage.removeChild(_nameText);
			if (_multiplierTextField != null && FlxG.stage.contains(_multiplierTextField)) FlxG.stage.removeChild(_multiplierTextField);
		}
		
		public override function destroy():void {
			
			super.destroy();
			
			removeText();

			if (_healthBar != null) _healthBar.destroy();	
			if (_arrowBG != null) _arrowBG.destroy();
			if (_hitZone != null) _hitZone.destroy();

			for (var i:uint = 0; i < _incoming.length; i++) {
				_incoming[i].destroy();
			}
			for (var j:uint = 0; j < _outgoing.length; j++) {
				_outgoing[j].destroy();
			}
			
			if (_timer != null) _timer.destroy();
			//if (_successSound != null) _successSound.destroy();
			//if (_failSound != null) _failSound.destroy();
			
		}
	}
}