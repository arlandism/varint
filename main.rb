# Examples taken from the MIDI File format specification table here:
# https://en.wikipedia.org/wiki/Variable-length_quantity
examples = [
  0,
  127,
  128,
  8192,
  16383,
  16384,
  2097151,
  2097152,
  134217728,
  268435455,
]

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

def decode(y)
end

examples.each do |example|
  encoded = encode(example)
  puts "================================"
  puts "encoded #{encoded}"
  puts "The encoded version of #{example} is #{encoded.length} bytes long"
  decoded = decode(encoded)
  puts "Confirmed that decoding works: #{decoded}"
  puts
end
