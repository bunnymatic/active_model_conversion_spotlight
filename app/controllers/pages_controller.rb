class PagesController < ApplicationController

  FUNCTIONS = [SineWave, SquareWave, TriangleWave].freeze

  def index
    opts = process_params
    nwidgets = [1, [opts[:n].to_i, 20].min].max
    @widgets = nwidgets.times.map do |n|
      opts = {
        frequency: n+1,
        color: color
      }
      FUNCTIONS.sample.new opts
    end

  end

  COLORS =["A69700",	"00F273",
           "6c006c",	"D25FD2",
           "090974",	"7373D9"].freeze

  def color(idx = nil) 
    idx.nil? ? COLORS.sample : COLORS[idx % COLORS.length]
  end

  def process_params
    params.permit :n
  end
end


    
    
