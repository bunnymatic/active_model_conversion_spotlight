class PeriodicFunction

  attr_reader :created_at, :color, :wavelength, :frequency
  
  DEFAULTS = { 
    frequency: 2,
    length: 128,
    amplitude: 1
  }
  
  def initialize(params = {})
    opts = DEFAULTS.merge(params)
    @color = opts[:color]
    @length = opts[:length].to_i
    @amplitude = opts[:amplitude].to_f
    @frequency = opts[:frequency].to_f
    @wavelength = @length/@frequency
    @created_at = Time.zone.now
  end

  def display_wavelength
    "%2.2f" % wavelength
  end

  def display_frequency
    "%2.2f" % frequency
  end

  def id
    'H' + hash.to_s.gsub(/^\-/, 'A')
  end

  def data
    raise "You must define a generator for the derived class" unless respond_to? :generator
    @length.times.map{|x| generator(x)}
  end

end
