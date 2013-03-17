class String
  def embedda
    youtube_replace!
    vimeo_replace!
  end

 private
  def youtube_replace!
    self.gsub(/[http|https]+:\/\/(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+)\S*/, youtube_player("\\1"))
    self.gsub(/<a[^>]*?youtube\.com\/watch\?sv=([a-zA-Z0-9\-\_]+).*?<\/a>/, youtube_player("\\1"))
  end
  def youtube_player(token)
    return <<-END
<iframe width="560" height="315" src="http://www.youtube.com/embed/#{token}" frameborder="0" allowfullscreen></iframe>
    END
  end

  def vimeo_replace!
    self.gsub(/[http|https]+:\/\/(?:www\.)?vimeo\.com\/(\d+)\S*/, vimeo_player("\\1"))
    self.gsub(/<a[^>]*?vimeo\.com\/(\d+).*?<\/a>/, vimeo_player("\\1"))
  end
  def vimeo_player(token)
    return <<-END
<iframe src="http://player.vimeo.com/video/#{token}" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
    END
  end
end