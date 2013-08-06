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

  def embed(options={})
    return "" if @string.to_s.empty?
    @filters.each do |filter_name|
      begin
        @string = send("#{filter_name}_replace", @string, options)
      rescue NoMethodError
        raise UnknownFilter.new(filter_name)
      end
    end
    @string
  end

  private

  def youtube_replace(compiled, options={})
    compiled.gsub!(/(<a[^>]*?youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+).*?<\/a>)/i) { |m| youtube_player($2, options) }
    compiled.gsub!(/([http|https]+:\/\/(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+)\w*)/i) { |m| youtube_player($2, options) }

    return compiled
  end
  def youtube_player(token, options={})
    protocol = options[:ssl] ? 'https' : 'http'
    "<iframe width=\"560\" height=\"315\" src=\"#{protocol}://www.youtube.com/embed/#{token}\" frameborder=\"0\" allowfullscreen></iframe>"
  end

  def vimeo_replace(compiled, options={})
    compiled.gsub!(/(<a[^>]*?vimeo\.com\/(\d+).*?<\/a>)/i) { |m| vimeo_player($2, options) }
    compiled.gsub!(/([http|https]+:\/\/(?:www\.)?vimeo\.com\/(\d+)\w*)/i) { |m| vimeo_player($2, options) }

    return compiled
  end
  def vimeo_player(token, options={})
    protocol = options[:ssl] ? 'https' : 'http'
    "<iframe src=\"#{protocol}://player.vimeo.com/video/#{token}\" width=\"500\" height=\"281\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"
  end

  def soundcloud_replace(compiled, options={})
    r = /(https?:\/\/(?:www.)?soundcloud.com\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*(?!\/sets(?:\/|$))(?:\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*){1,2}\/?)/i
    compiled.gsub!(r) { |m| soundcloud_player(m, options) }

    return compiled
  end
  def soundcloud_player(token, options={})
    url_encoded_string = CGI::escape(token)

    # Note: added '&' ...?url=...&
    "<iframe width=\"100%\" height=\"166\" scrolling=\"no\" frameborder=\"no\" src=\"https://w.soundcloud.com/player/?url=#{url_encoded_string}&color=ff6600&amp;auto_play=false&amp;show_artwork=false\"></iframe>"
  end
end
