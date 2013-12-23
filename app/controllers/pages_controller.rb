class PagesController < ApplicationController

  COLORS =["A69700",	"00F273",
           "6c006c",	"D25FD2",
           "090974",	"7373D9"].freeze
  WIDGETS = [SineWave, SquareWave, TriangleWave, RandomFunction, InstagramWidget].freeze

  INSTA_TAG = 'c5scavenger'

  def index
    opts = process_params
    nwidgets = [[opts[:n].to_i || 6, 18].min, 1].max
    @widgets = nwidgets.times.map do |n|
      construct_widget(WIDGETS.sample, n)
    end
  end

  def instagram_widget
    render InstagramWidget.new :tag => INSTA_TAG
  end

  def construct_widget(widget_class, n = 0)
    if widget_class != InstagramWidget
      opts = {
        frequency: n+1,
        color: color
      }
      widget_class.new opts
    else
      widget_class.new :tag => INSTA_TAG
    end
  end

  def color(idx = nil) 
    idx.nil? ? COLORS.sample : COLORS[idx % COLORS.length]
  end

  def process_params
    params.permit :n
  end
end


    
    
