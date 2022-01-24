module Toy
  class ObjectInstance < BasicObject
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
