module Toy
  Module = ClassInstance.new(superclass: Object)

  # Open up singleton class of Toy::Module
  class << Module
    def inspect
      "Toy::Module"
    end

    def class
      Class
    end

    def new
      ModuleInstance.new(klass: self)
    end
  end
end
