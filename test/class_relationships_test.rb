require "test_helper"

[::Object, ::Toy].each do |ns|
  describe "in the #{ns} namespace" do
    before do
      @Class = ns::Class
      @Module = ns::Module
      @Object = ns::Object
    end

    describe "relationships between Object, Module and Class" do
      describe "#class" do
        specify "Object’s class is Class" do
          assert_equal @Class, @Object.class
        end

        specify "Module’s class is Class" do
          assert_equal @Class, @Class.class
        end

        specify "Class’s class is Class" do
          assert_equal @Class, @Class.class
        end
      end

      describe "#superclass" do
        specify "Class’s superclass is Module" do
          assert_equal @Module, @Class.superclass
        end

        specify "Module’s superclass is Object" do
          assert_equal @Object, @Module.superclass
        end
      end

      describe "#kind_of?" do
        describe "Object" do
          specify "Object is a kind of Object" do
            assert_kind_of @Object, @Object
          end

          specify "Object is a kind of Module" do
            assert_kind_of @Module, @Object
          end

          specify "Object is a kind of Class" do
            assert_kind_of @Class, @Object
          end
        end

        describe "Module" do
          specify "Module is a kind of Object" do
            assert_kind_of @Object, @Module
          end

          specify "Module is a kind of Module" do
            assert_kind_of @Module, @Module
          end

          specify "Module is a kind of Class" do
            assert_kind_of @Class, @Module
          end
        end

        describe "Class" do
          specify "Class is a kind of Object" do
            assert_kind_of @Object, @Class
          end

          specify "Class is a kind of Module" do
            assert_kind_of @Module, @Class
          end

          specify "Class is a kind of Class" do
            assert_kind_of @Class, @Class
          end
        end
      end
    end
  end
end
