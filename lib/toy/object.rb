require "toy/behaviours"

module Toy
  Object = BasicObject.new

  def Object.to_s
    inspect
  end

  def Object.inspect
    "Toy::Object"
  end

  def Object.superclass
    nil
  end

  def Object.class
    Class
  end

  # Accomplish the same thing with Enumerator.produce!!
  # 
  # def Object.kind_of?(klass)
  #   e = Enumerator.produce(self.class) { |klass| klass.superclass or raise StopIteration }
  #   e.include?(klass)
  # end

  def Object.new
    instance = BasicObject.new

    klass = self

    singleton_class = (class << instance; self; end)
    singleton_class.define_method(:class) { klass }

    class << instance
      # Object instance methods
      include Behaviours::InstanceVariables

      def inspect
        "#<#{self.class}>"
      end
    end

    instance
  end

  def Object.kind_of?(klass)
    superclass = self.class
    while superclass
      return true if klass == superclass
      superclass = superclass.superclass
    end
    false
  end
end
