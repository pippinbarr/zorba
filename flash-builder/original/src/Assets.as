package
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import org.flixel.FlxSound;

	public class Assets
	{
		[Embed(source="assets/font/Commodore Pixelized v1.2.ttf", fontName="COMMODORE", fontWeight="Regular", embedAsCFF="false")]
		public static const COMMODORE_FONT:Class;
		
		[Embed(source="assets/sound/Zorba.mp3")]
		public static const ZORBA_MUSIC:Class;
		public static var _zorbaSong:Sound;
		public static var _zorbaChannel:SoundChannel;
		
		[Embed(source="assets/sound/success.mp3")]
		public static const SUCCESS_SOUND:Class;
		public static var _successSound:FlxSound;
		
		[Embed(source="assets/sound/fail.mp3")]
		public static const FAIL_SOUND:Class;
		public static var _failSound:FlxSound;
		
		[Embed(source="assets/sound/victory.mp3")]
		public static const VICTORY_SOUND:Class;
		public static var _victorySound:FlxSound;
				
		[Embed(source="assets/sprite/healthBar.png")]
		public static const HEALTHBAR_SHEET:Class;
		
		[Embed(source="assets/sprite/hitZone.png")]
		public static const HITZONE_SHEET:Class;
		public static const NORMAL_HITZONE:uint = 0;
		public static const GREEN_HITZONE:uint = 1;
		public static const RED_HITZONE:uint = 2;
		
		[Embed(source="assets/sprite/Arrows.png")]
		public static const ARROWS_SHEET:Class;
		[Embed(source="assets/sprite/Letters.png")]
		public static const LETTERS_SHEET:Class;

		public static const GREEN_SYMBOL_OFFSET:uint = 4;
		public static const RED_SYMBOL_OFFSET:uint = 8;
		
		[Embed(source="assets/background/ZorbaBeach400x200.png")]
		public static const ZORBA_BEACH:Class;
		
		[Embed(source="assets/background/ZorbaDraw.png")]
		public static const ZORBA_DRAW:Class;

		[Embed(source="assets/sprite/AvatarSheet.png")]
		public static const AVATAR_SHEET:Class;
		
		[Embed(source="assets/sprite/ZorbaSheet.png")]
		public static const ZORBA_SHEET:Class;
		
		public static const DANCE_FRAMES:Array = new Array(
			0,1,2,3,4,5,6,7,8,9,
			10,11,12,13,14,15,16,17,18,19,
			20,21,22,23,24,25,26,27,28,29,
			30,31,32,33,34,35,36,37,38,39,
			40,41,42,43,44,45,46,47,48,49,
			50,51,52,53,54,55,56,57,58,59,
			60,61,62,63,64,65,66,67,68,69,
			70,71,72,73,74,75,76,77,78,79,
			80,81,82,83,84,85,86,87,88,89,
			90,91,92,93,94,95,96,97,98,99,
			100,101,102,103,104,105,106,107,108,109,
			110,111,112,113,114,115,116,117,118,119,
			120,121,122,123,124,125,126,127,128,129,
			130,131,132);
		
		public static const FAIL_OFFSET:uint = 133;
		public static const IDLE_OFFSET:uint = 266;
		public static const VICTORY_OFFSET:uint = 399;
		
		public function Assets()
		{
		}
	}
}