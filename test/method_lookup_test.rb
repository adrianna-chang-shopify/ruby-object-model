require "test_helper"

class MethodLookupTest
  [::Object, ::Toy].each do |ns|
    describe "in the #{ns} namespace" do
      before do
        @Class = ns::Class
        @class = @Class.new
      end

      describe "method lookup behaviour" do
        specify "#method raises NameError when object doesn't define selector method" do
          object = @class.new
          error = assert_raises(NameError) do
            object.method(:unknown_method)
          end
          assert_match(/undefined method `unknown_method'/, error.message)
        end

        describe "the object returned by #method" do
          before do
            body = proc { puts "Hello World!" }
            @class.define_method(:my_method, body)
          end

          specify "knows the module or class that defined the method" do
            object = @class.new
            assert_equal(@class, object.method(:my_method).owner)
          end

          specify "knows when a superclass defined the method" do
            subclass = @Class.new(@class)

            object = subclass.new
            assert_equal(@class, object.method(:my_method).owner)
          end

          specify "when a subclass overrides a superclass's method, knows the subclass defined it" do
            subclass = @Class.new(@class)
            body = proc { puts "I override my parent's method!" }
            subclass.define_method(:my_method, body)

            object = subclass.new
            assert_equal(subclass, object.method(:my_method).owner)
          end
        end
      end
    end
  end
end
