require_relative '../varint'

RSpec.describe "varint" do
  describe "encode and decode" do
    it "examples work" do
      (-1_000_000..1_000_000).each do |example|
        expect(decode(encode(example))).to eq(example)
      end
    end
  end
end
