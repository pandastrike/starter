require "starter/tasks/starter"

task "bootstrap" => %w[ package.json ]

file "package.json" => %w[ determine_author ] do |target|
  sh "npm init"
end


desc "publish as an NPM package"
task "release" => %w[ npm:publish ]

task "npm:publish" => %w[ version ] do
  puts "Version in package.json is #{$STARTER[:version]}"
  confirm_command("npm publish")
end

task "version" => "read_package" do
  $STARTER[:version] = $STARTER[:npm_package][:version]
end

# this seems like it ought to be a function? leaving it here because it seems
# like it might still come in handy
task "read_package" do
  require "json"
  string = File.read("package.json")
  $STARTER[:npm_package] = JSON.parse(string, :symbolize_names => true)
end


