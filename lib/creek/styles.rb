# frozen_string_literal: true

module Creek
  class Styles
    attr_accessor :book

    def initialize(book)
      @book = book
    end

    def path
      'xl/styles.xml'
    end

    def styles_xml
      @styles_xml ||= if @book.files.file.exist?(path)
                        doc = @book.files.file.open path
                        Nokogiri::XML::Document.parse doc
                      end
    end

    def style_types
      @style_types ||= Creek::Styles::StyleTypes.new(styles_xml).call
    end

    # Array of numFmtIds in cellXfs order (one entry per style index).
    def num_fmt_ids
      @num_fmt_ids ||= begin
        Creek::Styles::StyleTypes.new(styles_xml).num_fmt_ids
      end
    end

    # Map of (numFmtId >= 164) (custom styles) to the raw formatCode string.
    def custom_format_codes
      @custom_format_codes ||= begin
        Creek::Styles::StyleTypes.new(styles_xml).custom_format_codes
      end
    end
  end
end
