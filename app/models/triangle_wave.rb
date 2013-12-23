class TriangleWave < PeriodicFunction

  def generator(x)
    [x, (((x+1) % wavelength) - amplitude).to_f.abs/wavelength ]
  end

  def max
    1.0
  end

  def min
    0.0
  end

end
