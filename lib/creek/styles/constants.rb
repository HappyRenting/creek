module Creek
  class Styles
    module Constants
      # Map of non-custom numFmtId to casting symbol
      NumFmtMap = {
        0  => :string,         # General
        1  => :fixnum,         # 0
        2  => :float,          # 0.00
        3  => :fixnum,         # #,##0
        4  => :float,          # #,##0.00
        5  => :unsupported,    # $#,##0_);($#,##0)
        6  => :unsupported,    # $#,##0_);[Red]($#,##0)
        7  => :unsupported,    # $#,##0.00_);($#,##0.00)
        8  => :unsupported,    # $#,##0.00_);[Red]($#,##0.00)
        9  => :percentage,     # 0%
        10 => :percentage,     # 0.00%
        11 => :bignum,         # 0.00E+00
        12 => :unsupported,    # # ?/?
        13 => :unsupported,    # # ??/??
        14 => :date,           # mm-dd-yy
        15 => :date,           # d-mmm-yy
        16 => :date,           # d-mmm
        17 => :date,           # mmm-yy
        18 => :time,           # h:mm AM/PM
        19 => :time,           # h:mm:ss AM/PM
        20 => :time,           # h:mm
        21 => :time,           # h:mm:ss
        22 => :date_time,      # m/d/yy h:mm
        37 => :unsupported,    # #,##0 ;(#,##0)
        38 => :unsupported,    # #,##0 ;[Red](#,##0)
        39 => :unsupported,    # #,##0.00;(#,##0.00)
        40 => :unsupported,    # #,##0.00;[Red](#,##0.00)
        45 => :time,           # mm:ss
        46 => :time,           # [h]:mm:ss
        47 => :time,           # mmss.0
        48 => :bignum,         # ##0.0E+0
        49 => :unsupported     # @
      }

      # Map of non-custom numFmtId to the Excel built-in format code string.
      # Excel does not embed the format code for built-in numFmtIds in xlsx
      # files; this table mirrors the Microsoft spec so consumers can recover
      # the original format string from a style index.
      #
      # Keys must stay in sync with NumFmtMap above (same spec, different
      # projection: NumFmtMap gives the cast type, this gives the raw string).
      #
      # Adapted from Roo::Excelx::Format::STANDARD_FORMATS (MIT license).
      # https://github.com/roo-rb/roo/blob/master/lib/roo/excelx/format.rb
      BuiltinFormatCodes = {
        0  => 'General',
        1  => '0',
        2  => '0.00',
        3  => '#,##0',
        4  => '#,##0.00',
        9  => '0%',
        10 => '0.00%',
        11 => '0.00E+00',
        12 => '# ?/?',
        13 => '# ??/??',
        14 => 'mm-dd-yy',
        15 => 'd-mmm-yy',
        16 => 'd-mmm',
        17 => 'mmm-yy',
        18 => 'h:mm AM/PM',
        19 => 'h:mm:ss AM/PM',
        20 => 'h:mm',
        21 => 'h:mm:ss',
        22 => 'm/d/yy h:mm',
        37 => '#,##0 ;(#,##0)',
        38 => '#,##0 ;[Red](#,##0)',
        39 => '#,##0.00;(#,##0.00)',
        40 => '#,##0.00;[Red](#,##0.00)',
        45 => 'mm:ss',
        46 => '[h]:mm:ss',
        47 => 'mmss.0',
        48 => '##0.0E+0',
        49 => '@'
      }.freeze
    end
  end
end
