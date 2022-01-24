require "test_helper"

[::Object, ::Toy].each do |ns|
  describe "Module-like behaviour in the #{ns} namespace" do
    [ns::Module, ns::Class].each do |_Module|
      describe _Module do
        before do
          @class = _Module
          @module = _Module.new
        end

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
      end
    end
  end
end
