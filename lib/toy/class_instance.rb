module Toy
  class ClassInstance < ModuleInstance
    def initialize(klass: nil, superclass: nil)
      super(klass: klass)
      @superclass = superclass
      @superclass_ptr = superclass
    end

    def superclass
      @superclass
    end

    # Class instance methods
    def new
      ObjectInstance.new(klass: self)
    end
  end
end
