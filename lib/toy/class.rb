module Toy
  Class = ClassInstance.new(superclass: Module)

  # Open up singleton class of Toy::Class
  class << Class
    def inspect
      "Toy::Class"
    end

    def class
      Class
    end

    def new(superclass = Object)
      ClassInstance.new(klass: self, superclass: superclass)
    end
  end
end
