module Toy
  class ClassInstance < ModuleInstance
    def initialize(klass: nil, superclass: nil)
      super(klass: klass)
      @superclass = superclass
    end

    def superclass
      @superclass
    end

    # This is still problematic if there's duplication between this class's ancestors
    # and its superclass (and its ancestors)
    # Does this fix it?
    # class_ancestors = super
    # class_ancestors += superclass.ancestors if superclass
    # class_ancestors.uniq { |ancestor| ancestor.__id__ }
    def ancestors
      class_ancestors = super.uniq(&:__id__)
      class_ancestors += superclass.ancestors if superclass
      class_ancestors
    end

    # Class instance methods
    def new
      ObjectInstance.new(klass: self)
    end
  end
end
