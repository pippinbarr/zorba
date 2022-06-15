package
{
	public class Globals
	{
		
		public static var _firstTitleLoad:Boolean = true;
		
		public static const ZOOM:uint = 2;
		public static const STEP_DELAY:uint = 2;
		public static const DELAY:Number = 0.15;
		public static const SWAP_TIME:uint = 5;
		public static const HEALTH_REGENERATION_THRESHOLD:uint = 10;
		
		public static const ZORBAS_HISCORE:uint = 193986360;
		
		public static const STEP_TIMES:Array = new Array(
			6.68,10.01,13.34,16.67,20.01,23.34,26.67,30.01,33.34,40.01,
			43.27,46.50,49.74,52.98,56.01,59.01,62.01,65.00,70.60,70.89,
			71.90,73.20,74.51,75.81,76.10,77.05,78.28,79.50,80.73,81.00,
			81.95,83.17,84.33,85.49,85.72,86.64,87.79,88.89,89.98,90.18,
			91.01,91.99,92.98,93.92,94.12,94.81,95.71,96.60,97.50,97.69,
			98.36,99.21,100.04,100.86,101.04,101.68,102.50,103.29,104.08,
			104.25,104.84,105.60,106.36,107.12,107.28,107.85,108.58,109.29,
			109.99,110.15,110.70,111.41,112.09,112.77,112.92,113.43,114.09,
			114.75,115.41,115.55,116.04,116.68,117.32,117.96,118.10,118.60,
			119.24,119.87,120.51,120.64,121.15,121.79,122.43,123.07,123.21,
			123.70,124.34,124.98,125.62,125.76,126.26,126.89,127.53,128.17,
			128.31,128.81,129.45,130.08,130.72,130.87,131.36,132.00,132.64,
			133.28,133.44,133.92,134.56,135.19,135.83,135.99,136.47,137.10,
			137.74,138.38,138.53,139.02,139.66,140.30,140.94,141.08,141.58,
			142.21,142.85,143.49,143.65,144.13,144.77,145.40,146.04,146.19,
			146.68,147.32,147.96,151.12,153.49,155.79,158.05,160.28,162.45,
			164.56,166.63,167.19,167.57,167.95,168.34,168.72,169.11,169.49,
			169.87,170.26,170.64,171.03,171.41,171.79,172.17,172.55,172.92,
			173.30,173.68,174.06,174.43,174.80,175.17,175.54,175.91,176.28,
			176.66,177.02,177.39,177.76,178.14,178.50,178.87,179.24,179.61,
			179.99,180.35,180.72,181.08,181.44,181.98,182.35,182.52,182.90,
			183.26,183.44,183.98,184.34,184.87,185.23,185.41,185.76,186.12,
			186.30,186.84,187.19,187.73,188.07,188.26,188.62,188.98,189.33,
			189.69,190.05,190.23,190.59,190.94,191.12,191.48,191.84,192.19,
			192.55,192.91,193.08,193.44,193.78,193.98,194.34,194.69,194.87,
			195.22,195.41,195.76,195.92,196.30,196.63,196.83,197.17,197.55,
			197.71,198.09,198.26,198.62,198.79,198.98,199.16,199.51,199.69,
			199.87,200.05,200.23,200.58,200.76,200.94,201.12,201.31,201.48,
			201.65,202.04,202.20,202.39,202.55,202.74,202.91,203.06,203.26,
			203.80,203.98,204.15,204.33,204.49,204.84,205.05,205.40,205.59,
			205.76,205.93,206.30,206.48,206.66,206.83,207.01,207.19,207.55,
			207.723,208.26,208.44,208.62,208.80,209.16,209.35,209.69,209.87,
			210.05,210.21,210.57,210.76,211.12,211.30,211.48,211.65,211.83,
			212.01,212.56,212.72,212.90,213.09,213.46,213.62,213.98,214.14,
			214.34,214.49,214.87,215.05,215.40,215.57,215.76,215.93,216.29,
			216.64,216.83,217.19,217.55,217.73,218.08,218.26,218.35,218.44,
			218.52,218.62,218.70,218.79,219.15,219.51,219.69,220.05,220.41,
			220.60,220.92,221.12,221.21,221.30,221.39,221.48,221.55,221.64,
			222.01,222.37,222.55,222.63,222.72,222.81,222.90,222.99,223.08,
			223.17,223.26,223.35,223.44,223.53,223.62,223.71,223.80,223.89,
			223.98,224.06,224.15,224.25,224.33,224.51,224.87,224.96,225.05,
			225.23,225.40,225.48,225.55,225.62,225.76,225.85,225.94,226.03,
			226.12,226.21,226.30,226.38,226.47,226.56,226.65,226.74,226.83,
			226.92,227.01,227.10,227.19,227.37);
		
		public static const TURN_LENGTHS:Array = new Array(9,9,20,20,20,20,20,20,6,6,20,20,8,8,9,9,10,10,75,14,14,-1);

		public static const SPEEDS:Array = new Array(1.5,1.5,2,3,4,5,6,6,6,6,8,8,8,8,9,9,9,9,10,11,11,12);
		
		
		public function Globals()
		{
		}
	}
}