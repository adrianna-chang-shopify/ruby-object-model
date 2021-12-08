require "toy_object"

ToyClass = BasicObject.new

def ToyClass.new
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

    def toy_const_get(name)
      name = name.to_sym
      raise NameError, "uninitialized constant #{name} for #{inspect}" unless constant_map.key?(name)

      constant_map[name]
    end

    def toy_const_set(name, value)
      name = name.to_sym
      raise NameError unless name.match?(/^[A-Z][a-zA-Z_]*$/)

      ::Kernel.warn "already initialized constant #{name}" if constant_map.key?(name)

      constant_map[name] = value
    end

    def toy_constants
      constant_map.keys.map(&:to_sym)
    end

    def method_map
      @method_map ||= {}
    end

    def toy_define_method(name, method)
      name = name.to_sym
      method_map[name] = method
    end

    def toy_instance_methods
      method_map.keys.map(&:to_sym)
    end

    # Class instance methods
    def toy_new
      instance = BasicObject.new

      # self is our anonymous class
      # In Ruby, this would look like #<Class:0x00007fae319f3bc0>
      klass = self

      # singleton_class is the singleton class of the instance of the anonymous class
      singleton_class = (class << instance; self; end)
      singleton_class.define_method(:toy_class) { klass }

      #  TO DO: Make this instance act like a proper ToyObject
      instance
    end

    def toy_superclass
      ::ToyObject
    end
  end

  instance
end

def ToyClass.to_s
  inspect
end

def ToyClass.inspect
  "ToyClass"
end

def ToyClass.class
  ToyClass
end

def ToyClass.superclass
  ToyModule
end

def ToyClass.kind_of?(klass)
  superclass = self.class
  while superclass
    return true if klass == superclass
    superclass = superclass.superclass
  end
  false
end
