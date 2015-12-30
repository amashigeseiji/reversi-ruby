#$:.unshift File.dirname(__FILE__) + '/../'
load_dir = ->(dir) {
  Dir[File.expand_path("../#{dir}", __FILE__) << '/*.rb'].each do |file|
    require file
  end
}

%w(lib model controller view).each do |dir|
  load_dir.call(dir)
end

require './model/strategy/strategy'
