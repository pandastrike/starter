require "pp"
require "starter/prompt"
require "starter/extensions/string"
require "git"

$STARTER ||= {}

$STARTER[:directory] = File.basename(Dir.pwd)

# Interface task declarations

#desc "Build everything that needs building"
task "build"

#desc "Release the dogs that shoot bees from their mouths"
task "release" => %w[ build ]

directory ".starter"

task ".starter" do
  gitignore(".starter")
end

task "determine_author" => %w[ read_git_config ] do
  if (git = $STARTER[:git]) && (author = git.config["user.name"])
    $STARTER[:author] = author
  else
    $STARTER[:author] = Starter::Prompt.prompt("Project author?")
  end
end

task "read_git_config" do
  if File.exist?(".git")
    g = Git.open(Dir.pwd)
    $STARTER[:git] = g
  end
end


def confirm_command(command)
  if Starter::Prompt.confirm("Issue command '#{command}'?")
    sh command
  else
    puts "Cancelled."
    exit
  end
end

def gitignore(string)
  Starter::Prompt.confirm "Append #{string} to your .gitignore?" do
    File.open(".gitignore", "a") do |f|
      f.puts(string)
    end
  end
end

