package
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class StatisticsState extends FlxState
	{
		private var _headingsText:String;
		private var _headingsTextField:TextField;
		private var _headingsFormat:TextFormat = new TextFormat("COMMODORE",18,0x000000,null,null,null,null,null,"left",null,100);

		private var _statsText:String;
		private var _statsTextField:TextField;
		private var _statsFormat:TextFormat = new TextFormat("COMMODORE",18,0x000000,null,null,null,null,null,"right",null,100);
		
		private var _optionsText:String = "(M)ENU";
		private var _optionsTextField:TextField;
		private var _optionsFormat:TextFormat = new TextFormat("COMMODORE",18,0x000000,null,null,null,null,null,"center",null,null);
		
		private var _addDancers:Boolean = false;
		private var _dancing:Boolean = false;
		
		private var _timer:FlxTimer;
//		private var _uiSound:FlxSound;
		
		public function StatisticsState() {
			super();
		}
		
		public override function create():void {
			super.create();
			
			FlxG.bgColor = 0xFFCCCCFF;
			
			_headingsTextField = Helpers.makeTextField(80,5,FlxG.width - 120,FlxG.height - 30,"",_headingsFormat);
			_statsTextField = Helpers.makeTextField(80,5,FlxG.width - 120,FlxG.height - 30,"",_statsFormat);
			_optionsTextField = Helpers.makeTextField(20,180,FlxG.width - 40,50,_optionsText,_optionsFormat);
			
			Cookie.load();
			
//			_uiSound = new FlxSound();
//			_uiSound.loadEmbedded(Assets.FAIL_SOUND,false,false);
//			_uiSound.volume = 0.1;
			
			_timer = new FlxTimer();
			_timer.start(1,1,addStats);			
		}
		
		private function addStats(t:FlxTimer):void {
			Assets._failSound.play();
			loadStats();
			FlxG.stage.addChild(_headingsTextField);
			FlxG.stage.addChild(_statsTextField);
			_timer.start(1,1,addOptions);
		}
		
		private function loadStats():void {
			_headingsText = "";
			_statsText = "";
			_headingsText += "HIGH SCORE:\n\n";
			_statsText += + Cookie.hiScore + "\n\n";
			_headingsText += "ONLINE WON-LOST-DRAWN" + "\n\n";
			_statsText += Cookie.onlineWins + "-" + Cookie.onlineLosses + "-" + Cookie.onlineDraws + "\n\n";
			_headingsText += "LOCAL WON-LOST-DRAWN" + "\n\n";
			_statsText += Cookie.localWins + "-" + Cookie.localLosses + "-" + Cookie.localDraws + "\n\n";
			_headingsText += "ZORBA WON-LOST-DRAWN" + "\n\n";
			_statsText += Cookie.zorbaWins + "-" + Cookie.zorbaLosses + "-" + Cookie.zorbaDraws + "\n\n";
			_headingsText += "LONGEST DANCE" + "\n\n";
			_statsText += secondsToTimeString(Cookie.longestDance) + "\n\n";
			_headingsText += "LONGEST DANCE VS. ZORBA" + "\n\n";
			_statsText += secondsToTimeString(Cookie.longestDanceVsZorba) + "\n\n";
			_headingsText += "TOTAL STEPS MADE" + "\n\n";
			_statsText += Cookie.totalStepsMade + "\n\n";
			_headingsText += "TOTAL STEPS MISSED" + "\n\n";
			_statsText += Cookie.totalStepsMissed + "\n\n";
			_headingsText += "TOTAL PERCENTAGE STEPS MADE" + "\n\n";
			var percentageMade:int;
			if (Cookie.totalStepsMade + Cookie.totalStepsMissed == 0) percentageMade = 0;
			else percentageMade = ((Cookie.totalStepsMade / (Cookie.totalStepsMade + Cookie.totalStepsMissed)) * 100);
			_statsText += percentageMade + "%\n\n";
			_headingsText += "MOST CONSECUTIVE STEPS" + "\n\n";
			_statsText += Cookie.mostConsecutiveSteps + "\n\n";
			_headingsTextField.text = _headingsText;
			_statsTextField.text = _statsText;
		}
		
		private function secondsToTimeString(time:uint):String {
			var minutes:uint = Math.floor(time/60);
			var seconds:uint = time % 60;
			if (seconds < 10) {
				return minutes + "m0" + seconds + "s";
			}
			else {
				return minutes + "m" + seconds + "s";
			}
		}
		
		private function addOptions(t:FlxTimer):void {
			Assets._failSound.play();
			FlxG.stage.addChild(_optionsTextField);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
			
		}
		
		public override function update():void {
			super.update();				
		}
		
		private function keyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.M) {
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);
				FlxG.switchState(new TitleState);
			}
		}
		
		public override function destroy():void {
			super.destroy();
			
			if (_headingsTextField != null && FlxG.stage.contains(_headingsTextField)) FlxG.stage.removeChild(_headingsTextField);
			if (_statsTextField != null && FlxG.stage.contains(_statsTextField)) FlxG.stage.removeChild(_statsTextField);
			if (_optionsTextField != null && FlxG.stage.contains(_optionsTextField)) FlxG.stage.removeChild(_optionsTextField);
			
			FlxG.stage.focus = null;
		}
	}
}