module Toy
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
