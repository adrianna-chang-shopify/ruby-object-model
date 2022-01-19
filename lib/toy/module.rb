require "toy/behaviours"
require "toy/object"

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
      ModuleInstance.new(self)
    end
  end

  class ModuleInstance < ObjectInstance
    # Module instance methods
    include Behaviours::Constants
    include Behaviours::Methods
  end
end
