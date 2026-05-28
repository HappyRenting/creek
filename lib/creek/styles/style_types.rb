# https://github.com/hmcgowan/roo/blob/master/lib/roo/excelx.rb
# https://github.com/woahdae/simple_xlsx_reader/blob/master/lib/simple_xlsx_reader.rb#L231
module Creek
  class Styles
    class StyleTypes
      include Creek::Styles::Constants
      attr_accessor :styles_xml_doc
      def initialize(styles_xml_doc)
        @styles_xml_doc = styles_xml_doc
      end

      # Excel doesn't record types for some cells, only its display style, so
      # we have to back out the type from that style.
      #
      # Some of these styles can be determined from a known set (see NumFmtMap),
      # while others are 'custom' and we have to make a best guess.
      #
      # This is the array of types corresponding to the styles a spreadsheet
      # uses, and includes both the known style types and the custom styles.
      #
      # Note that the xml sheet cells that use this don't reference the
      # numFmtId, but instead the array index of a style in the stored list of
      # only the styles used in the spreadsheet (which can be either known or
      # custom). Hence this style types array, rather than a map of numFmtId to
      # type.
      def call
        @style_types ||= begin
          styles_xml_doc.css('styleSheet cellXfs xf').map do |xstyle|
            a = num_fmt_id(xstyle)
            style_type_by_num_fmt_id( a )
          end
        end
      end

      #returns the numFmtId value if it's available
      def num_fmt_id(xstyle)
        return nil unless xstyle.attributes['numFmtId']
        xstyle.attributes['numFmtId'].value
      end

      # Finds the type we think a style is; For example, fmtId 14 is a date
      # style, so this would return :date.
      #
      # Note, custom styles usually (are supposed to?) have a numFmtId >= 164,
      # but in practice can sometimes be simply out of the usual "Any Language"
      # id range that goes up to 49. For example, I have seen a numFmtId of
      # 59 specified as a date. In Thai, 59 is a number format, so this seems
      # like a bad idea, but we try to be flexible and just go with it.
      def style_type_by_num_fmt_id(id)
        return nil unless id
        id = id.to_i
        NumFmtMap[id] || custom_style_types[id]
      end

      # Returns the array of numFmtIds in cellXfs order (one entry per style
      # index used by sheet cells). Mirrors #call but keeps the raw numFmtId
      # instead of deriving a type symbol.
      def num_fmt_ids
        @num_fmt_ids ||= styles_xml_doc.css('styleSheet cellXfs xf').map do |xstyle|
          id = num_fmt_id(xstyle)
          id && id.to_i
        end
      end

      # Map of (numFmtId >= 164) (custom styles) to the raw formatCode string.
      # Distinct from #custom_style_types which maps to a derived type symbol.
      # ex. {164 => "dd/mm/yyyy hh:mm"}
      def custom_format_codes
        @custom_format_codes ||= styles_xml_doc.css('styleSheet numFmts numFmt').inject({}) do |acc, xstyle|
          index      = xstyle.attributes['numFmtId'].value.to_i
          acc[index] = xstyle.attributes['formatCode'].value
          acc
        end
      end

      # Map of (numFmtId >= 164) (custom styles) to our best guess at the type
      # ex. {164 => :date_time}
      def custom_style_types
        @custom_style_types ||= begin
          styles_xml_doc.css('styleSheet numFmts numFmt').inject({}) do |acc, xstyle|
            index      = xstyle.attributes['numFmtId'].value.to_i
            value      = xstyle.attributes['formatCode'].value
            acc[index] = determine_custom_style_type(value)
            acc
          end
        end
      end

      # This is the least deterministic part of reading xlsx files. Due to
      # custom styles, you can't know for sure when a date is a date other than
      # looking at its format and gessing. It's not impossible to guess right,
      # though.
      #
      # http://stackoverflow.com/questions/4948998/determining-if-an-xlsx-cell-is-date-formatted-for-excel-2007-spreadsheets
      def determine_custom_style_type(string)
        return :float if string[0] == '_'
        return :float if string[0] == ' 0'

        # Looks for one of ymdhis outside of meta-stuff like [Red]
        return :date_time if string =~ /(^|\])[^\[]*[ymdhis]/i

        return :unsupported
      end
    end
  end
end
