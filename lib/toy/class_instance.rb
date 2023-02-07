module Toy
  class ClassInstance < ModuleInstance
    def initialize(klass: nil, superclass: nil)
      super(klass: klass)
      @superclass = superclass
    end

    def superclass
      @superclass
    end

    # I think I need to refactor this to use linked list style
    # so that we can insert the superclass ahead of the class, prior
    # to the module
    def ancestors
      class_ancestors = super
      if superclass
        ::Kernel.puts "class ancestors: #{class_ancestors}"

        add = superclass.ancestors - class_ancestors
        class_ancestors += add
      end
      class_ancestors
    end

    # Class instance methods
    def new
      ObjectInstance.new(klass: self)
    end
  end
end
