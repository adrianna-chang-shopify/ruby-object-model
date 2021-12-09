require "toy/class"
require "toy/module"
require "toy/object"
require "test_helper"

[
  [::Object, ::Module, ::Class],
  [ToyObject, ToyModule, ToyClass]
].each do |_Object, _Module, _Class|
  describe "relationships between Object, Module and Class" do
    describe "#class" do
      specify "Object’s class is Class" do
        assert_equal _Class, _Object.class
      end

      specify "Module’s class is Class" do
        assert_equal _Class, _Module.class
      end

      specify "Class’s class is Class" do
        assert_equal _Class, _Class.class
      end
    end

    describe "#superclass" do
      specify "Class’s superclass is Module" do
        assert_equal _Module, _Class.superclass
      end

      specify "Module’s superclass is Object" do
        assert_equal _Object, _Module.superclass
      end
    end

    describe "#kind_of?" do
      describe "Object" do
        specify "Object is a kind of Object" do
          assert_kind_of _Object, _Object
        end

        specify "Object is a kind of Module" do
          assert_kind_of _Module, _Object
        end

        specify "Object is a kind of Class" do
          assert_kind_of _Class, _Object
        end
      end

      describe "Module" do
        specify "Module is a kind of Object" do
          assert_kind_of _Object, _Module
        end

        specify "Module is a kind of Module" do
          assert_kind_of _Module, _Module
        end

        specify "Module is a kind of Class" do
          assert_kind_of _Class, _Module
        end
      end

      describe "Class" do
        specify "Class is a kind of Object" do
          assert_kind_of _Object, _Class
        end

        specify "Class is a kind of Module" do
          assert_kind_of _Module, _Class
        end

        specify "Class is a kind of Class" do
          assert_kind_of _Class, _Class
        end
      end
    end
  end
end
