require "starter/tasks/starter"

desc "Install gem dependencies"
task "gem_dependencies:install" do
  require 'rubygems/dependency_installer'
  installer = Gem::DependencyInstaller.new
  $STARTER[:gem_dependencies].each do |name, version|
    begin
      Gem::Specification.find_by_name(name, version)
    rescue LoadError
      puts "Installing dependency: #{name} #{version}"
      installer.install(name, version)
    end
  end
end


