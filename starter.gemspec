Gem::Specification.new do |s|
  s.name = "starter"
  s.version = "0.2.0"
  s.authors = ["Matthew King"]
  s.homepage = "https://github.com/automatthew/starter"
  s.summary = "Generally useful and reusable things"

  s.files = %w[
    LICENSE
    Rakefile
    README.md
  ] + Dir["lib/**/*"]
  s.require_path = "lib"

  s.add_dependency("git", "~> 1.2.6")
  s.add_dependency("ghee", "~> 0.9.11")
  s.add_dependency("term-ansicolor", "~> 1.3.0")

end

