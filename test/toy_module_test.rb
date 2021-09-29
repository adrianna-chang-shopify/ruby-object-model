require "test_helper"
require "toy_module"

[Module, ToyModule].each do |klass|

  describe klass do
    before do
      @module = klass.new
    end

    describe "accessing constants" do
      specify "reading and writing with a Symbol name" do
        call_method(:const_set, :FOO, 42)

        assert_equal(42, call_method(:const_get, :FOO))
      end

      specify "reading and writing with a String name" do
        call_method(:const_set, "FOO", 42)

        assert_equal(42, call_method(:const_get, "FOO"))
      end

      specify "raises NameError if constant name doesn't start with capital letter" do
        assert_raises NameError do
          call_method(:const_set, "foobar", 42)
        end
      end

      specify "raises NameError if name starts with non-alphabetic character" do
        assert_raises NameError do
          call_method(:const_set, "_foobar", 42)
        end
      end

      specify "raises NameError if constant name contains non-alphabetic character other than underscore" do
        assert_raises NameError do
          call_method(:const_set, "FOO!BAR", 42)
        end

        call_method(:const_set, "FOO_BAR", 42)
      end

      specify "raises uninitialized constant NameError if unset constant is accessed" do
        error = assert_raises NameError do
          call_method(:const_get, "FOO")
        end
        assert_match(/uninitialized constant/, error.message)
      end

      specify "warns when setting a constant that is already set" do
        call_method(:const_set, "FOO", 42)

        _, err = capture_io do
          call_method(:const_set, "FOO", 42)
        end

        assert_match(/already initialized constant/, err)
      end
    end

    describe "#constants" do
      it "returns alphabetized list of constant names coerced to symbols" do
        call_method(:const_set, :FOO, 42)
        call_method(:const_set, "BAR", 51)
  
        assert_equal [:BAR, :FOO], call_method(:constants)
      end
    end

    private

    def call_method(name, *args)
      name = @module.is_a?(ToyModule) ? "toy_#{name}" : name
      @module.public_send(name, *args)
    end
  end
end
