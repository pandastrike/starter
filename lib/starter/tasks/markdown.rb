
task "bootstrap" => %w[ README.md ]

file "README.md" do |target|
   File.open(target.name, "w") do |file|
    file.puts readme(
      :project_name => $STARTER[:directory]
    )
  end 
end


def readme(options)
  project_name = options[:project_name]
  text = <<-TXT
# #{Starter::Extensions::String.camel_case(project_name)}

  TXT
end

