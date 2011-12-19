module AddressStandardization
  module Helpers
    extend self

    def strip_html(str)
      str.gsub(/<\/?([^>]+)>/, '')
    end
    def strip_newlines(str)
      str.gsub(/[\r\n]+/, '')
    end
    def strip_whitespace(str)
      strip_newlines(str).squeeze(" ").strip
    end

    def url_escape(str)
      str.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
        '%' + $1.unpack('H2' * $1.size).join('%').upcase
      end.tr(' ', '+')
    end
  end
end
