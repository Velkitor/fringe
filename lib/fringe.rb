require 'ext/string'
Dir[File.join(File.dirname(__FILE__), 'fringe', '**', '*.rb')].each {|file| require file }
