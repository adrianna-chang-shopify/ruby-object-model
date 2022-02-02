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

    private

    def ivar_map
      @ivar_map ||= {}
    end
  end
end
