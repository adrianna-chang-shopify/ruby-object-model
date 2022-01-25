require "test_helper"

module ClassBehaviourTests
  def self.included(_)
    describe "Class-like behaviour" do
      describe "initializing an object" do
        before do
          @object = @class.new
        end

        specify "creates an instance of the class" do
          # Ask the instance what its class is; it should be the anonymous
          # Class stored in @class
          assert_equal @class, @object.class
        end

        describe "acts like an object" do
          describe "accessing instance variables" do
            specify "reading and writing" do
              @object.instance_variable_set(:@foo, :bar)
              assert_equal :bar, @object.instance_variable_get(:@foo)

              @object.instance_variable_set(:@foo, :baz)
              assert_equal :baz, @object.instance_variable_get(:@foo)
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
        end
      end

      describe "getting a class's superclass" do
        specify "returns the superclass" do
          assert_equal @superclass, @class.superclass
        end

        specify "works with custom superclass" do
          subclass = @Class.new(@class)
          assert_equal @class, subclass.superclass
        end
      end
    end
  end
end

[::Object, ::Toy].each do |ns|
  describe "in the #{ns} namespace" do
    [[ns::Class, ns::Object]].each do |singleton, _Object|
      describe singleton do
        before do
          @Class = ns::Class
          @superclass = _Object
          @class = singleton.new
        end

        include ClassBehaviourTests
      end
    end
  end
end
