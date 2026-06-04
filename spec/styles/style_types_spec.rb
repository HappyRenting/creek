require './spec/spec_helper'

describe Creek::Styles::StyleTypes do
  let(:doc) { Nokogiri::XML(File.open('spec/fixtures/styles/first.xml')) }
  let(:style_types) { Creek::Styles::StyleTypes.new(doc) }

  describe :call do
    it "return array of styletypes with mapping to ruby types" do
      res = style_types.call
      expect(res.size).to eq(8)
      expect(res[3]).to eq(:date_time)
      expect(res).to eq([:unsupported, :unsupported, :unsupported, :date_time, :unsupported, :unsupported, :unsupported, :unsupported])
    end
  end

  describe :num_fmt_ids do
    it "returns the raw numFmtId for each style index" do
      # first.xml cellXfs: 8 entries, indexes 0..2, 4..7 use 164 ; index 3 uses 165
      expect(style_types.num_fmt_ids).to eq([164, 164, 164, 165, 164, 164, 164, 164])
    end
  end

  describe :custom_format_codes do
    it "returns a map of custom numFmtId to its raw formatCode string" do
      expect(style_types.custom_format_codes).to eq(164 => 'GENERAL', 165 => 'MM/DD/YYYY')
    end
  end
end
