require "pp"
require "starter/extensions/string"

String.send(:include, Starter::Extensions::String)

pp "foo_bar".camel_case
pp "FooBar".snake_case
