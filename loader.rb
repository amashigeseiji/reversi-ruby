#$:.unshift File.dirname(__FILE__) + '/../'
load_dir = ->(dir) {
  Dir[File.expand_path("../#{dir}", __FILE__) << '/*.rb'].each do |file|
    require file
  end
}

%w(lib/extension lib model controller).each do |dir|
  load_dir.call(dir)
end

require './model/strategy/strategy'

ObjectSpace.each_object(Class) do |k|
  k.after_load if k.respond_to?(:after_load)
end
