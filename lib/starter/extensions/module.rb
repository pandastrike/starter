# "local" methods are those defined directly on a class or module, 
# as opposed to those inherited or mixed in
module Starter
  module Extensions

    module Module
      
      def self.basename(mod)
        mod.name.split('::').last
      end

      def self.local_methods(mod)
        mod.public_methods.select do |m|
          owner = mod.method(m).owner
          owner == mod.singleton_class || owner == mod
        end
      end
      
      def self.local_instance_methods(mod)
        mod.public_instance_methods.select do |m|
          owner = mod.instance_method(m).owner
          owner == mod
        end
      end

      # For every locally-defined class method, create an instance method
      # of the same name which operates on the instance.  This allows you
      # to create Modules which can be used as mixins, but the methods are
      # also available on the module itself, in case a user does not want
      # to include the module.
      def self.create_instance_methods(mod)
        self.local_methods(mod).each do |method_name|
          mod.module_eval <<-METHOD, __FILE__, __LINE__
            def #{method_name}(*args)
              #{mod}.#{method_name}(self, *args)
            end
          METHOD
        end
      end

      self.create_instance_methods(self)
      
    end

  end
end

