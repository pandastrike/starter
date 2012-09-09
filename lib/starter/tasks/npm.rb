

task "bootstrap" => %w[ package.json ]

file "package.json" => %w[ determine_author ] do |target|
  File.open(target.name, "w") do |file|
    file.puts package(
      :project_name => $STARTER[:directory],
      :author => $STARTER[:author],
    )
  end
end


task "npm:release" => %w[ npm:publish ]

task "npm:publish" do
  sh "npm publish"
end



def package(options={})
  project_name, author = options.values_at(:project_name, :author)
  package = <<-TXT
{
  "name": "#{project_name}",
  "description": "A new project, a nascent bundle of win, whose author hasn't described it yet.",
  "author": "#{author}",
  "version": "0.1.0",
  "main": "./lib/#{project_name}.js",
  "files": [
    "lib"
  ],
  "dependencies": {
  },
  "devDependencies": {
  }
}
  TXT
end

