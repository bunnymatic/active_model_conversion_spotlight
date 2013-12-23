class PeriodicFunction

  COLORS =["A69700",	"00F273",
           "6c006c",	"D25FD2",
           "090974",	"7373D9"].freeze

  include ActiveModel::Model
  include ActiveModel::Conversion

  validates :frequency, :numericality => true
  validates :length, :numericality => true

  attr_accessor :created_at, :color, :frequency, :amplitude, :length

  def initialize(*args)
    super
    @length ||= 128
    @frequency ||= 1+rand(8)
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

  def color
    @color ||= COLORS.sample
  end

end
