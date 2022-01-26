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
      ClassInstance.new(klass: self, superclass: superclass)
    end
  end
end
