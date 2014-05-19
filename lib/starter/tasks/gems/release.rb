require "starter/tasks/gems"

desc "push rubygem"
task "release" => %w[ gem:push ]

task "gem:push" do
  gemfiles = FileList["#{Starter.cache[:project_name]}-*.gem"]
  if gemfiles.size == 1
    command = "gem push #{gemfiles.first}"
    confirm_command(command)
  else
    puts "Found more than one gemfile in the working directory."
  end
end

