module NewImpl
  # Think of these toy objects as the singletons
  ToyObject = BasicObject.new

  def ToyObject.to_s
    inspect
  end

  def ToyObject.inspect
    "ToyObject"
  end

  def ToyObject.toy_class
    ToyClass
  end

  def ToyObject.toy_kind_of?(klass)
    superclass = toy_class
    while superclass
      return true if klass == superclass
      superclass = superclass.toy_superclass
    end
    false
  end

  ToyModule = BasicObject.new

  def ToyModule.to_s
    inspect
  end

  def ToyModule.inspect
    "ToyModule"
  end

  def ToyModule.toy_class
    ToyClass
  end

  def ToyModule.toy_superclass
    ToyObject
  end

  def ToyModule.toy_kind_of?(klass)
    superclass = toy_class
    while superclass
      return true if klass == superclass
      superclass = superclass.toy_superclass
    end
    false
  end

  ToyClass = BasicObject.new

  def ToyClass.to_s
    inspect
  end

  def ToyClass.inspect
    "ToyClass"
  end

  def ToyClass.toy_class
    ToyClass
  end

  def ToyClass.toy_superclass
    ToyModule
  end

  def ToyClass.toy_kind_of?(klass)
    superclass = toy_class
    while superclass
      return true if klass == superclass
      superclass = superclass.toy_superclass
    end
    false
  end
end
