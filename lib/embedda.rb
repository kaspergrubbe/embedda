require 'cgi'
require 'helpers/url_regex'

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
    compiled.gsub!(/(#{Regex::URL[:scheme]}youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+)\w*)/i) { |m| youtube_player($2) }

    return compiled
  end
  def youtube_player(token)
    "<iframe width=\"560\" height=\"315\" src=\"http://www.youtube.com/embed/#{token}\" frameborder=\"0\" allowfullscreen></iframe>"
  end

  def vimeo_replace(compiled)
    compiled.gsub!(/(<a[^>]*?vimeo\.com\/(\d+).*?<\/a>)/i) { |m| vimeo_player($2) }
    compiled.gsub!(/(#{Regex::URL[:scheme]}vimeo\.com\/(\d+)\w*)/i) { |m| vimeo_player($2) }

    return compiled
  end
  def vimeo_player(token)
    "<iframe src=\"http://player.vimeo.com/video/#{token}\" width=\"500\" height=\"281\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"
  end

  def soundcloud_replace(compiled)
    # Known URL's
    #   https://soundcloud.com/:user/:tracks
    #   https://soundcloud.com/:user/sets/:tracks
    url_re = / # Match Soundcloud track or sets URL
              (                        # Capture Group
                #{Regex::URL[:scheme]} # URL scheme
                soundcloud.com\/       #
                [A-Za-z0-9_-]+         # One or more word character, underscore and dash included
                \/                     # slash
                (?:sets\/)?            # Optional sets-slash                  non-capturing group
                [A-Za-z0-9_-]+         # One or more word character, underscore and dash included
              )
              /ix

    link_re = / # Match Soundcloud a-tag with track or sets URL
              <a.+        # Start of HTML anchor-tag plus random characters
                #{url_re}
              .+<\/a>     # Random characters plus end of HTML anchor-tag
              /ix

    compiled.gsub!(link_re) { |m| $1 }                   # Substitute anchor-tags with soundcloud URL's
    compiled.gsub!(url_re)  { |m| soundcloud_player(m) } # Substitute URL's with soundcloud_player

    return compiled
  end

  def soundcloud_player(token)
    url_encoded_string = CGI::escape(token)

    # Note: changed ';' to '&'  ...?url=...&
    "<iframe width=\"100%\" height=\"166\" scrolling=\"no\" frameborder=\"no\" src=\"https://w.soundcloud.com/player/?url=#{url_encoded_string}&color=ff6600&amp;auto_play=false&amp;show_artwork=false\"></iframe>"
  end
end
