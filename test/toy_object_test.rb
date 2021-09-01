require_relative "../toy_object"

require "minitest/autorun"

describe ToyObject do
  before do
    @toy_object = ToyObject.new
  end

  it "can get and set an instance variable with symbol" do
    @toy_object.toy_instance_variable_set(:@foo, :bar)
    assert_equal :bar, @toy_object.toy_instance_variable_get(:@foo)

    @toy_object.toy_instance_variable_set(:@foo, :baz)
    assert_equal :baz, @toy_object.toy_instance_variable_get(:@foo)
  end

  it "can get and set an instance variable with string" do
    @toy_object.toy_instance_variable_set("@foo", :bar)
    assert_equal :bar, @toy_object.toy_instance_variable_get("@foo")
  end

  it "can set an instance variable with string and get with symbol" do
    @toy_object.toy_instance_variable_set("@foo", :bar)
    assert_equal :bar, @toy_object.toy_instance_variable_get(:@foo)
  end

  it "can set an instance variable with symbol and get with string" do
    @toy_object.toy_instance_variable_set(:@foo, :bar)
    assert_equal :bar, @toy_object.toy_instance_variable_get("@foo")
  end

  it "get returns nil if an instance variable has not yet been set" do
    assert_nil @toy_object.toy_instance_variable_get(:@foo)
  end

  it "#toy_instance_variables returns the names of set instance variables" do
    @toy_object.toy_instance_variable_set(:@bar, :foo)
    @toy_object.toy_instance_variable_set(:@baz, :foo)

    assert_equal [:@bar, :@baz], @toy_object.toy_instance_variables
  end

  it "#toy_instance_variable_defined? returns true if instance variable is set" do
    @toy_object.toy_instance_variable_set(:@bar, :foo)
    assert @toy_object.toy_instance_variable_defined?(:@bar)
  end

  it "#toy_instance_variable_defined? returns false if instance variable is not set" do
    refute @toy_object.toy_instance_variable_defined?(:@bar)
  end

  it "#toy_remove_instance_variable returns value and unsets instance variable" do
    @toy_object.toy_instance_variable_set(:@bar, :foo)
    assert @toy_object.toy_instance_variable_defined?(:@bar)

    assert_equal :foo, @toy_object.toy_remove_instance_variable(:@bar)
    assert_nil @toy_object.toy_instance_variable_get(:@foo)
    refute @toy_object.toy_instance_variable_defined?(:@foo)
  end
end
