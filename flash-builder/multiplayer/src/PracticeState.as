package
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class PracticeState extends FlxState
	{
		
		private const TUTORIAL_TEXT:String = "" +
			"HERE'S HOW TO PLAY.\n\n" +
			"PRESS MATCHING ARROW KEYS WHEN AN ARROW " +
			"OVERLAPS THE LIGHTER COLOURED AREA TO DANCE.\n\n" +
			"IN PRACTICE YOU DO NOT LOSE HEALTH FOR MISTAKES.\n\n" +
			"PRESS 'Q' AT ANY TIME WHILE DANCING TO QUIT TO THE MAIN MENU, BUT NOTE THIS WILL " +
			"FORFEIT IF YOU ARE IN A MULTIPLAYER MATCH.";
		
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
		
		private var _tutorialBG:FlxSprite;
		private var _tutorialTextField:TextField;
		private var _tutorialTextFormat:TextFormat = new TextFormat("COMMODORE",18,0xFFFFFF,null,null,null,null,null,"left",null,null);
		
		private var _timer:FlxTimer;
		private var _dancing:Boolean = false;
		private var _conceding:Boolean = false; // Whether one of the players is conceding
		private var _playerConceded:Boolean = false;
		private var _addDancers:Boolean = false;
		
//		private var _uiSound:FlxSound;
//		private var _victorySound:FlxSound;
		
		public function PracticeState() {
			super();
		}
		
		public override function create():void {
			super.create();
			
			_timer = new FlxTimer();
			_music = new Music();
			
			FlxG.bgColor = 0xFFCCCCCC;
			
			_bg = new FlxSprite(0,0);
			_bg.loadGraphic(Assets.DANCE_STUDIO,false,false,FlxG.width,FlxG.height);
			
			_uis = new Array();
			_uis.push(new UI(Cookie.name,false,true,null,"ARROWS","LEFT"));
			
			_dancers = new Array();
			_dancers.push(new Dancer((FlxG.width / 3) - 50, -100,Assets.AVATAR_SHEET));
			
			_openText = "LET'S PRACTICE!";
			_openTextField = Helpers.makeTextField(0,FlxG.height/2 - 40,FlxG.width,50,_openText,_openTextFormat);
			
			_tutorialTextField = Helpers.makeTextField(FlxG.width/2 + 25,5,FlxG.width/2 - 30,FlxG.height - 10,"",_tutorialTextFormat);
			_tutorialTextField.text = TUTORIAL_TEXT;
			_tutorialBG = new FlxSprite();
			_tutorialBG.makeGraphic(FlxG.width/2 - 20,FlxG.height,0xAA333333);
			_tutorialBG.x = FlxG.width/2 + 20; _tutorialBG.y = 0;
						
			add(_bg);
			add(_uis[0]);
			add(_dancers[0]);

			_timer.start(1,1,addDancers);			
		}
		
		private function addDancers(t:FlxTimer):void {
			_addDancers = true;
		}
		
		private function addStartText(t:FlxTimer):void {
			Assets._failSound.play();
			FlxG.stage.addChild(_openTextField);
			_timer.start(2,1,addTutorial);
		}
		
		private function addTutorial(t:FlxTimer):void {
			FlxG.stage.removeChild(_openTextField);
			add(_tutorialBG);
			FlxG.stage.addChild(_tutorialTextField);
			_uis[0].startDancing();
			_timer.start(1,1,checkReady);
		}
		
		private function checkReady(t:FlxTimer):void {
			Assets._failSound.play();
			_tutorialTextField.appendText("\n\nPRESS SPACE TO START");
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,startKeyDown);
			FlxG.stage.addChild(_tutorialTextField);
		}
		
		private function startKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SPACE) {
				Assets._failSound.play();
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,startKeyDown);
				_tutorialTextField.replaceText(_tutorialTextField.length-20,_tutorialTextField.length,"");
				_timer.start(1,1,startDancing);
			}
		}
		
		private function startDancing(t:FlxTimer):void {
			_music.play();
			_dancing = true;
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,uiKeyDown);
		}
		
		public override function update():void {
			super.update();	
			
			if (_addDancers) {
				_dancers[0].y+=5;
				if (_dancers[0].y == DANCER_Y) {
					Assets._failSound.play();
					_addDancers = false;
					_timer.start(1,1,addStartText);
				}
			}
			else if (_dancing) {
				
				// PROCESS THE DANCING
				_dancers[0].process(_uis[0].stepResult());
				
				// GET STEP INFORMATION
				var step:int = _music.step();
				
				// CHANGE DANCER RATES
				_dancers[0].changeSpeed(_music.getSpeed());
				
				// SONG FINISHED, OR BOTH HAVE FAILED, OR PLAYER HAS CONCEDED
				if (step == Music.SONG_COMPLETE || _playerConceded || !_uis[0].dancing() && !_uis[1].dancing()) {
					gameOver();
				}
					// SONG PLAYING, NO DANCE STEP
				else if (step == Music.NO_STEP) {
					return; 
				}
				if (_uis[0].dancing()) {
						_uis[0].addSymbol();
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
			_dancers[0].idle();
			if (_music.step() != Music.SONG_COMPLETE) _music.stop();
			_dancing = false;
			_timer.start(3,1,showResult);
		}
		
		private function showResult(t:FlxTimer):void {

			_resultText = "GREAT PRACTICE!";
			_dancers[0].victory();

			_resultTextField = Helpers.makeTextField(0,FlxG.height/2 - 40,FlxG.width,50,_resultText,_resultTextFormat);
			Assets._victorySound.play();
			if (_concedeText != null && FlxG.stage.contains(_concedeText)) FlxG.stage.removeChild(_concedeText);
			FlxG.stage.addChild(_resultTextField);
			
			_timer.start(1,1,showEndOptions);
		}
		
		private function showEndOptions(t:FlxTimer):void {
			_resultTextField.appendText("\n(R)ETRY    (M)ENU");
			Assets._failSound.play(true);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,endOptionsKeyDown);
		}
		
		private function endOptionsKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.R) {
				Assets._failSound.play(true);
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,endOptionsKeyDown);
				FlxG.switchState(new PracticeState);
			}
			else if (e.keyCode == Keyboard.M) {
				Assets._failSound.play(true);
				FlxG.switchState(new TitleState);
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,endOptionsKeyDown);
			}
			
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
			if (_tutorialTextField != null && FlxG.stage.contains(this._tutorialTextField)) FlxG.stage.removeChild(this._tutorialTextField);
			if (_concedeText != null && FlxG.stage.contains(this._concedeText)) FlxG.stage.removeChild(this._concedeText);
			if (_resultTextField != null && FlxG.stage.contains(this._resultTextField)) FlxG.stage.removeChild(this._resultTextField);
			
			FlxG.stage.focus = null;

		}
	}
}