require "starter/tasks/starter"

gemspec_path = FileList["*.gemspec"].first || "#{Starter.cache[:directory]}.gemspec"
project_name = gemspec_path.chomp(".gemspec")

task "bootstrap" => [ gemspec_path, "lib", "lib/#{project_name}.rb" ]


directory "lib"

file "lib/#{project_name}.rb" do |target|
  File.open(target.name, "w") do |file|
    file.puts <<-TXT
module #{Starter::Extensions::String.camel_case(project_name)}

end
    TXT
  end
end

file gemspec_path do |target|
  File.open(target.name, "w") do |file|
    file.puts gemspec_template(
      :author => Starter.cache[:author],
      :project_name => Starter.cache[:directory]
    )
  end
end

desc "Build everything that needs building"
task "build" => %w[ gem:build ]

desc "build a gem using #{gemspec_path}"
task "gem:build" do
  sh "gem build #{gemspec_path}"
end

desc "Install dependencies from the gemspec"
task "gem:deps" => "read_gemspec" do
  gemspec = Starter.cache[:gemspec]

  require 'rubygems/dependency_installer'
  installer = Gem::DependencyInstaller.new
  gemspec.dependencies.each do |dep|
    begin
      Gem::Specification.find_by_name(dep.name, dep.requirement)
    rescue LoadError
      puts "Installing dependency: #{dep.name} #{dep.requirement}"
      installer.install(dep.name, dep.requirement)
    end
  end
end

task "version" => "read_gemspec" do
  Starter.cache[:version] = Starter.cache[:gemspec].version.version
end

task "read_gemspec" do
  Starter.cache[:gemspec] = read_gemspec(gemspec_path)
end

task "clean" do
  FileList["#{project_name}-*.gem"].each do |file|
    rm file
  end
end

def read_gemspec(file)
  str = File.read(file)
  eval(str)
end

def gemspec_template(options={})
  project_name, author = options.values_at(:project_name, :author)
  gemspec = <<-TXT
Gem::Specification.new do |s|
  s.name = "#{project_name}"
  s.version = "0.1.0"
  s.authors = ["#{author}"]
  #s.homepage = ""
  s.summary = "A new project, a nascent bundle of win, whose author hasn't described it yet."

  s.files = %w[
    LICENSE
    README.md
  ] + Dir["lib/**/*.rb"]
  s.require_path = "lib"

  s.add_development_dependency("starter", ">=0.1.0")
end
  TXT
end


