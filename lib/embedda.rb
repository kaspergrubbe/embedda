class String
  def embedda
    compiled = youtube_replace(self)
    compiled = vimeo_replace(compiled)

    return compiled
  end

 private
  def youtube_replace(compiled)
    compiled.gsub!(/<a[^>]*?youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+).*?<\/a>/i, youtube_player("\\1"))
    compiled.gsub!(/[http|https]+:\/\/(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+)\S*/i, youtube_player("\\1"))

    return compiled
  end
  def youtube_player(token)
    "<iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/#{token}\" frameborder=\"0\" allowfullscreen></iframe>"
  end

  def vimeo_replace(compiled)
    compiled.gsub!(/<a[^>]*?vimeo\.com\/(\d+).*?<\/a>/i, vimeo_player("\\1"))
    compiled.gsub!(/[http|https]+:\/\/(?:www\.)?vimeo\.com\/(\d+)\S*/i, vimeo_player("\\1"))

    return compiled
  end
  def vimeo_player(token)
    "<iframe src=\"http://player.vimeo.com/video/#{token}\" width=\"500\" height=\"281\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"
  end
end