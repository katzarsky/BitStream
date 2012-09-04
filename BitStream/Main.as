package
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;	

	/*
	* Illustrates the use of the BitStream codec
	*/
	
	public class Main extends Sprite
	{
		public function Main()
		{
			var bs:BitStream = new BitStream();
			var n:uint = 100;
			var i:uint;
			
			bs.writeBits(n, 32);
			for(i=0; i<n; i++) {
				bs.writeBits(1523, 11);
				bs.writeBits(17, 32);
				bs.writeBits(1, 1);
				bs.writeLossyBits(-101, 8, 128); // 8bits = 0..255, offset=128 provides range -128..127
				bs.writeLossyBits(-101, 8, 128, 1); // lossy_bits = 1 loses rightmost bit and actually writes 7 bits
			}
			
			var ba:ByteArray = bs.saveByteArray();
	
			var bs2:BitStream = new BitStream();
			bs2.loadByteArray(ba);
			
			var len:uint = bs2.readBits(32);
			for(i=0; i<len; i++) {
				var x = bs2.readBits(11);
				var y = bs2.readBits(32);
				var z = bs2.readBits(1);
				var lossy1 = bs2.readLossyBits(8, 128);
				var lossy2 = bs2.readLossyBits(8, 128, 1); // returns -102 instead of -101, because of the lost bits
				trace(x, y, z, lossy1, lossy2);
			}		
		}
	}
}