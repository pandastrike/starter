require "starter/tasks/helpers"

desc "Create a git tag using the project version"
# Note that the user of this library must ensure that a task named
# "version" is defined before invocation time.
task "tag" => "version" do
  version = ENV["version"]
  git_tag = `git tag -l #{version}`.chomp
  if git_tag == version
    puts "Tag #{version} already exists. Bump the version in the gemspec."
  else
    message = ENV["message"] || version
    command = "git tag -am #{message} #{version}"
    confirm_command(command)
  end
end


