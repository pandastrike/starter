Gem::Specification.new do |s|
  s.name = "starter"
  s.version = "0.1.7"
  s.authors = ["Matthew King"]
  s.homepage = "https://github.com/automatthew/starter"
  s.summary = "Generally useful and reusable things"

  s.files = %w[
    LICENSE
    Rakefile
    README.md
  ] + Dir["lib/**/*"]
  s.require_path = "lib"
  s.add_dependency("git")
  s.add_dependency("ghee")

end

