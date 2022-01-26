module Toy
  class ClassInstance < ModuleInstance
    def initialize(klass: nil, superclass: nil)
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
