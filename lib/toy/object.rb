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

    # kind_of?
    include Behaviours::ClassRelationships

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

    def new
      Instance.new(self)
    end
  end

  class Instance < BasicObject
    # Object instance methods
    include Behaviours::InstanceVariables

    # kind_of?
    include Behaviours::ClassRelationships

    # to_s and #inspect
    include Behaviours::Inspection

    def initialize(klass)
      @klass = klass
    end

    def class
      @klass
    end
  end
end
