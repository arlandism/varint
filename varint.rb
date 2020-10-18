def binary_to_decimal(bin)
  length = bin.length
  forward_index = 0
  backward_index = bin.length - 1
  acc = 0
  while forward_index < length do
    bit = bin[forward_index]
    acc += 2 ** backward_index if bit == "1"
    forward_index += 1
    backward_index -= 1
  end
  acc
end

def pad_with_zeroes(str, desired_len)
  str.rjust(desired_len, '0')
end

def encode(x)
  bit_form = x.to_s(2)
  seven_bit_groupings = bit_form.split("").reverse.each_slice(7).to_a.reverse.map do |chunk|
    chunk.reverse.join("").rjust(7, "0")
  end
  least_sig_byte = seven_bit_groupings[-1]
  least_sig_byte.insert(0, "0")
  leading_bytes = seven_bit_groupings[0...seven_bit_groupings.length - 1]
  leading_bytes.each do |byte|
    byte.insert(0, "1")
  end
  seven_bit_groupings.map do |grouping|
    "0x%02x" % grouping.to_i(2)
  end.flatten
end

def another_byte_follows?(byte)
  as_hex = byte.hex
  msb = as_hex & 0x80
  msb != 0
end

# Strips the most significant bit
# as that was only used for the encoding
# scheme
def decode_byte_to_binary(byte)
  pad_with_zeroes(byte.hex.to_s(2), 8)[1..-1]
end

def decode(bytes)
  full_bit_arr = []
  idx = 0
  bytes.each do |byte|
    bit_str = decode_byte_to_binary(byte)
    full_bit_arr << bit_str
    break unless another_byte_follows?(byte)
  end

  binary_to_decimal(
    pad_with_zeroes(
      full_bit_arr.join(""), bytes.length * 8
    )
  )
end
