class RandomFunction < PeriodicFunction

  include ActiveModel::Conversion

  def display_wavelength
    'N/A'
  end

  def display_frequency
    'N/A'
  end

  def generator(x)
    [x,@amplitude * rand]
  end
end
