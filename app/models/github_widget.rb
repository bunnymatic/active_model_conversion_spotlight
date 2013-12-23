class GithubWidget

  include ActiveModel::Conversion

  def user 
    'carbonfive'
  end

  def activity
    entries.map do |e|
      t = e.title.gsub /^(#{user}\s+)/, '<span class="user">\1</span>'
      t.gsub /(repository|forked|to|sourced)\s+(\S+)/, '\1 <span class="repo">\2</span> '
    end
  end

  def entries
    github.entries.sample(10)
  end

  def github
    @@github ||= GithubFeed.new(:user => user)
  end
 

end
