ToyObject = BasicObject.new

def ToyObject.to_s
  inspect
end

def ToyObject.inspect
  "ToyObject"
end

def ToyObject.superclass
  nil
end

def ToyObject.class
  ToyClass
end

# Accomplish the same thing with Enumerator.produce!!
# 
# def ToyObject.kind_of?(klass)
#   e = Enumerator.produce(self.class) { |klass| klass.superclass or raise StopIteration }
#   e.include?(klass)
# end

def ToyObject.new
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
  end

  instance
end

def ToyObject.kind_of?(klass)
  superclass = self.class
  while superclass
    return true if klass == superclass
    superclass = superclass.superclass
  end
  false
end
