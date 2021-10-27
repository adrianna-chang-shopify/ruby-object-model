require 'test_helper'
require 'toy_class'
require 'toy_object'

[[Class, Object], [ToyClass, ToyObject]].each do |klass, object_klass|
  describe klass do
    before do
      @class = klass.new
    end

    describe 'initializing an object' do
      specify 'creates a ToyObject instance' do
        assert_kind_of object_klass, call_method(:new)
      end
    end

    describe "getting a class's superclass" do
      specify 'returns the superclass' do
        class_a = klass.new
        @class = klass.new(class_a)

        assert_equal class_a, call_method(:superclass)
      end

      specify 'uses the correct default superclass' do
        assert_equal object_klass, call_method(:superclass)
      end
    end

    def call_method(name, *args)
      name = @class.is_a?(ToyClass) ? "toy_#{name}" : name
      @class.public_send(name, *args)
    end
  end
end
