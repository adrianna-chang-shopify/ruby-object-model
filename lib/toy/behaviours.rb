module Toy
  module Behaviours
    module InstanceVariables
      def ivar_map
        @ivar_map ||= {}
      end

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
    end
  end
end
