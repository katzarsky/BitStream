BitStream
=========

Bit stream codec implementation. Written in AS3. 
Faciliates creation of binary string that consist of arbitrary-length items in bits.

- Can be used in variety of home-made binary codecs.
- Can be used with Base64 codec to send the encoded binary string over JSON, HTTP or other non-binary transport.

Features:
- writeBits 1...32 bits in length.
- readBits 1...32 bits in length.
- saveByteArray - aligns to 32bit word. Pads with zeroes.
- loadByteArray

