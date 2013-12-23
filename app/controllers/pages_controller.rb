class PagesController < ApplicationController


  WIDGETS = [SineWave, SquareWave, TriangleWave, RandomFunction, InstagramWidget].freeze

  INSTA_TAG = 'c5scavenger'

  def index
    opts = process_params
    n = opts[:n] || 6
    nwidgets = [[n.to_i, 18].min, 1].max
    @widgets = nwidgets.times.map{ WIDGETS.sample.new }
  end

  def instagram_widget
    render InstagramWidget.new :tag => INSTA_TAG
  end

  def process_params
    params.permit :n
  end
end


    
    
