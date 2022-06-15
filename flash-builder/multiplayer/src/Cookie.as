package
{
	
	import org.flixel.*;
	
	public class Cookie
	{	
		private static var _save:FlxSave;
		private static var _loaded:Boolean = false;
		
		private static var _tempName:String = "";	
		
		private static var _tempHiScore:uint = 0;
		
		private static var _onlineWinsTemp:uint = 0;
		private static var _onlineLossesTemp:uint = 0;
		private static var _onlineDrawsTemp:uint = 0;

		private static var _localWinsTemp:uint = 0;
		private static var _localLossesTemp:uint = 0;
		private static var _localDrawsTemp:uint = 0;
		
		private static var _zorbaWinsTemp:uint = 0;
		private static var _zorbaLossesTemp:uint = 0;
		private static var _zorbaDrawsTemp:uint = 0;
		
		private static var _longestDanceTemp:uint = 0;
		private static var _longestDanceVsZorbaTemp:uint = 0;
		
		private static var _totalStepsMadeTemp:uint = 0;
		private static var _totalStepsMissedTemp:uint = 0;
		private static var _mostConsecutiveStepsTemp:uint = 0;
		
		public function Cookie() {
		}
		
		public static function load():void {
			
			_save = new FlxSave();
			_loaded = _save.bind("ZorbaZorbaZorba");
			if (_loaded && _save.data.name == null) _save.data.name = "";
			if (_loaded && _save.data.hiScore == null) _save.data.hiScore = 0;
			if (_loaded && _save.data.onlineWins == null) _save.data.onlineWins = 0;
			if (_loaded && _save.data.onlineLosses == null) _save.data.onlineLosses = 0;
			if (_loaded && _save.data.onlineDraws == null) _save.data.onlineDraws = 0;
			if (_loaded && _save.data.localWins == null) _save.data.localWins = 0;
			if (_loaded && _save.data.localLosses == null) _save.data.localLosses = 0;
			if (_loaded && _save.data.localDraws == null) _save.data.localDraws = 0;
			if (_loaded && _save.data.zorbaWins == null) _save.data.zorbaWins = 0;
			if (_loaded && _save.data.zorbaLosses == null) _save.data.zorbaLosses = 0;
			if (_loaded && _save.data.zorbaDraws == null) _save.data.zorbaDraws = 0;
			if (_loaded && _save.data.longestDance == null) _save.data.longestDance = 0;
			if (_loaded && _save.data.longestDanceVsZorba == null) _save.data.longestDanceVsZorba = 0;
			if (_loaded && _save.data.totalStepsMade == null) _save.data.totalStepsMade = 0;
			if (_loaded && _save.data.totalStepsMissed == null) _save.data.totalStepsMissed = 0;
			if (_loaded && _save.data.mostConsecutiveSteps == null) _save.data.mostConsecutiveSteps = 0;	
		}
		
		public static function flush():void {
			if (_loaded) _save.flush();
		}
		
		public static function erase():void {
			if (_loaded) _save.erase();
		}
		
		public static function set name(value:String):void {
			if (_loaded) {
				_save.data.name = value;
			}
			else {
				_tempName = value;
			}
		}
		
		public static function get name():String {
			if (_loaded)
			{
				return _save.data.name;
			}
			else
			{
				return _tempName;
			}
		}
		
		public static function set hiScore(value:uint):void {
			if (_loaded) {
				_save.data.hiScore = value;
			}
			else {
				_tempHiScore = value;
			}
		}
		
		public static function get hiScore():uint {
			if (_loaded)
			{
				return _save.data.hiScore;
			}
			else
			{
				return _tempHiScore;
			}
		}
		
		public static function set onlineWins(value:uint):void {
			if (_loaded) {
				_save.data.onlineWins = value;
			}
			else {
				_onlineWinsTemp = value;
			}
		}
		
		public static function get onlineWins():uint {
			if (_loaded)
			{
				return _save.data.onlineWins;
			}
			else
			{
				return _onlineWinsTemp;
			}
		}
		
		
		public static function set onlineLosses(value:uint):void {
			if (_loaded) {
				_save.data.onlineLosses = value;
			}
			else {
				_onlineLossesTemp = value;
			}
		}
		
		public static function get onlineLosses():uint {
			if (_loaded)
			{
				return _save.data.onlineLosses;
			}
			else
			{
				return _onlineLossesTemp;
			}
		}
		
		public static function set onlineDraws(value:uint):void {
			if (_loaded) {
				_save.data.onlineDraws = value;
			}
			else {
				_onlineDrawsTemp = value;
			}
		}
		
		public static function get onlineDraws():uint {
			if (_loaded)
			{
				return _save.data.onlineDraws;
			}
			else
			{
				return _onlineDrawsTemp;
			}
		}
		
		
		public static function set localWins(value:uint):void {
			if (_loaded) {
				_save.data.localWins = value;
			}
			else {
				_localWinsTemp = value;
			}
		}
		
		public static function get localWins():uint {
			if (_loaded)
			{
				return _save.data.localWins;
			}
			else
			{
				return _localWinsTemp;
			}
		}
		
		public static function set localLosses(value:uint):void {
			if (_loaded) {
				_save.data.localLosses = value;
			}
			else {
				_localLossesTemp = value;
			}
		}
		
		public static function get localLosses():uint {
			if (_loaded)
			{
				return _save.data.localLosses;
			}
			else
			{
				return _localLossesTemp;
			}
		}
		
		public static function set localDraws(value:uint):void {
			if (_loaded) {
				_save.data.localDraws = value;
			}
			else {
				_localDrawsTemp = value;
			}
		}
		
		public static function get localDraws():uint {
			if (_loaded)
			{
				return _save.data.localDraws;
			}
			else
			{
				return _localDrawsTemp;
			}
		}
		
		public static function set zorbaWins(value:uint):void {
			if (_loaded) {
				_save.data.zorbaWins = value;
			}
			else {
				_zorbaWinsTemp = value;
			}
		}
		
		public static function get zorbaWins():uint {
			if (_loaded)
			{
				return _save.data.zorbaWins;
			}
			else
			{
				return _zorbaWinsTemp;
			}
		}
		
		public static function set zorbaLosses(value:uint):void {
			if (_loaded) {
				_save.data.zorbaLosses = value;
			}
			else {
				_zorbaLossesTemp = value;
			}
		}
		
		public static function get zorbaLosses():uint {
			if (_loaded)
			{
				return _save.data.zorbaLosses;
			}
			else
			{
				return _zorbaLossesTemp;
			}
		}
		
		public static function set zorbaDraws(value:uint):void {
			if (_loaded) {
				_save.data.zorbaDraws = value;
			}
			else {
				_zorbaDrawsTemp = value;
			}
		}
		
		public static function get zorbaDraws():uint {
			if (_loaded)
			{
				return _save.data.zorbaDraws;
			}
			else
			{
				return _zorbaDrawsTemp;
			}
		}
		
		public static function set longestDance(value:uint):void {
			if (_loaded) {
				_save.data.longestDance = value;
			}
			else {
				_longestDanceTemp = value;
			}
		}
		
		public static function get longestDance():uint {
			if (_loaded)
			{
				return _save.data.longestDance;
			}
			else
			{
				return _longestDanceTemp;
			}
		}
		
		public static function set longestDanceVsZorba(value:uint):void {
			if (_loaded) {
				_save.data.longestDanceVsZorba = value;
			}
			else {
				_longestDanceVsZorbaTemp = value;
			}
		}
		
		public static function get longestDanceVsZorba():uint {
			if (_loaded)
			{
				return _save.data.longestDanceVsZorba;
			}
			else
			{
				return _longestDanceVsZorbaTemp;
			}
		}
		
		public static function set totalStepsMade(value:uint):void {
			if (_loaded) {
				_save.data.totalStepsMade = value;
			}
			else {
				_totalStepsMadeTemp = value;
			}
		}
		
		public static function get totalStepsMade():uint {
			if (_loaded)
			{
				return _save.data.totalStepsMade;
			}
			else
			{
				return _totalStepsMadeTemp;
			}
		}
		
		public static function set totalStepsMissed(value:uint):void {
			if (_loaded) {
				_save.data.totalStepsMissed = value;
			}
			else {
				_totalStepsMissedTemp = value;
			}
		}
		
		public static function get totalStepsMissed():uint {
			if (_loaded)
			{
				return _save.data.totalStepsMissed;
			}
			else
			{
				return _totalStepsMissedTemp;
			}
		}

		
		public static function set mostConsecutiveSteps(value:uint):void {
			if (_loaded) {
				_save.data.mostConsecutiveSteps = value;
			}
			else {
				_mostConsecutiveStepsTemp = value;
			}
		}
		
		public static function get mostConsecutiveSteps():uint {
			if (_loaded)
			{
				return _save.data.mostConsecutiveSteps;
			}
			else
			{
				return _mostConsecutiveStepsTemp;
			}
		}
		
	}
}