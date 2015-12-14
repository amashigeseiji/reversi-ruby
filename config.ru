require './lib/loader.rb'

use Rack::Reloader, 0
use Rack::Session::Cookie
use Rack::Static, urls: ['/css', '/js'], root: 'public'
run App.new
