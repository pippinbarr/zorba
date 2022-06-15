package
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class ZorbaState extends FlxState
	{
		
		private var _ai:AI;
		private var _music:Music;
		private var _uis:Array;
		private var _dancers:Array;
		private const DANCER_Y:uint = FlxG.height / 2;
		
		private var _bg:FlxSprite;
		private var _zorbaDrawBG:FlxSprite;
		private var _openText:String;
		private var _openTextField:TextField;
		private var _openTextFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _concedeText:TextField;
		private var _concedeTextFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _resultText:String;
		private var _resultTextField:TextField;
		private var _resultTextFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _zorbaDrawTextField:TextField;
		private var _zorbaDrawTextFormat:TextFormat = new TextFormat("COMMODORE",48,0x000000,null,null,null,null,null,"center",null,null);
		private var _zorbaDraw:Boolean = false;
		
		private var _timer:FlxTimer;
		private var _dancing:Boolean = false;
		private var _conceding:Boolean = false; // Whether one of the players is conceding
		private var _playerConceded:Boolean = false;
		private var _addDancers:Boolean = false;
				
		private var _time:Number = 0;
		
		public function ZorbaState() {
			super();
		}
		
		public override function create():void {
			super.create();
			
			_timer = new FlxTimer();
			_ai = new AI("ZORBA",1.0,0.0);
			_music = new Music();

			FlxG.bgColor = 0xFFCCCCCC;
			
			_bg = new FlxSprite(0,0);
			_bg.loadGraphic(Assets.ZORBA_BEACH,false,false,FlxG.width,FlxG.height);
			
			_uis = new Array();
			_uis.push(new UI(Cookie.name,true,false,null,"ARROWS","LEFT"));
			_uis.push(new UI("ZORBA",false,false,_ai,"ARROWS","RIGHT"));
			
			_dancers = new Array();
			_dancers.push(new Dancer((FlxG.width / 3) - 50, -100, Assets.AVATAR_SHEET));
			_dancers.push(new Dancer((2 * FlxG.width / 3) - 50, -100, Assets.ZORBA_SHEET));
			
			_openText = _uis[0].getName() + " VERSUS " + _uis[1].getName();
			_openTextField = Helpers.makeTextField(0,FlxG.height/2 - 40,FlxG.width,50,_openText,_openTextFormat);
						
			add(_bg);
			add(_uis[0]);
			add(_uis[1]);
			add(_dancers[0]);
			add(_dancers[1]);
			
			_timer.start(1,1,addDancers);			
		}
		
		private function addDancers(t:FlxTimer):void {
			_addDancers = true;
		}
		
		private function addStartText(t:FlxTimer):void {
			Assets._failSound.play();
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
				_timer.start(1,1,startDancing);
			}
		}
		
		private function startDancing(t:FlxTimer):void {
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
				
				// UPDATE AI
				_ai.update();
				
				if (!_uis[0].playing() && !_conceding) {
					_conceding = true;
					_timer.start(1,1,showConcede);
				}
				
				// PROCESS THE DANCING
				_dancers[0].process(_uis[0].stepResult());
				_dancers[1].process(_uis[1].stepResult());
				
				// GET STEP INFORMATION
				var step:int = _music.step();
				
				// CHANGE DANCER RATES
				_dancers[0].changeSpeed(_music.getSpeed());
				_dancers[1].changeSpeed(_music.getSpeed());
								
				// SONG FINISHED, OR BOTH HAVE FAILED, OR PLAYER HAS CONCEDED
				if (step == Music.SONG_COMPLETE || _playerConceded || !_uis[0].dancing() && !_uis[1].dancing()) {
					gameOver();
				}
				// SONG PLAYING, NO DANCE STEP
				else if (step == Music.NO_STEP) {
					return; 
				}
				// SONG PLAYING, DANCE STEP
				else if (!_uis[0].dancing()) { // If player is game over, then give to AI
					if (_uis[1].dancing()) {
						_uis[1].addSymbol();
					}
				}
				else if (!_uis[1].dancing()) { // If AI is game over, then give to player
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
		
		private function showConcede(t:FlxTimer):void {
			if (_dancing) {
				_concedeText = Helpers.makeTextField(0, FlxG.height/2 - 40, FlxG.width, 50, "PRESS SPACE TO CONCEDE", _concedeTextFormat);
				FlxG.stage.addChild(_concedeText);
				FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,concedeKeyDown);
			}
		}
		
		private function gameOver():void {
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,uiKeyDown);
			_uis[0].gameOver();
			_uis[1].gameOver();
			if (_uis[0].getScore() < _uis[1].getScore() || _playerConceded) {
				// PLAYER HAS LOWER SCORE OR CONCEDED
				_dancers[0].fail();
				_dancers[1].idle();
			}
			else if (_uis[0].getScore() > _uis[1].getScore()) {
				// PLAYER HAS HIGHER SCORE
				_dancers[0].idle();
				_dancers[1].fail();
			}
			else {
				// PLAYER AND AI HAVE EVEN SCORES
				_dancers[0].idle();
				_dancers[1].idle();
			}
			if (_music.step() != Music.SONG_COMPLETE) _music.stop();
			_dancing = false;
			_timer.start(3,1,showResult);
		}
		
		private function showResult(t:FlxTimer):void {
			if (_uis[0].getScore() < _uis[1].getScore() || _playerConceded) {
				// PLAYER HAS LOWER SCORE OR CONCEDED
				_resultText = "YOU LOSE! " + _uis[1].getName() + " WINS!";
				_dancers[0].fail();
				_dancers[1].victory();
			}
			else if (_uis[0].getScore() > _uis[1].getScore()) {
				// PLAYER HAS HIGHER SCORE
				_resultText = "YOU WIN! " + _uis[1].getName() + " LOSES!";
				_dancers[0].victory();
				_dancers[1].fail();
			}
			else {
				// PLAYER AND AI HAVE EVEN SCORES
				_resultText = "";
				_zorbaDrawTextField = Helpers.makeTextField(0,0,FlxG.width,100,"I NEVER LOVED A MAN MORE THAN YOU",_zorbaDrawTextFormat);
				_dancers[0].victory();
				_dancers[1].victory();
				_zorbaDrawBG = new FlxSprite();
				_zorbaDrawBG.loadGraphic(Assets.ZORBA_DRAW,false,false,FlxG.width,FlxG.height);
				_uis[0].removeText(); _uis[1].removeText();
				add(_zorbaDrawBG);
				FlxG.stage.addChild(_zorbaDrawTextField);
				_zorbaDraw = true;
			}
			if (_zorbaDraw) {
				_resultTextField = Helpers.makeTextField(0,FlxG.height - 32,FlxG.width,50,_resultText,_resultTextFormat);
			}
			else {
				_resultTextField = Helpers.makeTextField(0,FlxG.height/2 - 40,FlxG.width,50,_resultText,_resultTextFormat);
			}
			Assets._victorySound.play();
			if (_concedeText != null && FlxG.stage.contains(_concedeText)) FlxG.stage.removeChild(_concedeText);
			FlxG.stage.addChild(_resultTextField);
			
			_timer.start(1,1,showEndOptions);
		}
		
		private function showEndOptions(t:FlxTimer):void {
			if (_zorbaDraw) {
				_resultTextField.text = ("(R)ETRY         (M)ENU");
			}
			else {
				_resultTextField.appendText("\n(R)ETRY    (M)ENU");
			}
			Assets._failSound.play(true);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,endOptionsKeyDown);
		}
		
		private function concedeKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SPACE) {
				Assets._failSound.play(true);
				FlxG.stage.removeChild(_concedeText);
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,concedeKeyDown);
				_playerConceded = true;
				gameOver();
			}
		}
		
		private function uiKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.Q) {
				Assets._failSound.play(true);
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,uiKeyDown);
				FlxG.switchState(new TitleState);
			}
		}
		
		private function endOptionsKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.R) {
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,endOptionsKeyDown);
				Assets._failSound.play(true);
				FlxG.switchState(new ZorbaState);
			}
			else if (e.keyCode == Keyboard.M) {
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,endOptionsKeyDown);
				Assets._failSound.play(true);
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
			if (_zorbaDrawBG != null) _zorbaDrawBG.destroy();
			if (_timer != null) _timer.destroy();
			//if (_uiSound != null) _uiSound.destroy();
			//if (_victorySound != null) _victorySound.destroy();
			
			if (_openTextField != null && FlxG.stage.contains(this._openTextField)) FlxG.stage.removeChild(this._openTextField);
			if (_zorbaDrawTextField != null && FlxG.stage.contains(this._zorbaDrawTextField)) FlxG.stage.removeChild(this._zorbaDrawTextField);
			if (_concedeText != null && FlxG.stage.contains(this._concedeText)) FlxG.stage.removeChild(this._concedeText);
			if (_resultTextField != null && FlxG.stage.contains(this._resultTextField)) FlxG.stage.removeChild(this._resultTextField);

			FlxG.stage.focus = null;

		}
		
		
	}
}