require "starter/tasks/npm"

desc "publish as an NPM package"
task "release" => %w[ npm:publish ]

task "npm:publish" => %w[ version ] do
  puts "Version in package.json is #{Starter.cache[:version]}"
  confirm_command("npm publish")
end


