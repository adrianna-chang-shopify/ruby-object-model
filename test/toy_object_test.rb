require "test_helper"
require "new_impl/class_relationships"

module NewImpl
  [ 
    [Object], [ToyObject, "toy_"],
    [Module], [ToyModule, "toy_"],
    [Class], [ToyClass, "toy_"]
  ].each do |klass, meth_prefix|
    describe klass do
      include TestHelpers

      before do
        @object = call_method(klass, meth_prefix, :new)
      end

      describe "accessing instance variables" do
        specify "reading and writing with a Symbol name" do
          call_method(@object, meth_prefix, :instance_variable_set, :@foo, :bar)
          assert_equal :bar, call_method(@object, meth_prefix, :instance_variable_get, :@foo)

          call_method(@object, meth_prefix, :instance_variable_set, :@foo, :baz)
          assert_equal :baz, call_method(@object, meth_prefix, :instance_variable_get, :@foo)
        end

        specify "reading and writing with a String name" do
          call_method(@object, meth_prefix, :instance_variable_set, "@foo", :bar)
          assert_equal :bar, call_method(@object, meth_prefix, :instance_variable_get, "@foo")
        end

        specify "reading with a Symbol and writing with a String name" do
          call_method(@object, meth_prefix, :instance_variable_set, "@foo", :bar)
          assert_equal :bar, call_method(@object, meth_prefix, :instance_variable_get, :@foo)
        end

        specify "reading with a String and writing with a Symbol name" do
          call_method(@object, meth_prefix, :instance_variable_set, :@foo, :bar)
          assert_equal :bar, call_method(@object, meth_prefix, :instance_variable_get, "@foo")
        end

        specify "reading an unset instance variable returns nil" do
          assert_nil call_method(@object, meth_prefix, :instance_variable_get, :@foo)
        end
      end

      describe "#instance_variables" do
        it "returns the names of existing instance variables" do
          call_method(@object, meth_prefix, :instance_variable_set, :@bar, :foo)
          call_method(@object, meth_prefix, :instance_variable_set, :@baz, :foo)

          assert_equal [:@bar, :@baz], call_method(@object, meth_prefix, :instance_variables)
        end
      end

      describe "#instance_variable_defined?" do
        it "returns true if instance variable is set" do
          call_method(@object, meth_prefix, :instance_variable_set, :@bar, :foo)
          assert call_method(@object, meth_prefix, :instance_variable_defined?, :@bar)
        end

        it "returns false if instance variable is not set" do
          refute call_method(@object, meth_prefix, :instance_variable_defined?, :@bar)
        end
      end

      describe "#remove_instance_variable" do
        it "returns value of instance variable and unsets it" do
          call_method(@object, meth_prefix, :instance_variable_set, :@bar, :foo)
          assert call_method(@object, meth_prefix, :instance_variable_defined?, :@bar)

          assert_equal :foo, call_method(@object, meth_prefix, :remove_instance_variable, :@bar)
          assert_nil call_method(@object, meth_prefix, :instance_variable_get, :@foo)
          refute call_method(@object, meth_prefix, :instance_variable_defined?, :@foo)
        end
      end

      describe "getting an instance's class" do
        specify "returns the class" do
          assert_equal klass, call_method(@object, meth_prefix, :class)
        end
      end
    end
  end
end
