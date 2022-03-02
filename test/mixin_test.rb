require "test_helper"

class MixinTest
  [::Object, ::Toy].each do |ns|
    describe "in the #{ns} namespace" do
      describe "#included_modules" do
        it "returns list of modules that have been mixed into module" do
          m = ns::Module.new
          c = ns::Class.new
          c.include(m)

          assert_includes(c.included_modules, m)
        end
      end

      describe "including a module in a module" do
        # TO DO - ensure we test this behaviour against Module
      end

      describe "including a module in a class" do
        specify "define module with method, include module in new class, instantiate class" do
          m = ns::Module.new
          m.define_method(:my_method, proc { puts "Hello World!" })

          c = ns::Class.new
          c.include(m)

          o = c.new

          assert_equal(m, o.method(:my_method).owner)
        end

        specify "instantiate new class, include module, define method on module" do
          c = ns::Class.new
          o = c.new

          m = ns::Module.new
          c.include(m)

          m.define_method(:my_method, proc { puts "Hello World!" })
          assert_equal(m, o.method(:my_method).owner)
        end

        specify "mixes in behaviour to a subclass" do
          m = ns::Module.new
          m.define_method(:my_method, proc { puts "Hello World!" })

          c = ns::Class.new
          c.include(m)

          subclass = ns::Class.new(c)

          o = subclass.new

          assert_equal(m, o.method(:my_method).owner)
        end

        specify "when a class overrides a mixin's method, knows the class defined it" do
          m = ns::Module.new
          m.define_method(:my_method, proc { puts "Hello World!" })

          c = ns::Class.new
          c.include(m)
          c.define_method(:my_method, proc { puts "I override my mixin's method!" })

          o = c.new

          assert_equal(c, o.method(:my_method).owner)
        end
      end
    end
  end
end
