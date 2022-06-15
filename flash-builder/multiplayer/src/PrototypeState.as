package
{
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import org.flixel.*;
	
	public class PrototypeState extends FlxState
	{
		
		[Embed(source="assets/sound/ZorbaAria.mp3")]
		private const ZorbaSong:Class;
		
		[Embed(source="assets/sound/ZorbaAcBassOnly.mp3")]
		private const ZorbaClap:Class;
		
		[Embed(source="assets/sprite/Arrows.png")]
		private const Arrows:Class;
		
		private var _zorbaSong:Sound;
		private var _zorbaClap:Sound;
		private var _songChannel:SoundChannel;
		private var _clapChannel:SoundChannel;
		private var _clapTransform:SoundTransform;
		
		private var _hitZone:FlxSprite;
		private var _hitZoneAI:FlxSprite;
		
		private var _incoming:Array = new Array();
		private var _incomingAI:Array = new Array();
		private var _incomingTimes:Array = new Array();
		private var _incomingTimesAI:Array = new Array();
		private var _outgoing:Array = new Array();
		private var _outgoingAI:Array = new Array();
		private var _outgoingTimes:Array = new Array();
		private var _outgoingTimesAI:Array = new Array();

		
		private var _clapDelay:Number = 0.0;
		private const CLAP_MIN_DELAY:Number = 0.2;
		
		private var _playerHealthBar:FlxSprite;
		private var _aiHealthBar:FlxSprite;
		
		private var _playerScore:uint;
		private var _aiScore:uint;
		private var _playerScoreText:FlxText;
		private var _aiScoreText:FlxText;
		
		private var _ai:AI;
		
		public function PrototypeState() {
			super();
		}
		
		public override function create():void {
			super.create();
			
			_zorbaSong = new ZorbaSong() as Sound;
			_songChannel = _zorbaSong.play(100000);
			_songChannel.addEventListener(Event.SOUND_COMPLETE,zorbaSongComplete);
			
			_zorbaClap = new ZorbaClap() as Sound;
			_clapTransform = new SoundTransform(0.01);
			_clapChannel = _zorbaClap.play(100000+1000,0,_clapTransform);
			
			_ai = new AI(0.8,1.0);
			
			_hitZone = new FlxSprite();
			_hitZone.makeGraphic(40,10,0x55FFFFFF);
			_hitZone.x = 0;
			_hitZone.y = FlxG.height - 10;
			add(_hitZone);

			_hitZoneAI = new FlxSprite();
			_hitZoneAI.makeGraphic(40,10,0x55FFFFFF);
			_hitZoneAI.x = FlxG.width - 40;
			_hitZoneAI.y = FlxG.height - 10;
			add(_hitZoneAI);

			_playerHealthBar = new FlxSprite();
			_playerHealthBar.makeGraphic(50,5,0xFFFF0000);
			_playerHealthBar.scale.x = 1;
			_playerHealthBar.x = 0, _playerHealthBar.y = 0;
			_playerHealthBar.origin.x = 0; _playerHealthBar.origin.y = 0;
			add(_playerHealthBar);
			
			_aiHealthBar = new FlxSprite();
			_aiHealthBar.makeGraphic(50,5,0xFFFF0000);
			_aiHealthBar.x = FlxG.width - 50; _aiHealthBar.y = 0;
			_aiHealthBar.origin.x = 50; //FlxG.width - 50;
			_aiHealthBar.origin.y = 0;
			_aiHealthBar.scale.x = 1;
			add(_aiHealthBar);
			
			_playerScoreText = new FlxText(0,0,50,_playerScore.toString());
			_playerScoreText.setFormat(null,8,0xFFFFFF,"right");
			add(_playerScoreText);
			
			_aiScoreText = new FlxText(FlxG.width - 50,0,50,_aiScore.toString());
			_aiScoreText.setFormat(null,8,0xFFFFFF,"right");
			add(_aiScoreText);
			
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
		}
		
		public override function update():void {
			super.update();
			_ai.update();
			
			trace(_clapChannel.rightPeak);
			if (_clapChannel.rightPeak > 0.0001 && _clapDelay > CLAP_MIN_DELAY) {
				//if (_clapDelay > CLAP_MIN_DELAY) {
				// We need to start moving a new symbol
				_clapDelay = 0.0;
				var arrowType:uint = Math.floor(Math.random()*4);
				_incoming.push(newSymbol(arrowType,true));
				_incomingAI.push(newSymbol(arrowType,false));
				_incomingTimes.push(0.0);
				_incomingTimesAI.push(0.0);
				add(_incoming[_incoming.length-1]);
				add(_incomingAI[_incomingAI.length-1]);
			}
			
			if (_clapDelay <= CLAP_MIN_DELAY) {
				_clapDelay += FlxG.elapsed;
			}
			
			if (_outgoing.length > 0) {
				// Move along the outgoing sprites
				for (var j:uint = 0; j < _outgoing.length; j++) {
					_outgoingTimes[j] += FlxG.elapsed;
					_outgoing[j].y = (0 - _outgoing[j].height) + (_outgoingTimes[j] * FlxG.height);
				}
				
				if (_outgoing[0].y >= FlxG.height) {
					remove(_outgoing[0]);
					_outgoing.shift();
					_outgoingTimes.shift();
				}
			}
			if (_outgoingAI.length > 0) {
				for (j = 0; j < _outgoingAI.length; j++) {
					_outgoingTimesAI[j] += FlxG.elapsed;
					_outgoingAI[j].y = (0 - _outgoingAI[j].height) + (_outgoingTimesAI[j] * FlxG.height);
				}
				
				if (_outgoingAI[0].y >= FlxG.height) {
					remove(_outgoingAI[0]);
					_outgoingAI.shift();
					_outgoingTimesAI.shift();
				}
				
			}
			
			if (_incoming.length > 0) {
				// Move along the incoming sprites
				for (var i:uint = 0; i < _incoming.length; i++) {
					_incomingTimes[i] += FlxG.elapsed;
					_incoming[i].y = (0 - _incoming[i].height) + (_incomingTimes[i] * FlxG.height);
				}
				if (_incoming[0].y >= FlxG.height) {
					//trace("Moving symbol to outgoing because it passed the line");
					_outgoing.push(_incoming.shift());
					_outgoingTimes.push(_incomingTimes.shift());
					_playerHealthBar.scale.x -= 0.05;
				}

			}
			if (_incomingAI.length > 0) {
				for (i = 0; i < _incomingAI.length; i++) {
					_incomingTimesAI[i] += FlxG.elapsed;
					_incomingAI[i].y = (0 - _incomingAI[i].height) + (_incomingTimesAI[i] * FlxG.height);
				}
				if (_incomingAI[0].overlapsAt(_incomingAI[0].x,_incomingAI[0].y-_incomingAI[0].height,_hitZoneAI)) {
					if (!_ai.success()) {
						_aiHealthBar.scale.x -= 0.05;
					}
					else {
						_aiScore++;
						_aiScoreText.text = _aiScore.toString();
					}
					_outgoingAI.push(_incomingAI.shift());
					_outgoingTimesAI.push(_incomingTimesAI.shift());
				}
			}
			
			if (_playerHealthBar.scale.x <= 0) {
				_playerScoreText.text = "GAME OVER";
			}
			if (_aiHealthBar.scale.x <= 0) {
				_aiScoreText.text = "GAME OVER";
			}
			
		}
		
		private function keyDown(e:KeyboardEvent):void {
			if (_incoming.length == 0) return;
			if (_incoming[0].overlaps(_hitZone) && (e.keyCode - 37 == _incoming[0].frame)) {
				FlxG.flash(0xFF00FF00,0.1);
				_outgoing.push(_incoming.shift());
				_outgoingTimes.push(_incomingTimes.shift());
				_playerScore++;
				_playerScoreText.text = _playerScore.toString();
			}
			else {
				//Change colour etc.
				FlxG.flash(0xFFFF0000,0.1);
				_playerHealthBar.scale.x -= 0.05;
			}
			
		}
		
		private function zorbaSongComplete(e:Event):void {
			trace("Zorba Song completed.");
		}
		
		public override function destroy():void {
			super.destroy();
		}
		
		private function newSymbol(type:uint,player:Boolean):FlxSprite {
			var symbol:FlxSprite = new FlxSprite();
			symbol.loadGraphic(Arrows,true,false,10,10);
			symbol.frame = type;
			if (player) {
				symbol.x = 0 + (type * 10);
			}
			else {
				symbol.x = FlxG.width - 40 + (type * 10);
			}
			symbol.y = 0 - symbol.height;
			return symbol;
		}
	}
}