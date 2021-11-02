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
        assert_kind_of object_klass, call_method(@class, :new)
      end
    end

    describe "getting a class's superclass" do
      specify 'returns the superclass' do
        subclass = klass.public_send(@new_method, @class)
        assert_equal @class, call_method(subclass, :superclass)
      end

      specify 'uses the correct default superclass' do
        assert_equal object_klass, call_method(@class, :superclass)
      end
    end

    def call_method(receiver, name, *args)
      name = receiver.class.name.start_with?("Toy") ? "toy_#{name}" : name
      receiver.public_send(name, *args)
    end
  end
end
