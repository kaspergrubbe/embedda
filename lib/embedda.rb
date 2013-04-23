require 'cgi'

class Embedda
  class UnknownFilter < StandardError
    def initialize(name)
      super "Unknown filter #{name}"
    end
  end

  def initialize(string, options = {})
    options  = {:filters => [:youtube, :vimeo, :soundcloud]}.merge(options)
    @filters = Array(options[:filters])
    @string  = string
  end

  def embed
    return "" if @string.to_s.empty?
    @filters.each do |filter_name|
      begin
        @string = send("#{filter_name}_replace", @string)
      rescue NoMethodError
        raise UnknownFilter.new(filter_name)
      end
    end
    @string
  end

  private

  def youtube_replace(compiled)
    compiled.gsub!(/(<a[^>]*?youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+).*?<\/a>)/i) { |m| youtube_player($2) }
    compiled.gsub!(/([http|https]+:\/\/(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+)\w*)/i) { |m| youtube_player($2) }

    return compiled
  end
  def youtube_player(token)
    "<iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/#{token}\" frameborder=\"0\" allowfullscreen></iframe>"
  end

  def vimeo_replace(compiled)
    compiled.gsub!(/(<a[^>]*?vimeo\.com\/(\d+).*?<\/a>)/i) { |m| vimeo_player($2) }
    compiled.gsub!(/([http|https]+:\/\/(?:www\.)?vimeo\.com\/(\d+)\w*)/i) { |m| vimeo_player($2) }

    return compiled
  end
  def vimeo_player(token)
    "<iframe src=\"http://player.vimeo.com/video/#{token}\" width=\"500\" height=\"281\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"
  end

  def soundcloud_replace(compiled)
    r = /(https?:\/\/(?:www.)?soundcloud.com\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*(?!\/sets(?:\/|$))(?:\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*){1,2}\/?)/i
    compiled.gsub!(r) { |m| soundcloud_player(m) }

    return compiled
  end
  def soundcloud_player(token)
    url_encoded_string = CGI::escape(token)

    # Note: added '&' ...?url=...&
    "<iframe width=\"100%\" height=\"166\" scrolling=\"no\" frameborder=\"no\" src=\"https://w.soundcloud.com/player/?url=#{url_encoded_string}&color=ff6600&amp;auto_play=false&amp;show_artwork=false\"></iframe>"
  end
end
