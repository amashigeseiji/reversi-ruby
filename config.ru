require './loader.rb'

use Rack::Reloader, 0
use Rack::Session::Cookie
run App.new
