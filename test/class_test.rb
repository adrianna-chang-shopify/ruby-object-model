require "test_helper"
require "toy_class"

[
  [Class, Object],
  [ToyClass, ToyObject]
].each do |_Class, _Object|
  describe _Class do
    before do
      @class = _Class.new
    end

    describe "initializing an object" do
      specify "creates an instance of the class" do
        instance = @class.new
        # Ask the instance what its class is; it should be the anonymous
        # Class stored in @class
        assert_equal @class, instance.class
      end

      specify "creates an instance that acts like an object" do
        skip "TO DO"
      end
    end

    describe "getting a class's superclass" do
      specify "returns the superclass" do
        assert_equal _Object, @class.superclass
      end

      specify "works with custom superclass" do
        skip "TO DO"
        # previously, we could do ToyClass.new(SomeClass), and SomeClass
        # would automatically get registered as the superclass
      end
    end
  end
end
