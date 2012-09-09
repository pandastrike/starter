require "pp"
require "starter/extensions/string"
require "git"

$STARTER ||= {}

$STARTER[:directory] = File.basename(Dir.pwd)

# Interface task declarations

desc "Bootstrap your project"
task "bootstrap" => "determine_author"

desc "Build everything that needs building"
task "build"

desc "Release the dogs that shoot bees from their mouths"
task "release" => %w[ build ]


task "determine_author" => %w[ read_git_config ] do
  if author = $STARTER[:git].config["user.name"]
    $STARTER[:author] = author
  else
    $STARTER[:author] = prompt("Project author?")
  end
end

task "read_git_config" do
  g = Git.open(Dir.pwd)
  $STARTER[:git] = g
end

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

