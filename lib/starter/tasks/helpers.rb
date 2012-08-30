
def confirm_command(command)
  print "Issue command '#{command}' [y/N] "
  case STDIN.gets.chomp
  when /^y/i
    sh command
  else
    puts "Cancelled."
    exit
  end
end

