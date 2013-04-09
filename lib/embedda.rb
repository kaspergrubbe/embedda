require 'cgi'

class String
  def embedda(options = {})
    options = {:filters => [:youtube, :vimeo, :soundcloud]}.merge(options)

    # Make sure that filters is an array because we allow the short form of
    # "hello".embedda(:filters => :youtube) instead of "hello".embedda(:filters => [:youtube])
    options[:filters] = Array(options[:filters])

    compiled = self
    compiled = youtube_replace(compiled)    if options[:filters].include?(:youtube)
    compiled = vimeo_replace(compiled)      if options[:filters].include?(:vimeo)
    compiled = soundcloud_replace(compiled) if options[:filters].include?(:soundcloud)

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

  def soundcloud_replace(compiled)
    r = /(https?:\/\/(?:www.)?soundcloud.com\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*(?!\/sets(?:\/|$))(?:\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*){1,2}\/?)/i
    compiled.gsub!(r) { |match| soundcloud_player(match) }

    return compiled
  end

  def soundcloud_player(token)
    url_encoded_string = CGI::escape(token)

    # Note: added '&' ...?url=...&
    "<iframe width=\"100%\" height=\"166\" scrolling=\"no\" frameborder=\"no\" src=\"https://w.soundcloud.com/player/?url=#{url_encoded_string}&color=ff6600&amp;auto_play=false&amp;show_artwork=false\"></iframe>"
  end
end
