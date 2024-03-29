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
        it "adds the mixin to the module's included_modules" do
          module_a = ns::Module.new
          module_a.define_method(:my_method, proc { puts "Hello World!" })

          module_b = ns::Module.new
          module_b.include(module_a)

          assert_includes(module_b.included_modules, module_a)
        end

        it "adds module to list of included modules even if another mixin already includes that module" do
          module_a = ns::Module.new
          def module_a.name; "module_a"; end

          module_b = ns::Module.new
          def module_b.name; "module_b"; end

          module_c = ns::Module.new
          def module_c.name; "module_c"; end

          module_b.include(module_c)

          module_a.include(module_b)
          module_a.include(module_c)

          assert_equal([module_b, module_c], module_a.included_modules)
          assert_equal([module_a, module_b, module_c], module_a.ancestors)
        end
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

        describe "when a class includes multiple modules that define a method" do
          it "uses the behaviour defined in the most recently included module" do
            module_a = ns::Module.new
            module_a.define_method(:my_method, proc { "Called from module A" })
            module_b = ns::Module.new
            module_b.define_method(:my_method, proc { "Called from module B" })

            c = ns::Class.new
            c.include(module_a)
            c.include(module_b)

            o = c.new

            assert_equal(module_b, o.method(:my_method).owner)
          end
        end

        describe "including the same module twice" do
          it "only adds module to list of included_modules once" do
            m = ns::Module.new
            m.define_method(:my_method, proc { "Hello world!" })

            c = ns::Class.new
            c.include(m)
            c.include(m)

            assert_equal(1, c.included_modules.select { |mod| mod == m }.size)
          end

          it "doesn't affect method lookup" do
            module_a = ns::Module.new
            module_a.define_method(:my_method, proc { "Called from module A" })
            module_b = ns::Module.new
            module_b.define_method(:my_method, proc { "Called from module B" })

            c = ns::Class.new
            c.include(module_a)
            c.include(module_b)
            c.include(module_a)

            o = c.new

            assert_equal(module_b, o.method(:my_method).owner)
          end
        end

        describe "including a module that includes other modules" do
          it "defines behaviour from transitively included modules in class" do
            module_a = ns::Module.new
            module_b = ns::Module.new
            module_b.define_method(:my_method, proc { "Called from module B" })

            module_a.include(module_b)

            c = ns::Class.new
            c.include(module_a)

            o = c.new

            assert_equal(module_b, o.method(:my_method).owner)
          end

          it "handles many levels of module inclusion" do
            module_a = ns::Module.new
            module_b = ns::Module.new
            module_c = ns::Module.new
            module_c.define_method(:my_method, proc { "Called from module C" })

            module_b.include(module_c)
            module_a.include(module_b)

            c = ns::Class.new
            c.include(module_a)

            o = c.new

            assert_equal(module_c, o.method(:my_method).owner)
          end

          specify "include order is not important" do
            module_a = ns::Module.new
            module_b = ns::Module.new
            module_c = ns::Module.new
            module_c.define_method(:my_method, proc { "Called from module C" })

            module_a.include(module_b)
            module_b.include(module_c)

            c = ns::Class.new
            c.include(module_a)

            o = c.new

            assert_equal(module_c, o.method(:my_method).owner)
          end

          # FOR NEXT TEST CASE
          #
          # module A
          #   include B
          # end

          # module B
          #   include C
          # end

          # module C
          #   def my_method; end
          # end

          # module D
          #   include E
          # end

          # module E
          #   def my_method; end
          # end

          # class Foo
          #   include A
          #   include D
          # end

          specify "include order matters when there are method conflicts in mixins" do
            module_a = ns::Module.new
            module_b = ns::Module.new
            module_c = ns::Module.new
            module_c.define_method(:my_method, proc { "Called from module C" })

            module_d = ns::Module.new
            module_e = ns::Module.new
            module_e.define_method(:my_method, proc { "Called from module E" })

            module_a.include(module_b)
            module_b.include(module_c)

            module_d.include(module_e)

            c = ns::Class.new
            c.include(module_d)
            c.include(module_a)

            o = c.new

            # owner is module_c since its "root module" (module A)
            # was included last on the class. This is the case even though
            # module C is at a "deeper level" in the tree compared to module E.
            # DFS
            assert_equal(module_c, o.method(:my_method).owner)
          end
        end

        describe "including a module in a class and its superclass" do
          it "resolves method to module if the class includes the mixin first" do
            module_a = ns::Module.new
            module_a.define_method(:my_method, proc { "Called from module A" })

            class_y = ns::Class.new
            class_y.define_method(:my_method, proc { "Called from class Y" })

            class_z = ns::Class.new(class_y)

            # Because class_z includes the module first, lookup will find
            # #my_method on the module
            class_z.include(module_a)
            class_y.include(module_a)

            o = class_z.new
            assert_equal(module_a, o.method(:my_method).owner)
          end

          it "ignores the mixin included on the class if the superclass includes mixin first" do
            module_a = ns::Module.new
            module_a.define_method(:my_method, proc { "Called from module A" })
            def module_a.name; "module_a"; end

            class_y = ns::Class.new
            class_y.define_method(:my_method, proc { "Called from class Y" })
            def class_y.name; "class_y"; end

            class_z = ns::Class.new(class_y)
            def class_z.name; "class_z"; end

            # Because class_y includes the mixin first, when class_z includes
            # the mixin it's effectively a no-op because that module already
            # appears in the ancestry chain, and consequently the method
            # lookup finds #my_method on class_y
            class_y.include(module_a)
            class_z.include(module_a)

            o = class_z.new
            expected_ancestors = [class_z, class_y, module_a, ns::Object]
            assert_equal(expected_ancestors, class_z.ancestors.take(expected_ancestors.length))
            assert_equal(class_y, o.method(:my_method).owner)
          end

          # Note: we could have another test case where the order is switched
          # and then the module would show up twice!
          # class_z.include(module_a)
          # class_y.include(module_a)

          # class_z.ancestors => [class_z, module_a, class_y, module_a]
        end
      end
    end
  end
end
