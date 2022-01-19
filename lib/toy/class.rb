require "toy/behaviours"
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
      instance = BasicObject.new

      klass = self

      singleton_class = (class << instance; self; end)
      singleton_class.define_method(:class) { klass }
      singleton_class.define_method(:superclass) { superclass }

      class << instance
        # Object instance methods
        include Behaviours::InstanceVariables

        # Module instance methods
        include Behaviours::Constants
        include Behaviours::Methods

        # kind_of?
        include Behaviours::ClassRelationships

        # to_s and #inspect
        include Behaviours::Inspection

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

            # kind_of?
            include Behaviours::ClassRelationships

            # to_s and #inspect
            include Behaviours::Inspection
          end

          instance
        end
      end

      instance
    end
  end
end
