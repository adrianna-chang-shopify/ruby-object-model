require "toy/behaviours"
require "toy/object"

module Toy
  Class = BasicObject.new

  def Class.new(superclass = Object)
    instance = BasicObject.new

    klass = self

    singleton_class = (class << instance; self; end)
    singleton_class.define_method(:class) { klass }
    singleton_class.define_method(:superclass) { superclass }

    class << instance
      # Object instance methods
      include Behaviours::InstanceVariables

      def inspect
        "#<#{self.class}>"
      end

      # Module instance methods

      def constant_map
        @constant_map ||= {}
      end

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

      # Class instance methods
      def new
        instance = BasicObject.new

        # self is our anonymous class
        # In Ruby, this would look like #<Class:0x00007fae319f3bc0>
        klass = self

        # singleton_class is the singleton class of the instance of the anonymous class
        singleton_class = (class << instance; self; end)
        singleton_class.define_method(:class) { klass }

        class << instance
          # Object instance methods
          include Behaviours::InstanceVariables
        end      

        instance
      end
    end

    instance
  end

  def Class.to_s
    inspect
  end

  def Class.inspect
    "Toy::Class"
  end

  def Class.class
    Class
  end

  def Class.superclass
    Module
  end

  def Class.kind_of?(klass)
    superclass = self.class
    while superclass
      return true if klass == superclass
      superclass = superclass.superclass
    end
    false
  end
end
