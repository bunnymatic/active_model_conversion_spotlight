class InstagramWidget

  include ActiveModel::Conversion
  
  def tag
    'c5scavenger'
  end

  def image
    instagram.image
  end
  
  def instagram
    @@instagram ||= InstagramFeed.new(:tag => tag)
  end
  
end
