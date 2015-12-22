require 'securerandom'

class Resource
  attr_reader :id

  def initialize(id = nil)
    @id = id || Resource.random
    @data = {}
    read
  end

  def read
    @data = Marshal.load(open(filename, &:read)) if exist?
  end

  def write
    File.open(filename, 'w') { |f| f.write(Marshal.dump(@data)) }
  end

  def delete
    File.delete(filename)
  end

  def method_missing(name, *args)
    if name =~ /(.*)=$/
      set($1, args[0])
      return
    end
    @data.key?(name.to_sym) ? @data[name.to_sym] : nil
  end

  def set(name, val)
    @data[name.to_sym] = val
  end

  def [](name)
    @data[name.to_sym]
  end

  def []=(name, val)
    set(name, val)
  end

  def exist?
    File.exist? filename
  end

  def self.find(id)
    File.exist?(Resource.dir + id.to_s) ? Resource.new(id) : Resource.new
  end

  def self.random
    SecureRandom.urlsafe_base64
  end

  def self.dir
    datadir = './data/'
    Dir::mkdir datadir unless Dir::exist? datadir
    datadir
  end

  private

  def filename
    Resource.dir + id.to_s
  end
end
