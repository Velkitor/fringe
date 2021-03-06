class String
  require 'json'
  # Barrow these from ActiveSupport
  def camelize(uppercase_first_letter = true)
    string = self.dup
    if uppercase_first_letter
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
    end
    string.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
  end

  def underscore
    word = self.dup
    word.gsub!('::', '/')
    word.gsub!(/(?:([A-Za-z\d])|^)((?=a)b)(?=\b|[^a-z])/) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

  def constantize
    Object.const_get(self)
  end

  # Custom additions
  def from_json
    JSON.parse(self)
  end
end
