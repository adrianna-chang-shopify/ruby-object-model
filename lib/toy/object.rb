require "toy/behaviours"

module Toy
  Object = BasicObject.new

  # Open up singleton class of Toy::Object
  class << Object
    # Object instance methods, because the Object singleton is an object yo!
    include Behaviours::InstanceVariables

    # Module instance methods, because the Object singleton is a module yo!
    include Behaviours::Constants
    include Behaviours::Methods

    def to_s
      inspect
    end
  
    def inspect
      "Toy::Object"
    end
  
    def superclass
      nil
    end
  
    def class
      Class
    end

    def kind_of?(klass)
      superclass = self.class
      while superclass
        return true if klass == superclass
        superclass = superclass.superclass
      end
      false
    end

    def new
      instance = BasicObject.new
  
      klass = self
  
      singleton_class = (class << instance; self; end)
      singleton_class.define_method(:class) { klass }
  
      class << instance
        # Object instance methods
        include Behaviours::InstanceVariables
  
        def inspect
          "#<#{self.class}>"
        end
      end
  
      instance
    end
  end
end
