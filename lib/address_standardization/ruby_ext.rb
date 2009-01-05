class String
  def strip_html
    gsub(/<\/?([^>]+)>/, '')
  end
  def strip_newlines
    gsub(/[\r\n]+/, '')
  end
  def strip_whitespace
    strip_newlines.squeeze(" ").strip
  end
  
  def url_escape
    gsub(/([^ a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
  end
end