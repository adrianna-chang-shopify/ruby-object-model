require "test_helper"
require "toy/object"
require "toy/module"
require "toy/class"

[::Object, ::Toy].each do |ns|
  describe "Object-like behaviour in the #{ns} namespace" do
    [ns::Object, ns::Module, ns::Class].each do |_Object|
      describe _Object do
        before do
          @object = _Object.new
        end

        describe "accessing instance variables" do
          specify "reading and writing with a Symbol name" do
            @object.instance_variable_set(:@foo, :bar)
            assert_equal :bar, @object.instance_variable_get(:@foo)

            @object.instance_variable_set(:@foo, :baz)
            assert_equal :baz, @object.instance_variable_get(:@foo)
          end

          specify "reading and writing with a String name" do
            @object.instance_variable_set("@foo", :bar)
            assert_equal :bar, @object.instance_variable_get("@foo")
          end

          specify "reading with a Symbol and writing with a String name" do
            @object.instance_variable_set("@foo", :bar)
            assert_equal :bar, @object.instance_variable_get(:@foo)
          end

          specify "reading with a String and writing with a Symbol name" do
            @object.instance_variable_set(:@foo, :bar)
            assert_equal :bar, @object.instance_variable_get("@foo")
          end

          specify "reading an unset instance variable returns nil" do
            assert_nil @object.instance_variable_get(:@foo)
          end
        end

        describe "#instance_variables" do
          it "returns the names of existing instance variables" do
            @object.instance_variable_set(:@bar, :foo)
            @object.instance_variable_set(:@baz, :foo)

            assert_equal [:@bar, :@baz], @object.instance_variables
          end
        end

        describe "#instance_variable_defined?" do
          it "returns true if instance variable is set" do
            @object.instance_variable_set(:@bar, :foo)
            assert @object.instance_variable_defined?(:@bar)
          end

          it "returns false if instance variable is not set" do
            refute @object.instance_variable_defined?(:@bar)
          end
        end

        describe "#remove_instance_variable" do
          it "returns value of instance variable and unsets it" do
            @object.instance_variable_set(:@bar, :foo)
            assert @object.instance_variable_defined?(:@bar)

            assert_equal :foo, @object.remove_instance_variable(:@bar)
            assert_nil @object.instance_variable_get(:@foo)
            refute @object.instance_variable_defined?(:@foo)
          end
        end

        describe "getting an instance's class" do
          specify "returns the class" do
            assert_equal _Object, @object.class
          end
        end

        describe "#kind_of?" do
          it "returns true for #{_Object}" do
            assert @object.kind_of?(_Object)
          end

          it "returns false for non-#{_Object}" do
            other_class = ns::Class.new
            refute @object.kind_of?(other_class)
          end
        end

        describe "#inspect" do
          it "inspects the object" do
            assert_match(/#<#{_Object}(:.*)?>/, @object.inspect)
          end
        end

        describe "#to_s" do
          it "returns Stringified version of the object" do
            assert_match(/#<#{_Object}(:.*)?>/, @object.to_s)
          end
        end
      end
    end
  end
end
