require 'test_helper'
require 'toy_class'
require 'toy_object'

[[Class, Object], [ToyClass, ToyObject]].each do |klass, object_klass|
  describe klass do
    before do
      @new_method = klass == ToyClass ? "toy_new" : "new"
      @class = klass.public_send(@new_method)
    end

    describe 'initializing an object' do
      specify 'creates a ToyObject instance' do
        assert_kind_of object_klass, call_method(:new)
      end
    end

    describe "getting a class's superclass" do
      specify 'returns the superclass' do
        assert_equal object_klass, call_method(:superclass)
      end
    end

    def call_method(name, *args)
      name = @class.is_a?(ToyClass) ? "toy_#{name}" : name
      @class.public_send(name, *args)
    end
  end
end
