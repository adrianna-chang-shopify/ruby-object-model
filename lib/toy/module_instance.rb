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

    def instance_method(selector)
      selector = selector.to_sym

      current_class = self
      while current_class
        # Check mixed-in modules to see if they define the selector
        method = mixin_ancestry_search(current_class, selector)
        return method if method

        # The current class did not define the method, nor did any of its mixins.
        # Move up to the superclass to see if it, or any of its modules, contain the method.
        current_class = current_class.superclass
      end
      ::Kernel.raise ::NameError, "undefined method `#{selector}' for class `#{self.inspect}'"
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

    def mixin_ancestry_search(mixin, selector)
      return Method.new(mixin) if mixin.instance_methods.include?(selector)

      mixin.included_modules.each do |nested_mixin|
        method = mixin_ancestry_search(nested_mixin, selector)
        return method if method
      end

      # No method match was found at this level in the tree, return nil
      nil
    end
  end
end
