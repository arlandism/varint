require_relative '../varint'

RSpec.describe "varint" do
# Examples taken from the MIDI File format specification table here:
# https://en.wikipedia.org/wiki/Variable-length_quantity
  let(:examples) {
    [
      [0, ['0x00']],
      [127, ['0x7f']],
      [128, ['0x81', '0x00']],
      [8192, ['0xc0', '0x00']],
      [16383, ['0xff', '0x7f']],
      [16384, ['0x81', '0x80', '0x00']],
      [2097151, ['0xff', '0xff', '0x7f']],
      [2097152, ['0x81', '0x80', '0x80', '0x00']],
      [134217728, ['0xc0', '0x80', '0x80', '0x00']],
      [268435455, ['0xff', '0xff', '0xff', '0x7f']]
    ]
  }

  context 'helper functions' do
    describe 'another_byte_follows?' do
      it "returns true when the leading bit is flipped" do
        expect(another_byte_follows?('0xff')).to eq(true)
      end

      it "returns true when the leading bit is off" do
        expect(another_byte_follows?('0x0f')).to eq(false)
      end
    end

    describe 'binary_to_decimal' do
      it "computes correctly" do
        expect(binary_to_decimal('00000001')).to eq(1)
        expect(binary_to_decimal('00000011')).to eq(3)
        expect(binary_to_decimal('00001111')).to eq(15)
        expect(binary_to_decimal('000000011111010000000000')).to eq(128_000)
      end
    end

    describe 'decode_byte_to_binary' do
      it "strips the leading bit and converts the byte" do
        expect(decode_byte_to_binary('0x80')).to eq('0000000')
      end
    end
  end

  describe "encode" do
    it "examples work" do
      examples.each do |example|
        encoded = encode(example[0])
        expect(encoded).to eq(example[1])
      end
    end
  end

  describe "decode" do
    it "examples decode to themselves" do
      examples.each do |example|
        encoded = encode(example[0])
        decoded = decode(encoded)
        expect(decoded).to eq(example[0])
      end
    end
  end
end
