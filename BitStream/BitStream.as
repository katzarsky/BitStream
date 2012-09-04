// Bitstream, v1.00 2012-09-05
//
// Description: Bit stream codec implementation in ActionScript3
// Homepage: http://katzarsky.github.com/BitStream
// Author: katzarsky@gmail.com

package
{
	import flash.utils.ByteArray;
	
	public class BitStream extends Object
	{
		protected var ba:ByteArray = new ByteArray();
		protected var bit:uint = 0;
		protected var word:uint = 0;
		protected var one32 = 0xFFFFFFFF;

		public function BitStream()
		{
		}

		/*
		* Gets from the bitstream no more than 32 bits of uint
		*/
		public function readBits(bits:uint):uint // returns uint
		{
			if(bits <= 0 || bits>32) return 0;

			if(this.bit==32 || (this.bit==0 && this.ba.position==0)) { //first time here or 32 bits are full
				this.word = this.ba.readUnsignedInt();
				this.bit = 0;
			}			
			
			var val:uint = 0;

			if(this.bit + bits > 32) { // word underflow - get UINT from the stream to read the remaining bits		
				var low_bits = 32 - this.bit;
				var high_bits = bits - low_bits;
				val = (this.word >> this.bit) & ~(this.one32 << low_bits); // mask only our bits		
				
				this.word = this.ba.readUnsignedInt();
				this.bit = high_bits;
				val |= (this.word & ~(this.one32 << high_bits)) << low_bits;
			}
			else {
				if(bits == 32){
					val = (this.word >> this.bit); 
				}
				else {
					val = (this.word >> this.bit) & ~(this.one32 << bits); // mask only our bits
				}
				this.bit += bits;
			}
			return val;
		}

		/*
		* Puts to the bitstream no more than 32 bits of uint
		*/
		public function writeBits(val:uint, bits:uint):void
		{
			if(bits <= 0 || bits > 32) return;
			
			if(this.bit == 32) { // if it precisely aligns with 32bit - clear it up
				this.ba.writeUnsignedInt(this.word);
				//trace('write',this.string32(this.word));
				this.word = 0;
				this.bit = 0;
			}			
			if(bits != 32) {
				val = val & ~(this.one32 << bits); // mask only our bits
			}
			this.word |= (val << this.bit);
			this.bit += bits;
		
			if(this.bit > 32) { // word overflow - push to the stream and get another empty word

				this.ba.writeUnsignedInt(this.word);
				
				var high_bits:uint = this.bit % 32;
				var low_bits:uint = bits-high_bits;

				this.word = (val >> low_bits) & ~(this.one32 << high_bits);
				this.bit = high_bits;
			}
		}
		
		/*
		* Saves the internal bytearray to base64 string
		*/
		public function saveByteArray():ByteArray
		{
			if(this.bit>0) {
				this.ba.writeUnsignedInt(this.word);
				//trace('write',this.string32(this.word));
			}
			return this.ba;
		}

		/*
		* Loads the internal bytearray with base64 string
		* TODO: maybe it is better to CLONE not assign the ByteArray object
		*/
		public function loadByteArray(a:ByteArray):void
		{
			this.ba = a;
			this.ba.position = 0;
			this.bit = 0;
			this.word = 0;
		}
		
		public function writeLossyBits(val:uint, bits:uint, offset:uint=0, loss_factor:uint=0):void {
			this.writeBits((val+offset) >> loss_factor, bits-loss_factor);
		}
		
		public function readLossyBits(bits:uint, offset:uint=0, loss_factor:uint=0):int {
			return ((this.readBits(bits-loss_factor) << loss_factor)-offset);
		}		
		
		/*
		*	Used for visualization of 32bit binary words
		*/
		public static function string32(val:uint):String
		{
			var str:String = "";
			for(var i=31; i>=0; i--) {
				str += ((val>>i) & 1);
			}
			return str;
		}		
	}
}