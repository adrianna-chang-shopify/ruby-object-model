require 'class_relationships'
require 'test_helper'

[
  [Object, Module, Class],
  [ToyObject, ToyModule, ToyClass, 'toy_']
].each do |_Object, _Module, _Class, prefix|
  describe 'relationships between Object, Module and Class' do
    include TestHelpers

    describe '#class' do
      specify 'Object’s class is Class' do
        assert_equal _Class, call_method(_Object, prefix, :class)
      end

      specify 'Module’s class is Class' do
        assert_equal _Class, call_method(_Module, prefix, :class)
      end

      specify 'Class’s class is Class' do
        assert_equal _Class, call_method(_Class, prefix, :class)
      end
    end

    describe '#superclass' do
      specify 'Class’s superclass is Module' do
        assert_equal _Module, call_method(_Class, prefix, :superclass)
      end

      specify 'Module’s superclass is Object' do
        assert_equal _Object, call_method(_Module, prefix, :superclass)
      end
    end

    describe '#kind_of?' do
      describe 'Object' do
        specify 'Object is a kind of Object' do
          assert call_method(_Object, prefix, :kind_of?, _Object)
        end

        specify 'Object is a kind of Module' do
          assert call_method(_Object, prefix, :kind_of?, _Module)
        end

        specify 'Object is a kind of Class' do
          assert call_method(_Object, prefix, :kind_of?, _Class)
        end
      end

      describe 'Module' do
        specify 'Module is a kind of Object' do
          assert call_method(_Module, prefix, :kind_of?, _Object)
        end

        specify 'Module is a kind of Module' do
          assert call_method(_Module, prefix, :kind_of?, _Module)
        end

        specify 'Module is a kind of Class' do
          assert call_method(_Module, prefix, :kind_of?, _Class)
        end
      end

      describe 'Class' do
        specify 'Class is a kind of Object' do
          assert call_method(_Class, prefix, :kind_of?, _Object)
        end

        specify 'Class is a kind of Module' do
          assert call_method(_Class, prefix, :kind_of?, _Module)
        end

        specify 'Class is a kind of Class' do
          assert call_method(_Class, prefix, :kind_of?, _Class)
        end
      end
    end
  end
end
