module Toy
  class ModuleInstance < ObjectInstance
    # Module and class instances can have names, object instances can't
    def inspect
      return super unless name
      name
    end

    def name
      nil
    end

    def const_get(name)
      name = name.to_sym
      ::Kernel.raise ::NameError, "uninitialized constant #{inspect}::#{name}" unless constant_map.key?(name)

      constant_map[name]
    end

    def const_set(name, value)
      name = name.to_sym
      ::Kernel.raise ::NameError unless name.match?(/^[A-Z][a-zA-Z_]*$/)

      ::Kernel.warn "already initialized constant #{inspect}::#{name}" if constant_map.key?(name)

      constant_map[name] = value
    end

    def constants
      constant_map.keys.map(&:to_sym)
    end

    def define_method(name, method)
      name = name.to_sym
      method_map[name] = method
    end

    def instance_methods
      method_map.keys.map(&:to_sym)
    end

    def include(mod)
      included_modules.prepend(mod) unless included_modules.include?(mod)
    end

    def included_modules
      @included_modules ||= []
    end

    private

    def constant_map
      @constant_map ||= {}
    end

    def method_map
      @method_map ||= {}
    end
  end
end
