module Toy
  module Behaviours
    module InstanceVariables
      def instance_variable_get(name)
        ivar_map[name.to_sym]
      end

      def instance_variable_set(name, value)
        ivar_map[name.to_sym] = value
      end

      def instance_variables
        ivar_map.keys
      end

      def instance_variable_defined?(name)
        ivar_map.has_key?(name.to_sym)
      end

      def remove_instance_variable(name)
        ivar_map.delete(name.to_sym)
      end

      private

      def ivar_map
        @ivar_map ||= {}
      end
    end

    module Constants
      def const_get(name)
        name = name.to_sym
        ::Kernel.raise ::NameError, "uninitialized constant #{inspect}::#{name}" unless constant_map.key?(name)

        constant_map[name]
      end

      def const_set(name, value)
        name = name.to_sym
        ::Kernel.raise ::NameError unless name.match?(/^[A-Z][a-zA-Z_]*$/)

        ::Kernel.warn "already initialized constant #{inspect}::#{name}" if constant_map.key?(name)

        constant_map[name] = value
      end

      def constants
        constant_map.keys.map(&:to_sym)
      end

      private

      def constant_map
        @constant_map ||= {}
      end
    end

    module Methods
      def define_method(name, method)
        name = name.to_sym
        method_map[name] = method
      end

      def instance_methods
        method_map.keys.map(&:to_sym)
      end

      private

      def method_map
        @method_map ||= {}
      end
    end

    module ClassRelationships
      def kind_of?(klass)
        superclass = self.class
        while superclass
          return true if klass == superclass
          superclass = superclass.superclass
        end
        false
      end
    end
  end
end
