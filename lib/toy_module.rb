ToyModule = BasicObject.new

def ToyModule.new
  instance = BasicObject.new

  klass = self

  singleton_class = (class << instance; self; end)
  singleton_class.define_method(:class) { klass }

  class << instance
    # Object instance methods

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

    # Module instance methods

    def constant_map
      @constant_map ||= {}
    end

    def const_get(name)
      name = name.to_sym
      raise NameError, "uninitialized constant #{name} for #{inspect}" unless constant_map.key?(name)

      constant_map[name]
    end

    def const_set(name, value)
      name = name.to_sym
      raise NameError unless name.match?(/^[A-Z][a-zA-Z_]*$/)

      ::Kernel.warn "already initialized constant #{name}" if constant_map.key?(name)

      constant_map[name] = value
    end

    def constants
      constant_map.keys.map(&:to_sym)
    end

    def method_map
      @method_map ||= {}
    end

    def define_method(name, method)
      name = name.to_sym
      method_map[name] = method
    end

    def instance_methods
      method_map.keys.map(&:to_sym)
    end
  end

  instance
end

def ToyModule.to_s
  inspect
end

def ToyModule.inspect
  "ToyModule"
end

def ToyModule.class
  ToyClass
end

def ToyModule.superclass
  ToyObject
end

def ToyModule.kind_of?(klass)
  superclass = self.class
  while superclass
    return true if klass == superclass
    superclass = superclass.superclass
  end
  false
end
