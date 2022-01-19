require "toy/behaviours"

module Toy
  Module = BasicObject.new

  # Open up singleton class of Toy::Module
  class << Module
    # Object instance methods, because the Module singleton is an object yo!
    include Behaviours::InstanceVariables

    # Module instance methods, because the Module singleton is a module yo!
    include Behaviours::Constants
    include Behaviours::Methods

    # kind_of?
    include Behaviours::ClassRelationships

    def to_s
      inspect
    end

    def inspect
      "Toy::Module"
    end

    def class
      Class
    end

    def superclass
      Object
    end

    def new
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

        # kind_of?
        include Behaviours::ClassRelationships

        def inspect
          "#<#{self.class}>"
        end
      end

      instance
    end
  end
end
