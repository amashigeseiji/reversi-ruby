module Strategy
  class AbstractStrategy
    def initialize
      raise 'AbstractStrategy class can not instanciate.' if self.class == AbstractStrategy
      @evaluator = Evaluator.new
    end

    def choice(game)
      raise 'Abstract method `choice` not defined'
    end
  end

  def factory(name)
    require "./model/strategy/#{name}.rb"
    const_get(name.camelize).new
  end

  module_function :factory
end
