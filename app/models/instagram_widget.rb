class InstagramWidget

  include ActiveModel::Model
  include ActiveModel::Conversion

  attr_accessor :tag

  def image
    instagram.image
  end
  
  def instagram
    @@instagram ||= InstagramFeed.new(:tag => @tag || 'c5scavenger')
  end
  
end
