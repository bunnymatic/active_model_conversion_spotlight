class SineWave < PeriodicFunction

  include ActiveModel::Conversion

  def initialize(*args)
    super
  end

  def generator(x)
    [x, @amplitude * Math.sin(2.0 * Math::PI * (1.0/@wavelength) * x.to_f) ]
  end

end
