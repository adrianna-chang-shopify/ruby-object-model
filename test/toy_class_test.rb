require "test_helper"
require "toy_class"

[
  [Class, Object],
  [ToyClass, ToyObject, "toy_"]
].each do |klass, object_klass, meth_prefix|
  describe klass do
    include TestHelpers

    before do
      @class = call_method(klass, meth_prefix, :new)
    end

    describe "initializing an object" do
      specify "creates an instance of the class" do
        instance = call_method(@class, meth_prefix, :new)
        # Ask the instance what it"s class is; it should be the anonymous
        # Class stored in @class
        assert_equal @class, call_method(instance, meth_prefix, :class)
      end

      specify "creates an instance that acts like an object" do
        skip "TO DO"
      end
    end

    describe "getting a class's superclass" do
      specify "returns the superclass" do
        assert_equal object_klass, call_method(@class, meth_prefix, :superclass)
      end

      specify "works with custom superclass" do
        skip "TO DO"
        # previously, we could do ToyClass.toy_new(SomeClass), and SomeClass
        # would automatically get registered as the superclass
      end
    end
  end
end
