require 'securerandom'

class Resource
  attr_reader :id

  def initialize(id = nil, dir = nil)
    @id = id || Resource.random
    @data = {}
    @dir = dir ? dir + '/' : nil
    read
  end

  def read
    @data = Marshal.load(open(filename, &:read)) if exist?
  end

  def write
    File.open(filename, 'w') { |f| f.write(Marshal.dump(@data)) }
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

  def directory
    datadir = './data/'
    dir = "#{datadir}#{@dir}"
    Dir::mkdir dir unless Dir::exist? dir
    dir
  end

  def destroy
    File.delete(filename)
  end

  def self.random
    SecureRandom.urlsafe_base64
  end

  private

  def filename
    directory + id.to_s
  end
end
