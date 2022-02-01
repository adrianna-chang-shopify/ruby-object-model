require "test_helper"

[::Object, ::Toy].each do |ns|
  describe "in the #{ns} namespace" do
    before do
      @Class = ns::Class
      @Module = ns::Module
      @Object = ns::Object
    end

    describe "relationships between Object, Module and Class" do
    end
  end
end
