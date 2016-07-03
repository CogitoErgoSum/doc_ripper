#encoding: UTF-8

module DocRipper
  class TextRipper < Ripper::Base
    attr_reader :text_file_path, :file_path

    def rip
      @is_ripped ||=choose_ripper
    end

    def text
      @text ||= IO.read(@text_file_path).force_encoding("ISO-8859-1").encode("utf-8", replace: nil) if rip
    end

    private

    def choose_ripper
      case
      when !!(@file_path[-5.. -1] =~ /.docx/i)
        Formats::DocxRipper.new(@file_path).rip
      when !!(@file_path[-4.. -1] =~ /.doc/i)
        Formats::MsDocRipper.new(@file_path).rip
      when !!(@file_path[-4..-1]  =~ /.pdf/i)
        Formats::PdfRipper.new(@file_path).rip
      when @options[:raise]
        raise UnsupportedFileType
      end
    end

  end
end