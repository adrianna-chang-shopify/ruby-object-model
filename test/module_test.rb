require "test_helper"

module ModuleBehaviourTests
  def self.included(_)
    describe "Module-like behaviour" do
      describe "accessing constants" do
        specify "reading and writing with a Symbol name" do
          @module.const_set(:FOO, 42)

          assert_equal(42, @module.const_get(:FOO))
        end

        specify "reading and writing with a String name" do
          @module.const_set("FOO", 42)

          assert_equal(42, @module.const_get("FOO"))
        end

        specify "raises NameError if constant name doesn't start with capital letter" do
          assert_raises NameError do
            @module.const_set("foobar", 42)
          end
        end

        specify "raises NameError if name starts with non-alphabetic character" do
          assert_raises NameError do
            @module.const_set("_foobar", 42)
          end
        end

        specify "raises NameError if constant name contains non-alphabetic character other than underscore" do
          assert_raises NameError do
            @module.const_set("FOO!BAR", 42)
          end

          @module.const_set("FOO_BAR", 42)
        end

        specify "raises uninitialized constant NameError if unset constant is accessed" do
          error = assert_raises NameError do
            @module.const_get("FOO")
          end
          assert_match(/uninitialized constant #<#{@class}(:.*)?>::FOO/, error.message)
        end

        specify "warns when setting a constant that is already set" do
          @module.const_set("FOO", 42)

          _, err = capture_io do
            @module.const_set("FOO", 42)
          end

          assert_match(/already initialized constant #<#{@class}(:.*)?>::FOO/, err)
        end
      end

      describe "#constants" do
        it "returns list of constant names coerced to symbols" do
          @module.const_set(:FOO, 42)
          @module.const_set("BAR", 51)

          assert_equal %i[BAR FOO], @module.constants.sort
        end
      end

      describe "#define_method when passed a proc" do
        it "defines instance method on receiver with proc as body" do
          body = proc { puts "Hello World!" }
          @module.define_method(:my_method, body)

          assert_includes @module.instance_methods, :my_method
        end
      end

      describe "#instance_method" do
        it "returns a method defined on the module" do
          body = proc { puts "Hello World!" }
          @module.define_method(:my_method, body)

          assert @module.instance_method(:my_method)
        end

        it "returns a method defined on a class's superclass" do
          klass = @Class.new
          body = proc { puts "Hello World!" }
          klass.define_method(:my_method, body)

          subclass = @Class.new(klass)
          assert subclass.instance_method(:my_method)
        end

        it "returns a method mixed-in to the current module" do
          body = proc { puts "Hello World!" }
          mixin = @Module.new
          mixin.define_method(:my_method, body)

          klass = @Class.new
          klass.include(mixin)

          assert klass.instance_method(:my_method)
        end

        it "raises if method cannot be found" do
          error = assert_raises(NameError) do
            @module.instance_method(:unknown_method)
          end
          assert_match(/undefined method `unknown_method'/, error.message)
        end

        # class A
        #   def some_method; end
        # end

        # module B; end

        # class C < A
        #   include B
        # end

        # C.instance_method(:some_method)

        it "returns a method when class inheritance is combined with mixins" do
          class_a = @Class.new
          class_a.define_method(:my_method, proc { puts "Hello World!" })

          module_b = @Module.new

          class_c = @Class.new(class_a)
          class_c.include(module_b)

          assert class_c.instance_method(:my_method)
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

    describe "Module singleton behaviour" do
      specify "#class is Class" do
        assert_equal @Class, @Module.class
      end

      specify "#superclass is Object" do
        assert_equal @Object, @Module.superclass
      end

      describe "#kind_of?" do
        specify "is a kind of Object" do
          assert_kind_of @Object, @Module
        end

        specify "is a kind of Module" do
          assert_kind_of @Module, @Module
        end

        specify "is a kind of Class" do
          assert_kind_of @Class, @Module
        end
      end
    end

    [ns::Module, ns::Class].each do |singleton|
      describe singleton do
        before do
          @class = singleton
          @module = singleton.new
          @Class = ns::Class
          @Module = ns::Module
        end

        include ModuleBehaviourTests
      end
    end
  end
end
