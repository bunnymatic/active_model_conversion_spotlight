class TriangleWave < PeriodicFunction

  include ActiveModel::Conversion

  def initialize(*args)
    super
  end

  def generator(x)
    [x, (((x+1) % @wavelength) - @amplitude).to_f.abs ]
  end
end
