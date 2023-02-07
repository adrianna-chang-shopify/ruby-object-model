require "test_helper"

class MethodLookupTest
  [::Object, ::Toy].each do |ns|
    describe "in the #{ns} namespace" do
      before do
        @Class = ns::Class
        @class = @Class.new
      end

      # class Z; end

      # class Y < Z
      #   include A
      # end

      # module A
      #   include B
      # end

      # module B
      #   include C
      #   include D
      # end

      # module C
      #   include D
      # end

      # module D; end

      describe "#ancestors" do
        it "returns list of ancestors" do
          module_a = ns::Module.new
          module_b = ns::Module.new
          module_c = ns::Module.new
          module_d = ns::Module.new

          module_a.include(module_b)
          module_b.include(module_c)

          module_b.include(module_d)
          module_c.include(module_d)

          class_z = @Class.new
          class_z.include(module_a)

          expected_ancestors = [class_z, module_a, module_b, module_d, module_c, ns::Object]
          assert_equal expected_ancestors, class_z.ancestors.take(expected_ancestors.length)
        end

        # module A; end

        # class Z
        #   include A
        # end

        # class Y < Z
        #   include A
        # end

        it "dedups ancestor list for classes" do
          module_a = ns::Module.new
          def module_a.name; "module_a"; end

          class_y = @Class.new
          def class_y.name; "class_y"; end

          class_z = @Class.new(class_y)
          def class_z.name; "class_z"; end

          class_y.include(module_a)
          class_z.include(module_a)

          expected_ancestors = [class_z, class_y, module_a, ns::Object]
          assert_equal expected_ancestors, class_z.ancestors.take(expected_ancestors.length)
        end

        it "dedups ancestor list for classes, ordering matters" do
          # Demonstrate that order matters here
          module_a = ns::Module.new

          class_y = @Class.new
          class_z = @Class.new(class_y)

          class_z.include(module_a)
          class_y.include(module_a)

          expected_ancestors = [class_z, module_a, class_y, module_a, ns::Object]
          assert_equal expected_ancestors, class_z.ancestors.take(expected_ancestors.length)
        end
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
