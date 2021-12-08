ToyObject = BasicObject.new

def ToyObject.to_s
  inspect
end

def ToyObject.inspect
  "ToyObject"
end

def ToyObject.toy_superclass
  nil
end

def ToyObject.toy_class
  ToyClass
end

# Accomplish the same thing with Enumerator.produce!!
# 
# def ToyObject.toy_kind_of?(klass)
#   e = Enumerator.produce(toy_class) { |klass| klass.toy_superclass or raise StopIteration }
#   e.include?(klass)
# end

def ToyObject.toy_new
  instance = BasicObject.new

  klass = self

  singleton_class = (class << instance; self; end)
  singleton_class.define_method(:toy_class) { klass }

  class << instance
    # Object instance methods

    def ivar_map
      @ivar_map ||= {}
    end

    def toy_instance_variable_get(name)
      ivar_map[name.to_sym]
    end

    def toy_instance_variable_set(name, value)
      ivar_map[name.to_sym] = value
    end

    def toy_instance_variables
      ivar_map.keys
    end

    def toy_instance_variable_defined?(name)
      ivar_map.has_key?(name.to_sym)
    end

    def toy_remove_instance_variable(name)
      ivar_map.delete(name.to_sym)
    end
  end

  instance
end

def ToyObject.toy_kind_of?(klass)
  superclass = toy_class
  while superclass
    return true if klass == superclass
    superclass = superclass.toy_superclass
  end
  false
end
