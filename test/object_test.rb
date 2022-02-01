require "test_helper"

module ObjectBehaviourTests
  def self.included(_)
    describe "Object-like behaviour" do
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
          assert_equal @class, @object.class
        end
      end

      describe "#kind_of?" do
        it "returns true for #{@class}" do
          assert @object.kind_of?(@class)
        end

        it "returns false for non-#{@class}" do
          other_class = @Class.new
          refute @object.kind_of?(other_class)
        end
      end

      describe "#inspect" do
        it "inspects the object" do
          assert_match(/#<#{@class}(:.*)?>/, @object.inspect)
        end
      end

      describe "#to_s" do
        it "returns Stringified version of the object" do
          assert_match(/#<#{@class}(:.*)?>/, @object.to_s)
        end
      end
    end
  end
end

[::Object, ::Toy].each do |ns|
  describe "in the #{ns} namespace" do
    before do
      @Class = ns::Class
      @Module = ns::Module
      @Object = ns::Object
    end

    describe "Object singleton behaviour" do
      specify "#class is Class" do
        assert_equal @Class, @Object.class
      end

      describe "#kind_of?" do
        specify "is a kind of Object" do
          assert_kind_of @Object, @Object
        end

        specify "is a kind of Module" do
          assert_kind_of @Module, @Object
        end

        specify "is a kind of Class" do
          assert_kind_of @Class, @Object
        end
      end
    end

    [ns::Object, ns::Module, ns::Class].each do |singleton|
      describe singleton do
        before do
          @class = singleton
          @object = singleton.new
        end

        include ObjectBehaviourTests
      end
    end
  end
end
