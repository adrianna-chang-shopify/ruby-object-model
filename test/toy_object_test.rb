require "test_helper"
require "toy_class"
require "toy_object"

# Alternative: we could have created a new class, and delegated the missing
# toy methods to Object's native implementation
# class FakeToyObject
#   def method_missing(selector, *args)
#     selector = selector.to_s.delete_prefix("toy_")
#     send selector, *args
#   end
# end

[ 
  [Object, Class], [ToyObject, ToyClass],
  [Module, Class], [ToyModule, ToyClass],
  [Class, Class], [ToyClass, ToyClass]
].each do |klass, class_klass|
  describe klass do
    before do
      @new_method = klass <= ToyObject ? "toy_new" : "new"
      @object = klass.public_send(@new_method)
    end

    describe "accessing instance variables" do
      specify "reading and writing with a Symbol name" do
        call_method(:instance_variable_set, :@foo, :bar)
        assert_equal :bar, call_method(:instance_variable_get, :@foo)

        call_method(:instance_variable_set, :@foo, :baz)
        assert_equal :baz, call_method(:instance_variable_get, :@foo)
      end

      specify "reading and writing with a String name" do
        call_method(:instance_variable_set, "@foo", :bar)
        assert_equal :bar, call_method(:instance_variable_get, "@foo")
      end

      specify "reading with a Symbol and writing with a String name" do
        call_method(:instance_variable_set, "@foo", :bar)
        assert_equal :bar, call_method(:instance_variable_get, :@foo)
      end

      specify "reading with a String and writing with a Symbol name" do
        call_method(:instance_variable_set, :@foo, :bar)
        assert_equal :bar, call_method(:instance_variable_get, "@foo")
      end

      specify "reading an unset instance variable returns nil" do
        assert_nil call_method(:instance_variable_get, :@foo)
      end
    end

    describe "#instance_variables" do
      it "returns the names of existing instance variables" do
        call_method(:instance_variable_set, :@bar, :foo)
        call_method(:instance_variable_set, :@baz, :foo)

        assert_equal [:@bar, :@baz], call_method(:instance_variables)
      end
    end

    describe "#instance_variable_defined?" do
      it "returns true if instance variable is set" do
        call_method(:instance_variable_set, :@bar, :foo)
        assert call_method(:instance_variable_defined?, :@bar)
      end

      it "returns false if instance variable is not set" do
        refute call_method(:instance_variable_defined?, :@bar)
      end
    end

    describe "#remove_instance_variable" do
      it "returns value of instance variable and unsets it" do
        call_method(:instance_variable_set, :@bar, :foo)
        assert call_method(:instance_variable_defined?, :@bar)

        assert_equal :foo, call_method(:remove_instance_variable, :@bar)
        assert_nil call_method(:instance_variable_get, :@foo)
        refute call_method(:instance_variable_defined?, :@foo)
      end
    end

    describe "getting an instance's class" do
      specify "returns the class" do
        my_class = class_klass.public_send(@new_method)
        name = my_class.is_a?(ToyClass) ? "toy_new" : "new"
        my_object = my_class.public_send(name)

        name = my_object.is_a?(ToyObject) ? "toy_class" : "class"
        assert_equal my_class, my_object.public_send(name)
      end

      specify 'uses the correct default class' do
        assert_equal klass, call_method(:class)
      end
    end

    private

    def call_method(name, *args)
      name = @object.class.name.start_with?("Toy") ? "toy_#{name}" : name
      @object.public_send(name, *args)
    end
  end
end
