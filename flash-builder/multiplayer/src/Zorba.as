package
{
	import org.flixel.*;
	
	[SWF(width = "800", height = "400", backgroundColor = "#FFFFFF")]
	[Frame(factoryClass="ZorbaPreloader")]
	
	public class Zorba extends FlxGame
	{
		public function Zorba() {
			super(400,200,TitleState,Globals.ZOOM);
			//super(400,200,LocalMultiplayerState,Globals.ZOOM);
			//super(400,200,ZorbaState,Globals.ZOOM);
			FlxG.framerate = 60;
		}
	}
}