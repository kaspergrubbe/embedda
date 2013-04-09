class String
  def embedda(options = {})
    options = {:filters => [:youtube, :vimeo]}.merge(options)

    # Make sure that filters is an array because we allow the short form of
    # "hello".embedda(:filters => :youtube) instead of "hello".embedda(:filters => [:youtube])
    options[:filters] = Array(options[:filters])

    compiled = self
    compiled = youtube_replace(compiled) if options[:filters].include?(:youtube)
    compiled = vimeo_replace(compiled)   if options[:filters].include?(:vimeo)

    return compiled
  end

 private
  def youtube_replace(compiled)
    compiled.gsub!(/<a[^>]*?youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+).*?<\/a>/i, youtube_player("\\1"))
    compiled.gsub!(/[http|https]+:\/\/(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+)\w*/i, youtube_player("\\1"))

    return compiled
  end
  def youtube_player(token)
    "<iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/#{token}\" frameborder=\"0\" allowfullscreen></iframe>"
  end

  def vimeo_replace(compiled)
    compiled.gsub!(/<a[^>]*?vimeo\.com\/(\d+).*?<\/a>/i, vimeo_player("\\1"))
    compiled.gsub!(/[http|https]+:\/\/(?:www\.)?vimeo\.com\/(\d+)\w*/i, vimeo_player("\\1"))

    return compiled
  end
  def vimeo_player(token)
    "<iframe src=\"http://player.vimeo.com/video/#{token}\" width=\"500\" height=\"281\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"
  end
end