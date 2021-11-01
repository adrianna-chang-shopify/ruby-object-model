require "toy_module"
require "toy_object"

class ToyClass < ToyModule
  def self.toy_new(toy_superclass = ToyObject)
    new(self, toy_superclass)
  end

  def initialize(toy_class, toy_superclass)
    @toy_superclass = toy_superclass
    super(toy_class)
  end

  def toy_new
    ToyObject.new(self)
  end

  def toy_superclass
    @toy_superclass
  end
end
