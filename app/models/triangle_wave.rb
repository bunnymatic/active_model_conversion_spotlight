class TriangleWave < PeriodicFunction

  def generator(x)
    [x, (((x+1) % wavelength) - amplitude).to_f.abs ]
  end

end
