BitStream
=========

About
---------
Bit stream codec implementation in ActionScript3 (BitStream.as is the codec).
Faciliates creation of a binary string that consist of arbitrary-bit-length items.
(De)Serializes into ByteArray.

- Can be used in variety of home-made binary codecs.
- Can be used with Base64 codec to send the encoded binary string over JSON, HTTP or other non-binary transport.

Features:
- writeBits 1...32 bits in length.
- readBits 1...32 bits in length.
- saveByteArray - aligns to 32bit word. Pads with zeroes.
- loadByteArray

TODO
---------
- writeSignedBits(-30, 6) - one bit (leftmost) for the sign(negative=1, positive=0), then encodes the number in N-1 bits

License
---------
MIT, see LICENSE file.