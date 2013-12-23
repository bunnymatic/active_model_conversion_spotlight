class PeriodicFunction

  include ActiveModel::Model
  include ActiveModel::Conversion

  validates :frequency, :numericality => true
  validates :length, :numericality => true

  attr_accessor :created_at, :color, :frequency, :amplitude, :length

  def initialize(*args)
    super
    @color ||= '#fc2'
    @length ||= 128
    @frequency ||= 2
    @amplitude ||= 1
    @created_at = Time.zone.now
  end

  def wavelength
    length/frequency
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
    length.times.map{|x| generator(x)}
  end

  def max
    amplitude
  end

  def min
    -amplitude
  end

end
