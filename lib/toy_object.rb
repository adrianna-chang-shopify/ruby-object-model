class ToyObject
  def initialize(toy_class = nil)
    @toy_class = toy_class
  end

  def toy_instance_variable_get(name)
    ivar_map[name.to_sym]
  end

  def toy_instance_variable_set(name, value)
    ivar_map[name.to_sym] = value
  end

  def toy_instance_variables
    ivar_map.keys
  end

  def toy_instance_variable_defined?(name)
    ivar_map.has_key?(name.to_sym)
  end

  def toy_remove_instance_variable(name)
    ivar_map.delete(name.to_sym)
  end

  def toy_class
    @toy_class
  end

  private

  def ivar_map
    @ivar_map ||= {}
  end
end
