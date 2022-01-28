module Toy
  Object = ClassInstance.new

  # Open up singleton class of Toy::Object
  class << Object
    def inspect
      "Toy::Object"
    end

    def class
      Class
    end

    def new
      ObjectInstance.new(klass: self)
    end
  end
end
