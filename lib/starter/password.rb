require "starter/prompt"
module Starter

  class Password < String
    extend Prompt

    def self.request(service)
      begin
        system "stty -echo"
        value = prompt "Password for #{service}:"
      ensure
        system "stty echo"
        puts
      end
      self.new(value)
    end

    def initialize(*args)
      super
    end

    def inspect
      "#<Starter::Password>"
    end

  end

end
