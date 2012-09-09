# "local" methods are those defined directly on a class or module, 
# as opposed to those inherited or mixed in
module Starter
  module Extensions

    module Module

      def self.local_methods(mod)
        mod.methods.select do |m|
          owner = mod.method(m).owner
          owner == mod.singleton_class || owner == mod
        end
      end
      
      def self.local_instance_methods(mod)
        mod.instance_methods.select do |m|
          owner = mod.instance_method(m).owner
          owner == mod
        end
      end

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

