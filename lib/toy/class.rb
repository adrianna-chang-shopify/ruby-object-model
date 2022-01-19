require "toy/behaviours"
require "toy/module"
require "toy/object"

module Toy
  Class = BasicObject.new

  # Open up singleton class of Toy::Class
  class << Class
    # Object instance methods, because the Class singleton is an object yo!
    include Behaviours::InstanceVariables

    # Module instance methods, because the Class singleton is a module yo!
    include Behaviours::Constants
    include Behaviours::Methods

    # kind_of?
    include Behaviours::ClassRelationships

    def to_s
      inspect
    end

    def inspect
      "Toy::Class"
    end

    def class
      Class
    end

    def superclass
      Module
    end

    def new(superclass = Object)
      ClassInstance.new(self, superclass)
    end
  end

  class ClassInstance < ModuleInstance
    def initialize(klass, superclass)
      super(klass)
      @superclass = superclass
    end

    def superclass
      @superclass
    end

    # Class instance methods
    def new
      ObjectInstance.new(self)
    end
  end
end
