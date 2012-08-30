require "starter/tasks/helpers"

unless gemspec = FileList["*.gemspec"].first
  raise "Could not find a gemspec in the working directory"
end

project_name = gemspec.chomp(".gemspec")

desc "build a gem using #{gemspec}"
task "gem:build" do
  sh "gem build #{gemspec}"
end

task "gem:push" do
  gemfiles = FileList["#{project_name}-*.gem"]
  if gemfiles.size == 1
    command = "gem push #{gemfiles.first}"
    confirm_command(command)
  else
    puts "Found more than one gemfile in the working directory."
  end
end

task "version" do
  str = File.read(gemspec)
  spec = eval(str)
  ENV["version"] = spec.version.version
end

task "clean" do
  FileList["#{project_name}-*.gem"].each do |file|
    rm file
  end
end

