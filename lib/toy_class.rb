require "toy_module"
require "toy_object"

class ToyClass < ToyModule
  def initialize(toy_superclass = ToyObject)
    @toy_superclass = toy_superclass
    super
  end

  def toy_new
    ToyObject.new
  end

  def toy_superclass
    @toy_superclass
  end
end
