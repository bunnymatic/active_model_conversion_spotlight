class SquareWave < SineWave

  include ActiveModel::Conversion

  def initialize(*args)
    super
  end

  def generator(x)
    x,y = super
    y = (y>=0 ? @amplitude : -@amplitude)
    [x,y]
  end

end
