# Class to manage widgets using Ajax
class WidgetsController < ApplicationController

  WIDGETS = [
    SineWave, 
    SquareWave, 
    TriangleWave, 
    RandomFunction, 
    GithubWidget,
    InstagramWidget].freeze

  INSTA_TAG = 'work'

  def index 
    @ajax_urls = WIDGETS.map{|w| "widgets/" + self.class.widget_class_as_url(w)}
  end

  def self.widget_class_as_url(clz)
    clz.name.tableize.gsub /s$/, '' # "waves".singularize  gives odd results
  end
   
  WIDGETS.each do |w|
    method_name = widget_class_as_url(w)
    define_method method_name do |*args|
      render w.new
    end
  end

  def process_params
    params.permit :n
  end



end


    
    
