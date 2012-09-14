require "pp"
require "starter/extensions/module"
require "starter/extensions/string"

Module.send(:include, Starter::Extensions::Module)

pp Starter::Extensions::String.local_methods

