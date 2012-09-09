gem "ruby-prof"
require "ruby-prof"

RubyProf.resume do
  do_something
end

Kernel.at_exit do
  data = RubyProf.stop
  printer = RubyProf::GraphHtmlPrinter.new(data)
  File.open("profile.html", "w") do |f|
    printer.print(f)
  end
end

