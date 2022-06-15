package
{
	import flash.events.KeyboardEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class TitleState extends FlxState
	{
		private const DANCER_Y:uint = (FlxG.height / 2) + 5;
		private const VALID_CHARACTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
		
		private var _titleBG:FlxSprite;
		
		
		private var _titleText:String = "Z O R B A";
		private var _titleTextField:TextField;
		private var _titleFormat:TextFormat = new TextFormat("COMMODORE",100,0x000000,null,null,null,null,null,"center",null,null);
		private var _optionsText:String = "(P)RACTICE\n(L)OCAL VS.\n(O)NLINE VS.\n(S)TATS\n(Z)ORBA!";
		private var _optionsTextField:TextField;
		private var _optionsFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"left",null,null);
		
		private var _getNamePromptTextField:TextField;
		private var _getNameEntryTextField:TextField;
		private var _getNameFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _welcomeTextField:TextField;
		private var _welcomeFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _music:Music;
		private var _dancer1:Dancer;
		private var _dancer2:Dancer;
		private const NUM_DANCERS:uint = 8;
		
		private var _addDancers:Boolean = false;
		private var _dancing:Boolean = false;
		
		private var _timer:FlxTimer;
//		private var _uiSound:FlxSound;
		
		public function TitleState() {
			super();
		}
		
		public override function create():void {
			super.create();
			
			FlxG.bgColor = 0xFF86B1FF;
			
			_music = new Music();
			
			_titleBG = new FlxSprite(0,FlxG.height - 30);
			//_titleBG.loadGraphic(Assets.TITLE_BG);
			_titleBG.makeGraphic(FlxG.width,30,0xFF6c8ecc,false,null);
			
			_titleTextField = Helpers.makeTextField(0,15,FlxG.width,50,_titleText,_titleFormat);
			_optionsTextField = Helpers.makeTextField(130,80,FlxG.width,FlxG.height,_optionsText,_optionsFormat);
			
			_dancer1 = new Dancer(0,-100,Assets.OPPONENT_SHEET);
			_dancer2 = new Dancer(FlxG.width - 100,-100,Assets.OPPONENT_SHEET);
			
			add(_titleBG);
			add(_dancer1);
			add(_dancer2);
			
//			_uiSound = new FlxSound();
//			_uiSound.loadEmbedded(Assets.FAIL_SOUND,false,false);
//			_uiSound.volume = 0.1;
			
			_timer = new FlxTimer();
			
			Cookie.load();
			
			if (Globals._firstTitleLoad) {
				
				Globals._firstTitleLoad = false;
				
				// LOAD MUSIC
				Assets._failSound = new FlxSound();
				Assets._failSound.loadEmbedded(Assets.FAIL_SOUND,false,false);
				Assets._failSound.volume = 0.2;
				Assets._successSound = new FlxSound();
				Assets._successSound.loadEmbedded(Assets.SUCCESS_SOUND,false,false);
				Assets._successSound.volume = 0.2;
				Assets._victorySound = new FlxSound();
				Assets._victorySound.loadEmbedded(Assets.VICTORY_SOUND,false,false);
				Assets._victorySound.volume = 0.2;
				
				Assets._zorbaSong = new Assets.ZORBA_MUSIC() as Sound;
				
				//Assets._zorbaSong.loadEmbedded(Assets.ZORBA_MUSIC,false,false);
				//Assets._zorbaSong.volume = 2.0;
				
				if (Cookie.name == "") {
					_timer.start(1,1,getName);
				}
				else {
					_timer.start(1,1,welcome);
				}				
			}
			else {
				_dancer1.y = DANCER_Y;
				_dancer2.y = DANCER_Y;
				FlxG.stage.addChild(_titleTextField);
				FlxG.stage.addChild(_optionsTextField);
				FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
				_timer.start(1,1,startMusic);
			}			
		}
		
		private function getName(t:FlxTimer):void {
			_getNamePromptTextField = Helpers.makeTextField(0,FlxG.height/2 - 64,FlxG.width,64,"TYPE YOUR 5 CHARACTER NAME\nAND PRESS ENTER",_getNameFormat);
			_getNameEntryTextField = Helpers.makeTextField(0,FlxG.height/2,FlxG.width,32,"",_getNameFormat);
			FlxG.stage.addChild(_getNamePromptTextField);
			FlxG.stage.addChild(_getNameEntryTextField);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,nameKeyDown);
		}
		
		private function nameKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ENTER && _getNameEntryTextField.text.length == 5) {
				Cookie.name = _getNameEntryTextField.text;
				FlxG.stage.removeChild(_getNamePromptTextField);
				FlxG.stage.removeChild(_getNameEntryTextField);
				_timer.start(1,1,welcome);
			}
			else if (e.keyCode == Keyboard.BACKSPACE && _getNameEntryTextField.text.length > 0) {
				_getNameEntryTextField.replaceText(_getNameEntryTextField.text.length-1,_getNameEntryTextField.length,"");
			}
			var character:String = String.fromCharCode(e.charCode);
			character = character.toUpperCase();
			if (this.VALID_CHARACTERS.indexOf(character) != -1 && _getNameEntryTextField.text.length < 5) {
				_getNameEntryTextField.appendText(character);
			}
		}
		
		private function welcome(t:FlxTimer):void {
			_welcomeTextField = Helpers.makeTextField(0,FlxG.height/2-32,FlxG.width,32,"WELCOME, " + Cookie.name + "...",_welcomeFormat);
			FlxG.stage.addChild(_welcomeTextField);
			_timer.start(2,1,addDancers);
		}
		
		private function addDancers(t:FlxTimer):void {
			if (FlxG.stage.contains(_welcomeTextField)) FlxG.stage.removeChild(_welcomeTextField);
			_addDancers = true;
		}
		
		private function addTitle(t:FlxTimer):void {
			Assets._failSound.play();
			FlxG.stage.addChild(_titleTextField);
			_timer.start(1,1,addOptions);
		}
		
		private function addOptions(t:FlxTimer):void {
			Assets._failSound.play();
			FlxG.stage.addChild(_optionsTextField);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			_timer.start(1,1,startMusic);
			
		}
		
		private function startMusic(t:FlxTimer):void {
			_music.play();
		}
		
		public override function update():void {
			super.update();	
			
			
			if (_addDancers) {
				_dancer1.y += 5;
				_dancer2.y += 5;
				if (_dancer1.y == DANCER_Y) {
					_addDancers = false;
					_timer.start(1,1,addTitle);
					Assets._failSound.play();
				}
			}
			
			if (_music != null) _music.step();
			
			if (!_dancing && _music != null && _music.trueStep() == 0) {
				_dancer1.process(UI.SUCCESS_STEP);
				_dancer2.process(UI.SUCCESS_STEP);
				_dancing = true;
			}
			if (_dancing) {
				_dancer1.changeSpeed(_music.getSpeed());
				_dancer2.changeSpeed(_music.getSpeed());
			}
			
		}
		
		private function keyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.P) {
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
				FlxG.switchState(new PracticeState);
			}
			else if (e.keyCode == Keyboard.O) {
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
				FlxG.switchState(new MultiplayerState);
			}
			else if (e.keyCode == Keyboard.L) {
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
				FlxG.switchState(new LocalMultiplayerState);
			}
			else if (e.keyCode == Keyboard.S) {
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
				FlxG.switchState(new StatisticsState);
			}
			else if (e.keyCode == Keyboard.Z) {
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
				FlxG.switchState(new ZorbaState);
			}
		}
		
		public override function destroy():void {
			super.destroy();
			
			_titleBG.destroy();
			_music.destroy();
			
			_timer.destroy();
			
			_dancer1.destroy();
			_dancer2.destroy();
			
			FlxG.stage.removeChild(_titleTextField);
			FlxG.stage.removeChild(_optionsTextField);
			
			FlxG.stage.focus = null;
		}
	}
}