

task "bootstrap" => %w[ package.json ]

file "package.json" => %w[ determine_author ] do |target|
  string = package_template(options)
  File.open(target.name, "w") do |file|
  end
end

def package_template(options={})
  package = <<-TXT
  TXT
end

