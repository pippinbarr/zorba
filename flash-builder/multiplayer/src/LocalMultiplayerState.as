package
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class LocalMultiplayerState extends FlxState
	{
		
		private var _ai:AI;
		private var _music:Music;
		private var _uis:Array;
		private var _dancers:Array;
		private const DANCER_Y:uint = FlxG.height / 2;
		
		private var _bg:FlxSprite;
		private var _openText:String;
		private var _openTextField:TextField;
		private var _openTextFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _concedeText:TextField;
		private var _concedeTextFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _resultText:String;
		private var _resultTextField:TextField;
		private var _resultTextFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _timer:FlxTimer;
		private var _dancing:Boolean = false;
		private var _playerConceding:Boolean = false; // Whether one of the players is conceding
		private var _opponentConceding:Boolean = false;
		private var _playerConceded:Boolean = false;
		private var _opponentConceded:Boolean = false;
		private var _addDancers:Boolean = false;
				
		private var _time:Number = 0;
		
		public function LocalMultiplayerState() {
			super();
		}
		
		public override function create():void {
			super.create();
			
			_timer = new FlxTimer();
			_music = new Music();
			
			FlxG.bgColor = 0xFFCCCCCC;
			
			_bg = new FlxSprite(0,0);
			_bg.loadGraphic(Assets.DANCE_STAGE,false,false,FlxG.width,FlxG.height);
			
			_uis = new Array();
			_dancers = new Array();
			
			if (Math.random() < 0.5) {
				_uis.push(new UI(Cookie.name,true,false,null,"LETTERS","LEFT"));
				_uis.push(new UI("LOCAL",false,false,null,"ARROWS","RIGHT"));
				_dancers.push(new Dancer((FlxG.width / 3) - 50, -100, Assets.AVATAR_SHEET));
				_dancers.push(new Dancer((2 * FlxG.width / 3) - 50, -100, Assets.OPPONENT_SHEET));
			}
			else {
				_uis.push(new UI("LOCAL",false,false,null,"LETTERS","LEFT"));
				_uis.push(new UI(Cookie.name,true,false,null,"ARROWS","RIGHT"));
				_dancers.push(new Dancer((FlxG.width / 3) - 50, -100, Assets.OPPONENT_SHEET));
				_dancers.push(new Dancer((2 * FlxG.width / 3) - 50, -100, Assets.AVATAR_SHEET));

			}
			
			add(_bg);
			add(_uis[0]);
			add(_uis[1]);
			add(_dancers[0]);
			add(_dancers[1]);
			
			_openTextField = Helpers.makeTextField(0,FlxG.height/2 - 40,FlxG.width,50,"",_openTextFormat);
			
			_timer.start(1,1,addDancers);			
		}
		
		private function addDancers(t:FlxTimer):void {
			_addDancers = true;
		}
		
		private function addStartText(t:FlxTimer):void {
			Assets._failSound.play();
			_openText = _uis[0].getName() + " VERSUS " + _uis[1].getName();
			_openTextField.text = _openText;
			FlxG.stage.addChild(_openTextField);
			_timer.start(1,1,checkReady);
		}
		
		private function checkReady(t:FlxTimer):void {
			Assets._failSound.play();
			_openTextField.appendText("\nPRESS SPACE TO START");
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,startKeyDown);
		}
		
		private function startKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SPACE) {
				Assets._failSound.play();
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,startKeyDown);
				FlxG.stage.removeChild(_openTextField);
				_timer.start(1,1,ready);
			}
		}
		
		private function ready(t:FlxTimer):void {
			_openTextField.text = "DANCE!"
			FlxG.stage.addChild(_openTextField);
			Assets._failSound.play();
			_timer.start(1.5,1,startDancing);
		}
		
		private function startDancing(t:FlxTimer):void {
			FlxG.stage.removeChild(_openTextField);
			_uis[0].startDancing();
			_uis[1].startDancing();
			_music.play();
			_dancing = true;
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,uiKeyDown);
		}
		
		public override function update():void {
			super.update();	
			
			if (_addDancers) {
				_dancers[0].y+=5;
				_dancers[1].y+=5;
				if (_dancers[0].y == DANCER_Y && _dancers[1].y == DANCER_Y) {
					Assets._failSound.play();
					_addDancers = false;
					_timer.start(1,1,addStartText);
				}
			}
			else if (_dancing) {
				
				// CHECK DANCE TIME RECORD
				if (_uis[0].playing()) {
					_time += FlxG.elapsed;
					if (_time > Cookie.longestDance) Cookie.longestDance = Math.floor(_time);
				}
				
				// PROCESS THE DANCING
				_dancers[0].process(_uis[0].stepResult());
				_dancers[1].process(_uis[1].stepResult());
				
				// GET STEP INFORMATION
				var step:int = _music.step();
				if (step != -1) trace("Step is " + step);
				
				// CHANGE DANCER RATES
				_dancers[0].changeSpeed(_music.getSpeed());
				_dancers[1].changeSpeed(_music.getSpeed());
				
				if (!_uis[0].playing() && _uis[1].playing() && !_playerConceding && !_opponentConceding) {
					if (_uis[0].isPlayer()) _playerConceding = true;
					else _opponentConceding = true;
					_timer.start(1,1,showConcede);
				}
				else if (_uis[0].playing() && !_uis[1].playing() && !_playerConceding && !_opponentConceding) {
					if (_uis[1].isPlayer()) _playerConceding = true;
					else _opponentConceding = true;
					_timer.start(1,1,showConcede);
				}
				
				// SONG FINISHED, OR BOTH HAVE FAILED, OR ONE HAS CONCEDED
				if (step == Music.SONG_COMPLETE || _playerConceded || _opponentConceded || (!_uis[0].dancing() && !_uis[1].dancing())) {
					gameOver(null);
				}
					// SONG PLAYING, NO DANCE STEP
				else if (step == Music.NO_STEP) {
					return; 
				}
					// SONG PLAYING, DANCE STEP
				else if (!_uis[0].dancing()) { // If left is game over, give to right
					if (_uis[1].dancing()) {
						_uis[1].addSymbol();
					}
				}
				else if (!_uis[1].dancing()) { // If right is game over, give to left
					if (_uis[0].dancing()) {
						_uis[0].addSymbol();
					}
				}
				else if (step == Music.BOTH_PLAYERS_STEP) { // If it's for both, then give to both
					_uis[0].addSymbol();
					_uis[1].addSymbol();
				}
				else { // If it's for a specific dancer (who is dancing) then give it to them
					_uis[step].addSymbol();
					if (_uis[1 - step].noIncoming()) _dancers[1 - step].idle(); // Other dancer should now stop dancing.
				}		
			}
		}
		
		
		
		// CONCEDING //
		
		private function showConcede(t:FlxTimer):void {
			if (_dancing) {
				if (_playerConceding) {
					if (_uis[0].isPlayer()) {
						_concedeText = Helpers.makeTextField(0, FlxG.height/2 - 40, FlxG.width, 50, _uis[0].getName() + " PRESS SPACE TO CONCEDE", _concedeTextFormat);
					}
					else {
						_concedeText = Helpers.makeTextField(0, FlxG.height/2 - 40, FlxG.width, 50, _uis[1].getName() + " PRESS SPACE TO CONCEDE", _concedeTextFormat);
					}
				}
				else if (_opponentConceding) {
					if (_uis[0].isPlayer()) {
						_concedeText = Helpers.makeTextField(0, FlxG.height/2 - 40, FlxG.width, 50, _uis[1].getName() + " PRESS SPACE TO CONCEDE", _concedeTextFormat);
					}
					else {
						_concedeText = Helpers.makeTextField(0, FlxG.height/2 - 40, FlxG.width, 50, _uis[0].getName() + " PRESS SPACE TO CONCEDE", _concedeTextFormat);
					}
				}
				FlxG.stage.addChild(_concedeText);
				FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,concedeKeyDown);
			}
		}
		
		private function concedeKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SPACE) {
				Assets._failSound.play(true);
				
				FlxG.stage.removeChild(_concedeText);
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,concedeKeyDown);
				
				_playerConceded = _playerConceding;
				_opponentConceded = _opponentConceding;
				
				_playerConceding = _opponentConceding = false;
				
				gameOver(null);
			}
		}
		
		
		
		
		
		// GAME OVER //
		
		
		private function gameOver(t:FlxTimer):void {
			
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,uiKeyDown);
			
			_uis[0].gameOver();
			_uis[1].gameOver();
			
			if (FlxG.stage.contains(_concedeText)) FlxG.stage.removeChild(_concedeText);
			
			if (_uis[0].getScore() == _uis[1].getScore() && !_playerConceded && !_opponentConceded) {
				// PLAYER AND OPPONENT HAVE EVEN SCORES
				_dancers[0].idle();
				_dancers[1].idle();
				Cookie.localDraws++;
			}
			else if (_playerConceded) {
				if (_uis[0].isPlayer()) {
					_dancers[0].fail();
					_dancers[1].idle();
				}
				else {
					_dancers[0].idle();
					_dancers[1].fail();
				}
				Cookie.localLosses++;
			}
			else if (_opponentConceded) {
				if (!_uis[0].isPlayer()) {
					_dancers[0].fail();
					_dancers[1].idle();
				}
				else {
					_dancers[0].idle();
					_dancers[1].fail();
				}
				Cookie.localWins++;
			}
			else if (_uis[0].getScore() < _uis[1].getScore()) {
				_dancers[0].fail();
				_dancers[1].idle();
				if (_uis[0].isPlayer()) Cookie.localLosses++;
				else Cookie.localWins++;
			}
			else if (_uis[0].getScore() > _uis[1].getScore()) {
				_dancers[0].idle();
				_dancers[1].fail();
				if (_uis[0].isPlayer()) Cookie.localWins++;
				else Cookie.localLosses++;
			}

			if (_music.step() != Music.SONG_COMPLETE) _music.stop();
			_dancing = false;
			_timer.start(3,1,showResult);
		}
		
		private function showResult(t:FlxTimer):void {
			if (_playerConceded) {
				if (_uis[0].isPlayer()) {
					_dancers[0].fail();
					_dancers[1].victory();
					_resultText = _uis[1].getName() + " WINS!\n" + _uis[0].getName() + " LOSES!";
				}
				else {
					_dancers[0].victory();
					_dancers[1].fail();
					_resultText = _uis[0].getName() + " WINS!\n" + _uis[1].getName() + " LOSES!";
				}
				Cookie.localLosses++;
			}
			else if (_opponentConceded) {
				if (!_uis[0].isPlayer()) {
					_dancers[0].fail();
					_dancers[1].victory();
					_resultText = _uis[1].getName() + " WINS!\n" + _uis[0].getName() + " LOSES!";
				}
				else {
					_dancers[0].victory();
					_dancers[1].fail();
					_resultText = _uis[0].getName() + " WINS!\n" + _uis[1].getName() + " LOSES!";
				}
			}
			else if (_uis[0].getScore() < _uis[1].getScore()) {
				// PLAYER HAS LOWER SCORE OR CONCEDED
				_resultText = _uis[1].getName() + " WINS!\n" + _uis[0].getName() + " LOSES!";
				_dancers[0].fail();
				_dancers[1].victory();
			}
			else if (_uis[0].getScore() > _uis[1].getScore()) {
				// PLAYER HAS HIGHER SCORE
				_resultText = _uis[0].getName() + " WINS!\n" + _uis[1].getName() + " LOSES!";
				_dancers[0].victory();
				_dancers[1].fail();
			}
			else {
				// PLAYER AND AI HAVE EVEN SCORES
				_resultText = _uis[1].getName() + " WINS!\n" + _uis[0].getName() + " WINS!";
				_dancers[0].victory();
				_dancers[1].victory();
			}
			_resultTextField = Helpers.makeTextField(0,FlxG.height/2 - 40,FlxG.width,50,_resultText,_resultTextFormat);
			Assets._victorySound.play();
			FlxG.stage.addChild(_resultTextField);
			
			_timer.start(1,1,showEndOptions);
		}
		
		private function showEndOptions(t:FlxTimer):void {
			_resultTextField.appendText("\n(R)EMATCH    (M)ENU");
			Assets._failSound.play(true);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,endOptionsKeyDown);
		}
		
		private function endOptionsKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.R) {
				Assets._failSound.play(true);
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,endOptionsKeyDown);
				FlxG.switchState(new LocalMultiplayerState);
			}
			else if (e.keyCode == Keyboard.M) {
				Assets._failSound.play(true);
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,endOptionsKeyDown);
				FlxG.switchState(new TitleState);
			}
			
		}

		
		private function uiKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.Q) {
				Assets._failSound.play(true);
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,uiKeyDown);
				// CAN'T PUNISH THIS BECAUSE WE DON'T KNOW WHO PRESSED IT
				FlxG.switchState(new TitleState);
			}
		}
		
		public override function destroy():void {
			super.destroy();
			
			_music.destroy();
			
			for (var i:uint = 0; i < _uis.length; i++) {
				_uis[i].destroy();
				_dancers[i].destroy();
			}
			
			if (_bg != null) _bg.destroy();
			if (_timer != null) _timer.destroy();
			//if (_uiSound != null) _uiSound.destroy();
			//if (_victorySound != null) _victorySound.destroy();
			
			if (_openTextField != null && FlxG.stage.contains(this._openTextField)) FlxG.stage.removeChild(this._openTextField);
			if (_concedeText != null && FlxG.stage.contains(this._concedeText)) FlxG.stage.removeChild(this._concedeText);
			if (_resultTextField != null && FlxG.stage.contains(this._resultTextField)) FlxG.stage.removeChild(this._resultTextField);
			
			FlxG.stage.focus = null;

		}
	}
}