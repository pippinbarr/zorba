package
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Helpers
	{
		
		public static const USER_NAMES:Array = new Array(
		'PIPPN', // FAMILY
		'RILLA',
		'MRJIM',
		'MARYB',
		'AMMUK',
		'ABBUK',
		'TINAK',
		'NAZIM',
		'IQBAL',
		'DOOGL', // ITUERS
		'SCART',
		'TAYLR',
		'TBIAS',
		'PAOLO',
		'ESPEN',
		'COGRE',
		'SHAKR',
		'KAKIS',
		'GORDO',
		'MARKN',
		'JUTOG',
		'WITKO',
		'HECTR',
		'GYUNG',
		'CNSSA',
		'RUNEN',
		'CHOLM',
		'DBONI', // KILLSCREENERS...
		'DUBBN',
		'TRIPH',
		'JAMIN',
		'JOHNS',
		'SELMA',
		'PHL25',
		'TWERK',
		'GRANT',
		'TENRD',
		'LANAP',
		'KEOGH',
		'DIANA',
		'ENRIC', // STUDENTS...
		'JAKOB',
		'PRBEN',
		'AMANI',
		'FILIP',
		'AGNIE',
		'GCOMO',
		'STANN',
		'MAGDA',
		'KATRN',
		'JEPPE',
		'STEFN',
		'SANDR',
		'RONNY',
		'GEORG',
		'JIMMY', // RANDOM
		'JOKER',
		'PETER',
		'DRDRE',
		'SFHJD',
		'KLJSD',
		'QWERT',
		'ASDFG',
		'LKNDS',
		'WEEKY',
		'FUCKU',
		'FUCKR',
		'SHITS',
		'IDIOT',
		'ASSHL',
		'MASHD',
		'PWNED',
		'WINNR',
		'ZORBA',
		'ZRBA1',
		'ZRBA2',
		'DADDY',
		'BIGGY',
		'WILLY',
		'PENIS',
		'JUICE',
		'IRULE',
		'USUCK',
		'BASIL',
		'RABBI',
		'DANCR',
		'DANCE',
		'BGONE',
		'CHADC',
		'SOOKI',
		'ANNEH',
		'JACOB',
		'SNAKE',
		'TIGER',
		'BLOOD',
		'CAPTN',
		'SRGNT',
		'DOGGY',
		'SNOOP',
		'CRSHR'
		);
		
		public function Helpers()
		{
		}
		
		public static function makeTextField(x:uint, y:uint, w:uint, h:uint, s:String,tf:TextFormat):TextField {
			var textField:TextField = new TextField();
			textField.x = x * Globals.ZOOM;
			textField.y = y * Globals.ZOOM;
			textField.width = w * Globals.ZOOM;
			textField.height = h * Globals.ZOOM;
			textField.defaultTextFormat = tf;
			textField.text = s;
			textField.wordWrap = true;
			textField.selectable = false;
			textField.embedFonts = true;
			
			return textField;
		}
		
		public static function generateMultiplayerName():String {
			return (USER_NAMES[Math.floor(Math.random() * USER_NAMES.length)]);
		}
		
	}
}