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

      def self.hex(string)
        string.unpack("H*")[0]
      end

      def self.unhex(string)
        [string].pack("H*")
      end

      def self.xor(str1, str2)
        a1 = str1.unpack('C*')
        a2 = str2.unpack('C*') * (str1.length / str2.length + 1)
        xor = ""
        0.upto(a1.length - 1) do |i|
          x = a1[i] ^ a2[i].to_i
          xor << x.chr()
        end
        xor
      end

      Starter::Extensions::Module.create_instance_methods(self)

      module Compression
        def self.included(mod)
          require "zlib"
        end

        def self.gzip(string)
          sio = StringIO.new
          gz = Zlib::GzipWriter.new(sio)
          gz.write(string)
          gz.close
          sio.string
        end 

        Starter::Extensions::Module.create_instance_methods(self)
      end

    end

  end
end
