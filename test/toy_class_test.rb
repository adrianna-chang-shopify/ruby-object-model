require 'test_helper'
require 'toy_class'
require 'toy_object'

[[Class, Object], [ToyClass, ToyObject, "toy_"]].each do |klass, object_klass, meth_prefix|
  describe klass do
    include TestHelpers

    before do
      @new_method = klass == ToyClass ? "toy_new" : "new"
      @class = klass.public_send(@new_method)
    end

    describe 'initializing an object' do
      specify 'creates a ToyObject instance' do
        assert_kind_of object_klass, call_method(@class, meth_prefix, :new)
      end
    end

    describe "getting a class's superclass" do
      specify 'returns the superclass' do
        subclass = klass.public_send(@new_method, @class)
        assert_equal @class, call_method(subclass, meth_prefix, :superclass)
      end

      specify 'uses the correct default superclass' do
        assert_equal object_klass, call_method(@class, meth_prefix, :superclass)
      end
    end
  end
end
