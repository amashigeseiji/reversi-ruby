class Class
  def subclasses
    subclasses = []
    ObjectSpace.each_object(singleton_class) do |k|
      subclasses << k if k.superclass == self
    end
    subclasses
  end
end
