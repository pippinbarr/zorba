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
//		private const DANCER_Y:uint = (FlxG.height / 2) + 5;
		private const VALID_CHARACTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
		
		private var _titleBG:FlxSprite;
		private var _alphaLayer:FlxSprite;
		
		private var _titleText:String = "Z O R B A";
		private var _titleTextField:TextField;
		private var _titleFormat:TextFormat = new TextFormat("COMMODORE",100,0x000000,null,null,null,null,null,"center",null,null);
		private var _optionsText:String = "(Z)ORBA!\n\n(I)NSTRUCTIONS";
		private var _optionsTextField:TextField;
		private var _optionsFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _getNamePromptTextField:TextField;
		private var _getNameEntryTextField:TextField;
		private var _getNameFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _welcomeTextField:TextField;
		private var _welcomeFormat:TextFormat = new TextFormat("COMMODORE",32,0x000000,null,null,null,null,null,"center",null,null);
				
		private var _instructionsText:String = "" +
			"PRESS THE APPROPRIATE ARROW KEYS AS THE ARROWS CROSS THE HIGHLIGHTED AREA TO DANCE.\n\n" +
			"PRESS 'Q' DURING PLAY TO QUIT TO THE MENU.\n\n" +
			"FEEL THE MUSIC.\n\n" +
			"\n\n\n\n\n(M)ENU";
		private var _instructionsTextField:TextField;
		private var _instructionsFormat:TextFormat = new TextFormat("COMMODORE",24,0x000000,null,null,null,null,null,"left",null,null);
		
		private var _hiScoreTextField:TextField;
		private var _hiScoreFormat:TextFormat = new TextFormat("COMMODORE",24,0x000000,null,null,null,null,null,"center",null,null);

		private var _longestDanceTextField:TextField;
		private var _longestDanceFormat:TextFormat = new TextFormat("COMMODORE",24,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _timer:FlxTimer;
		private var _music:Music;

		
		public function TitleState() {
			super();
		}
		
		public override function create():void {
			super.create();
			
			Cookie.load();
			Cookie.hiScore = 0;
			
			FlxG.bgColor = 0xFFCCCCCC;
			
			_music = new Music();
			_timer = new FlxTimer();
			
			_titleBG = new FlxSprite(0,0);
			_titleBG.loadGraphic(Assets.ZORBA_BEACH,false,false,FlxG.width,FlxG.height);
			
			_alphaLayer = new FlxSprite(0,0);
			_alphaLayer.makeGraphic(FlxG.width,FlxG.height,0x66FFFFFF);
			_alphaLayer.visible = false;
			
			_titleTextField = Helpers.makeTextField(0,5,FlxG.width,50,_titleText,_titleFormat);
			_optionsTextField = Helpers.makeTextField(0,70,FlxG.width,FlxG.height,_optionsText,_optionsFormat);
			
			_hiScoreTextField = Helpers.makeTextField(0,160,FlxG.width,24,"HISCORE: " + Cookie.hiScore,_hiScoreFormat);
			_longestDanceTextField = Helpers.makeTextField(0,175,FlxG.width,24,"LONGEST DANCE: " + Helpers.secondsToTimeString(Cookie.longestDance),_longestDanceFormat);
			
			_instructionsTextField = Helpers.makeTextField(30,10,FlxG.width-60,FlxG.height-20,_instructionsText,_instructionsFormat);
			
			_instructionsTextField.visible = false;
			
			FlxG.stage.addChild(_instructionsTextField);
			
			add(_titleBG);
			add(_alphaLayer);
			
			
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
				FlxG.stage.addChild(_titleTextField);
				FlxG.stage.addChild(_optionsTextField);
				if (Cookie.hiScore > 0 && Cookie.longestDance > 0) {
					FlxG.stage.addChild(_hiScoreTextField);
					FlxG.stage.addChild(_longestDanceTextField);
				}
				FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
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
			_timer.start(1.5,1,addTitle);
		}

		private function addTitle(t:FlxTimer):void {
			if (FlxG.stage.contains(_welcomeTextField)) FlxG.stage.removeChild(_welcomeTextField);
			Assets._failSound.play();
			FlxG.stage.addChild(_titleTextField);
			_timer.start(1,1,addOptions);
		}
		
		private function addOptions(t:FlxTimer):void {
			Assets._failSound.play();
			FlxG.stage.addChild(_optionsTextField);
			if (Cookie.hiScore > 0 && Cookie.longestDance > 0) {
				FlxG.stage.addChild(_hiScoreTextField);
				FlxG.stage.addChild(_longestDanceTextField);
			}
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);			
		}
		
		public override function update():void {
			super.update();	
		}
		
		private function keyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.Z) {
				if (!_instructionsTextField.visible) {
					FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
					FlxG.switchState(new ZorbaState);
				}
			}
			else if (e.keyCode == Keyboard.I) {
				if (!_instructionsTextField.visible) {
					toggleInstructions();
				}
			}
			else if (e.keyCode == Keyboard.M) {
				if (_instructionsTextField.visible) {
					toggleInstructions();
				}
			}
		}
		
		private function toggleInstructions():void {
			_instructionsTextField.visible = !_instructionsTextField.visible;
			_titleTextField.visible = !_titleTextField.visible;
			_optionsTextField.visible = !_optionsTextField.visible;
			_hiScoreTextField.visible = !_hiScoreTextField.visible;
			_longestDanceTextField.visible = !_longestDanceTextField.visible;
			_alphaLayer.visible = !_alphaLayer.visible;
		}
				
		public override function destroy():void {
			super.destroy();
			
			_timer.destroy();
			
			_titleBG.destroy();
			_alphaLayer.destroy();
									
			if (FlxG.stage.contains(_titleTextField)) FlxG.stage.removeChild(_titleTextField);
			if (FlxG.stage.contains(_optionsTextField)) FlxG.stage.removeChild(_optionsTextField);
			if (FlxG.stage.contains(_instructionsTextField)) FlxG.stage.removeChild(_instructionsTextField);
			if (FlxG.stage.contains(_hiScoreTextField)) FlxG.stage.removeChild(_hiScoreTextField);
			if (FlxG.stage.contains(_longestDanceTextField)) FlxG.stage.removeChild(_longestDanceTextField);
			
			FlxG.stage.focus = null;
		}
	}
}