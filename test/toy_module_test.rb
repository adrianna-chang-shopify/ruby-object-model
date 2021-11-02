require 'test_helper'
require 'toy_class'
require 'toy_module'

[Module, ToyModule, Class, ToyClass].each do |klass|
  describe klass do
    include TestHelpers

    before do
      @new_method = klass <= ToyModule ? "toy_new" : "new"
      @module = klass.public_send(@new_method)
    end

    describe 'accessing constants' do
      specify 'reading and writing with a Symbol name' do
        call_method(@module, :const_set, :FOO, 42)

        assert_equal(42, call_method(@module, :const_get, :FOO))
      end

      specify 'reading and writing with a String name' do
        call_method(@module, :const_set, 'FOO', 42)

        assert_equal(42, call_method(@module, :const_get, 'FOO'))
      end

      specify "raises NameError if constant name doesn't start with capital letter" do
        assert_raises NameError do
          call_method(@module, :const_set, 'foobar', 42)
        end
      end

      specify 'raises NameError if name starts with non-alphabetic character' do
        assert_raises NameError do
          call_method(@module, :const_set, '_foobar', 42)
        end
      end

      specify 'raises NameError if constant name contains non-alphabetic character other than underscore' do
        assert_raises NameError do
          call_method(@module, :const_set, 'FOO!BAR', 42)
        end

        call_method(@module, :const_set, 'FOO_BAR', 42)
      end

      specify 'raises uninitialized constant NameError if unset constant is accessed' do
        error = assert_raises NameError do
          call_method(@module, :const_get, 'FOO')
        end
        assert_match(/uninitialized constant/, error.message)
      end

      specify 'warns when setting a constant that is already set' do
        call_method(@module, :const_set, 'FOO', 42)

        _, err = capture_io do
          call_method(@module, :const_set, 'FOO', 42)
        end

        assert_match(/already initialized constant/, err)
      end
    end

    describe '#constants' do
      it 'returns list of constant names coerced to symbols' do
        call_method(@module, :const_set, :FOO, 42)
        call_method(@module, :const_set, 'BAR', 51)

        assert_equal %i[BAR FOO], call_method(@module, :constants).sort
      end
    end

    describe '#define_method when passed a proc' do
      it 'defines instance method on receiver with proc as body' do
        body = proc { puts 'Hello World!' }
        call_method(@module, :define_method, :my_method, body)

        assert_includes call_method(@module, :instance_methods), :my_method
      end

      it 'defines instance method with parameters' do
        skip
      end
    end
  end
end
