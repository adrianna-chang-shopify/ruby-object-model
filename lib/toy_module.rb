class ToyModule
  def initialize
    @constant_map = {}
  end

  def toy_const_get(name)
    name = name.to_sym
    raise NameError, "uninitialized constant #{name} for #{self.inspect}" unless constant_map.key?(name)

    constant_map[name]
  end

  def toy_const_set(name, value)
    name = name.to_sym
    raise NameError unless name.match?(/^[A-Z][a-zA-Z_]*$/)
    warn "already initialized constant #{name}" if constant_map.key?(name)

    constant_map[name] = value
  end

  def toy_constants
    constant_map.keys.map(&:to_sym).sort
  end

  private

  attr_accessor :constant_map
end
