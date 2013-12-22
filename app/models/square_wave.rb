class SquareWave < SineWave

  def generator(x)
    x,y = super
    y = (y>=0 ? @amplitude : -@amplitude)
    [x,y]
  end

end
