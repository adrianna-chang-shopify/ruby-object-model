module Toy
  class ObjectInstance < BasicObject
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

    def kind_of?(klass)
      superclass = self.class
      while superclass
        return true if klass == superclass
        superclass = superclass.superclass
      end
      false
    end

    def to_s
      inspect
    end

    def inspect
      "#<#{self.class}>"
    end

    def initialize(klass: nil)
      @klass = klass
    end

    def class
      @klass
    end

    def method(selector)
      superclass = self.class

      # Check up the superclass hierarchy to see if any of them define the selector.
      # Check the superclasses to see if any of their mixins define the selector.
      while superclass
        return Method.new(superclass) if superclass.instance_methods.include?(selector)

        # Check mixed-in Modules to see if they define the selector
        superclass.included_modules.each do |mixin|
          return Method.new(mixin) if mixin.instance_methods.include?(selector)
        end

        superclass = superclass.superclass
      end
      ::Kernel.raise ::NameError, "undefined method `#{selector}' for class `#{self.class.inspect}'"
    end

    class Method < BasicObject
      def initialize(owner)
        @owner = owner
      end

      attr_reader :owner
    end

    private

    def ivar_map
      @ivar_map ||= {}
    end
  end
end
