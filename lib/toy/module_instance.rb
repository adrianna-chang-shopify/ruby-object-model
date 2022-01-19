require "toy/behaviours"
require "toy/object_instance"

module Toy
  class ModuleInstance < ObjectInstance
    # Module instance methods
    include Behaviours::Constants
    include Behaviours::Methods
  end
end
