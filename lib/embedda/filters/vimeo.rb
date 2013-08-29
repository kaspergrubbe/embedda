require 'rack'
require 'uri'

class Embedda
  module Filters
    class Vimeo
      def initialize(protocol, width, height, vimeo_url)
        @protocol = protocol
        @width    = width
        @height   = height
        @vimeo_url= vimeo_url
      end

      def process(string)
        string.gsub!(/(<a[^>]*?vimeo\.com\/(\d+).*?<\/a>)/i) { |m| player($2) }
        string.gsub!(/([http|https]+:\/\/(?:www\.)?vimeo\.com\/(\d+)\w*)/i) { |m| player($2) }
        return string
      end

      private

      def player(token)
        %Q{<iframe src="#{player_url(token)}" width="#{@width}"#{height_attribute} frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>}
      end

      def player_url(token)
        url = URI.parse("http://player.vimeo.com/")
        url.scheme = @protocol
        url.path   = "/video/#{token}"
        url.query  = Rack::Utils.build_query @vimeo_url if @vimeo_url
        url.to_s
      end

      def height_attribute
        %Q{ height="#{@height}"} if @height
      end
    end
  end
end
