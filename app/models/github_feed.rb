class GithubFeedError < StandardError; end
class GithubFeed
  include ActiveModel::Model

  attr_accessor :user
  validates :user, :presence => true

  def title
    entries.sample.title
  end
  
  def entries
    @entries ||= fetch.entries
  end

  private 

  def fetch
    Feedjira::Feed.fetch_and_parse feed_url
  end

  def feed_url
    raise GithubFeedError.new(errors.full_messages) unless valid?
    "https://github.com/#{@user}.atom"
  end
end
