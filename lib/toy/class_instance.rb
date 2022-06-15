module Toy
  class ClassInstance < ModuleInstance
    def initialize(klass: nil, superclass: nil)
      super(klass: klass)
      @superclass = superclass
    end

    def superclass
      @superclass
    end

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
