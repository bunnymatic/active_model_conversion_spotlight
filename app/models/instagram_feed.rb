class InstagramFeedError < StandardError; end
class InstagramFeed
  include ActiveModel::Model

  attr_accessor :tag
  validates :tag, :presence => true

  def image
    entries.sample.image
  end
  
  def entries
    @entries ||= fetch.entries
  end

  private 

  def fetch
    Feedjira::Feed.fetch_and_parse feed_url
  end

  def feed_url
    raise InstagramFeedError.new(errors.full_messages) unless valid?
    "http://instagram.com/tags/#{tag}/feed/recent.rss"
  end
end
