require './loader.rb'

use Rack::Reloader, 0
run App.new
