# Starter

Starter is the place where I collect all the code that should be reusable, but which I've been copying and pasting here, there, and behind you.

Rake tasks:

```ruby
require "starter/tasks/gems"
require "starter/tasks/git"

desc "Build everything that needs building"
task "build" => %w[ gem:build ]

desc "Build and push the gem, tag the git"
task "release" => %w[ build gem:push tag ]

```
