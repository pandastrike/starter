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
      if STDIN.gets.chomp =~ /^y/i
        yield if block_given?
        return true
      end
    end

  end
end

