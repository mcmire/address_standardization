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
end