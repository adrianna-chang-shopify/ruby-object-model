require "test_helper"
require "toy_object"

describe ToyObject do
  before do
    @toy_object = ToyObject.new
  end

  describe "accessing instance variables" do
    specify "reading and writing with a Symbol name" do
      @toy_object.toy_instance_variable_set(:@foo, :bar)
      assert_equal :bar, @toy_object.toy_instance_variable_get(:@foo)
  
      @toy_object.toy_instance_variable_set(:@foo, :baz)
      assert_equal :baz, @toy_object.toy_instance_variable_get(:@foo)
    end

    specify "reading and writing with a String name" do
      @toy_object.toy_instance_variable_set("@foo", :bar)
      assert_equal :bar, @toy_object.toy_instance_variable_get("@foo")
    end

    specify "reading with a Symbol and writing with a String name" do
      @toy_object.toy_instance_variable_set("@foo", :bar)
      assert_equal :bar, @toy_object.toy_instance_variable_get(:@foo)
    end

    specify "reading with a String and writing with a Symbol name" do
      @toy_object.toy_instance_variable_set(:@foo, :bar)
      assert_equal :bar, @toy_object.toy_instance_variable_get("@foo")
    end

    specify "reading an unset instance variable returns nil" do
      assert_nil @toy_object.toy_instance_variable_get(:@foo)
    end
  end

  describe "#toy_instance_variables" do
    it "returns the names of existing instance variables" do
      @toy_object.toy_instance_variable_set(:@bar, :foo)
      @toy_object.toy_instance_variable_set(:@baz, :foo)
  
      assert_equal [:@bar, :@baz], @toy_object.toy_instance_variables
    end
  end

  describe "#toy_instance_variable_defined?" do
    it "returns true if instance variable is set" do
      @toy_object.toy_instance_variable_set(:@bar, :foo)
      assert @toy_object.toy_instance_variable_defined?(:@bar)
    end

    it "returns false if instance variable is not set" do
      refute @toy_object.toy_instance_variable_defined?(:@bar)
    end
  end

  describe "#toy_remove_instance_variable" do
    it "returns value of instance variable and unsets it" do
      @toy_object.toy_instance_variable_set(:@bar, :foo)
      assert @toy_object.toy_instance_variable_defined?(:@bar)
  
      assert_equal :foo, @toy_object.toy_remove_instance_variable(:@bar)
      assert_nil @toy_object.toy_instance_variable_get(:@foo)
      refute @toy_object.toy_instance_variable_defined?(:@foo)
    end
  end
end
