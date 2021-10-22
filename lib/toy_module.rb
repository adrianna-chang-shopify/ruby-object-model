require "toy_object"

class ToyModule < ToyObject
  def initialize
    @constant_map = {}
    @method_map = {}
  end

  def toy_const_get(name)
    name = name.to_sym
    raise NameError, "uninitialized constant #{name} for #{inspect}" unless constant_map.key?(name)

    constant_map[name]
  end

  def toy_const_set(name, value)
    name = name.to_sym
    raise NameError unless name.match?(/^[A-Z][a-zA-Z_]*$/)

    warn "already initialized constant #{name}" if constant_map.key?(name)

    constant_map[name] = value
  end

  def toy_constants
    constant_map.keys.map(&:to_sym)
  end

  def toy_define_method(name, method)
    name = name.to_sym
    method_map[name] = method
  end

  def toy_instance_methods
    method_map.keys.map(&:to_sym)
  end

  private

  attr_accessor :constant_map, :method_map
end
