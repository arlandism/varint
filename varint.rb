SIGN_MASK = 0x40
TRAILING_7_MASK = 0x7f
HIGH_ORDER_BIT_MASK = 0x80

def encode(x)
  bytes = []
  acc = x
  loop do
    byte = acc & TRAILING_7_MASK
    acc = acc >> 7
    sign_bit = (byte & SIGN_MASK)
    if (acc == 0 && sign_bit == 0) || (acc == -1 && sign_bit != 0)
      bytes << byte # last byte needs no mask
      return bytes
    end

    bytes << (byte | HIGH_ORDER_BIT_MASK)
  end
end

def decode(bytes)
  num = 0
  shift = 0
  bytes.each_with_index do |byte, index|
    original = byte & TRAILING_7_MASK
    # shift the bits in this byte back to their original ordering, then add them
    num = num | (original << shift)
    shift += 7
    if (index == bytes.length - 1) && (byte & SIGN_MASK) != 0
      # dealing with a negative number, so sign extend
      num = num | (-1 << shift)
    end
  end
  num
end

