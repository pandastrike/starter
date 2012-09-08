
module Starter
  module String
    extend self
    def camel_case( string )  
      string.split('_').map do |word|
        "#{word.slice(/^\w/).upcase}#{word.slice(/^\w(\w+)/, 1)}"
      end.join
    end

    def snake_case( string )
      string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
    end
  end
end

