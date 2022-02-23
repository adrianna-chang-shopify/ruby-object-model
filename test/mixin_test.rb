require "test_helper"

class MixinTest
  [::Object, ::Toy].each do |ns|
    describe "in the #{ns} namespace" do
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
      end
    end
  end
end
