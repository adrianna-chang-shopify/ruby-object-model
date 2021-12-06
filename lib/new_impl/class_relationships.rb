module NewImpl
  # Think of these toy objects as the singletons
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

  ToyModule = BasicObject.new

  def ToyModule.toy_new
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
    end

    instance
  end

  def ToyModule.to_s
    inspect
  end

  def ToyModule.inspect
    "ToyModule"
  end

  def ToyModule.toy_class
    ToyClass
  end

  def ToyModule.toy_superclass
    ToyObject
  end

  def ToyModule.toy_kind_of?(klass)
    superclass = toy_class
    while superclass
      return true if klass == superclass
      superclass = superclass.toy_superclass
    end
    false
  end

  ToyClass = BasicObject.new

  def ToyClass.toy_new
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

        # singleton class is the singleton class of the instance of the anonymous class
        singleton_class = (class << instance; self; end)
        singleton_class.define_method(:toy_class) { klass }

        #  TO DO: Make this instance act like a proper ToyObject
        instance
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

  def ToyClass.toy_class
    ToyClass
  end

  def ToyClass.toy_superclass
    ToyModule
  end

  def ToyClass.toy_kind_of?(klass)
    superclass = toy_class
    while superclass
      return true if klass == superclass
      superclass = superclass.toy_superclass
    end
    false
  end
end
