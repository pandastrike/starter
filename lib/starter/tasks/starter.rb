require "pp"
require "starter/prompt"
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
    $STARTER[:author] = Starter::Prompt.prompt("Project author?")
  end
end

task "read_git_config" do
  g = Git.open(Dir.pwd)
  $STARTER[:git] = g
end


def confirm_command(command)
  if Starter::Prompt.confirm("Issue command '#{command}'?")
    sh command
  else
    puts "Cancelled."
    exit
  end
end


