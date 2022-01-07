require "toy/behaviours"

module Toy
  Module = BasicObject.new

  def Module.new
    instance = BasicObject.new

    klass = self

    singleton_class = (class << instance; self; end)
    singleton_class.define_method(:class) { klass }

    class << instance
      # Object instance methods
      include Behaviours::InstanceVariables

      # Module instance methods
      include Behaviours::Constants
      include Behaviours::Methods
    end

    instance
  end

  def Module.to_s
    inspect
  end

  def Module.inspect
    "Toy::Module"
  end

  def Module.class
    Class
  end

  def Module.superclass
    Object
  end

  def Module.kind_of?(klass)
    superclass = self.class
    while superclass
      return true if klass == superclass
      superclass = superclass.superclass
    end
    false
  end
end
