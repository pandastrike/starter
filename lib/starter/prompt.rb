module Starter

  module Prompt
    extend self

    def prompt(string)
      print "#{string} "
      value = STDIN.gets.chomp
      if value.size > 1
        return value
      else
        puts "No, I really need a value. Try again."
        prompt(string)
      end
    end

    def confirm(string)
      print "#{string} [y/N] "
      true if STDIN.gets.chomp =~ /^y/i
    end

  end
end

