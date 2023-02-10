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

    def ancestors
      [self] + traverse_ancestors
    end

    def instance_method(selector)
      return Method.new(self) if instance_methods.include?(selector)

      traverse_ancestors.each do |nested_module|
        method = nested_module.instance_method(selector)
        return method if method
      rescue ::NameError
        nil
      end
      ::Kernel.raise ::NameError, "undefined method `#{selector}' for class `#{self.inspect}'"
    end

    # Returns the list of modules included or prepended in mod or one of mod’s ancestors.
    def include(mod)
      ::Kernel.puts("Including #{mod} in #{self}")
      ::Kernel.puts("Do ancestors already include #{mod}? #{ancestors.include?(mod)}")
      # Avoid including module that already exists in the hierarchy
      return if ancestors.include?(mod)

      previous_superclass_ptr = superclass_ptr
      # Point the superclass_pointer to the module being included
      self.superclass_ptr = mod

      return unless previous_superclass_ptr

      # Superclass pointer at end of hierarchy for module being included needs to point to previous superclass pointer
      ptr = mod
      while ptr && ptr.superclass_ptr
        ptr = ptr.superclass_ptr
      end

      ::Kernel.puts("Setting #{ptr.superclass_ptr} to #{previous_superclass_ptr}")
      ptr.superclass_ptr = previous_superclass_ptr
    end

    # Traverse inclusion tree, flattening (remove duplicates / cycles)
    def included_modules
      traverse_ancestors.reject { |ancestor| ancestor.class == Class}
    end

    # Unlike a true superclass, the superclass_ptr is a pointer to the object that sits
    # above this module on the hierarchy. This is a module or a class.
    # This is modelled after the way Ruby works internally.
    attr_accessor :superclass_ptr

    private

    def constant_map
      @constant_map ||= {}
    end

    def method_map
      @method_map ||= {}
    end

    def traverse_ancestors
      ptr = superclass_ptr
      ancestors = ptr ? [ptr] : []

      while ptr && ptr.superclass_ptr do
        ptr = ptr.superclass_ptr
        break if ancestors.include?(ptr) # Avoid cycles
        ancestors << ptr
      end
      ancestors
    end
  end
end
