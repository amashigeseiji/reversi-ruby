class Entity
  @@after_load = []
  attr_reader :id

  def initialize(id = nil, sandbox = false)
    raise 'Entity class can not instanciate directoly.' if self.class == Entity
    dir = sandbox ? model_name + '/sandbox' : model_name
    @data = Resource.new(id, dir)
    @id = @data.id
    @@entities[model_name][@id] = self
    after_initialize
  end

  def after_initialize
  end

  def model_name
    self.class.to_s
  end

  def destroy
    @data.destroy
  end

  def self.model_name
    self.to_s
  end

  def self.instance(id)
    @@entities[model_name][id] ||= self.new(id)
  end

  def self.destroy(id)
    # ここで呼ばれる model_name は self.model_name のほう
    if @@entities[model_name].has_key? id
      @@entities[model_name][id].destroy
      @@entities[model_name].delete(id)
    end
  end

  # 子クラスのデータ構造
  # クラス宣言時に利用
  def self.data_column(*args)
    @@after_load.push(lambda { self.add_accessors args })
  end

  # loader によるロード処理後に実行
  def self.after_load
    if self == Entity
      # Entityクラスのサブクラスを管理する
      # TODO Repository 的な機能を抱えるのも微妙な気もする
      @@entities = {}
      Entity.subclasses.each do |klass|
        @@entities[klass.to_s] = {}
      end
      @@after_load.each do |callable|
        callable.call
      end
    end
  end

  def self.add_accessors(attr)
    attr.each do |key|
      self.class_eval do
        define_method "#{key}" do
          @data[key]
        end

        define_method "#{key}=" do |value|
          @data[key] = value
        end
      end
    end
  end

  protected

  def save
    @data.write
  end
end
