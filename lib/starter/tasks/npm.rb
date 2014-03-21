require "starter/tasks/starter"

task "bootstrap" => %w[ package.json ]

file "package.json" => %w[ determine_author ] do |target|
  sh "npm init"
end


desc "publish as an NPM package"
task "release" => %w[ npm:publish ]

task "npm:publish" => %w[ version ] do
  puts "Version in package.json is #{Starter.cache[:version]}"
  confirm_command("npm publish")
end

task "version" => "read_package" do
  Starter.cache[:version] = Starter.cache[:npm_package][:version]
end

# this seems like it ought to be a function? leaving it here because it seems
# like it might still come in handy
task "read_package" do
  require "json"
  string = File.read("package.json")
  Starter.cache[:npm_package] = JSON.parse(string, :symbolize_names => true)
end


