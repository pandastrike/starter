require "starter/tasks/starter"

task "release" => %w[ git:tag ]

desc "Create a git tag using the project version"
# Note that the user of this library must ensure that a task named
# "version" is defined before invocation time.
task "git:tag" => "version" do
  version = $STARTER[:version]
  git_tag = `git tag -l #{version}`.chomp
  if git_tag == version
    puts "Tag #{version} already exists. Bump your version."
  else
    message = ENV["message"] || version
    command = "git tag -am #{message} #{version}"
    confirm_command(command)
  end
end


