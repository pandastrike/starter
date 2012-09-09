require "starter/extensions/module"
module Starter
  module Extensions

    module String

      def self.camel_case(string)  
        string.split('_').map do |word|
          "#{word.slice(/^\w/).upcase}#{word.slice(/^\w(\w+)/, 1)}"
        end.join
      end

      def self.snake_case(string)
        string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
      end

      def self.title_case(string)
        string.gsub( /\b\w/ ) { |x| x.upcase }
      end

      Starter::Extensions::Module.create_instance_methods(self)

    end

  end
end
