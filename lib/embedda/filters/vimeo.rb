class Embedda
  module Filters
    class Vimeo
      def initialize(protocol, width, height)
        @protocol = protocol
        @width    = width
        @height   = height
      end

      def process(string)
        string.gsub!(/(<a[^>]*?vimeo\.com\/(\d+).*?<\/a>)/i) { |m| player($2) }
        string.gsub!(/([http|https]+:\/\/(?:www\.)?vimeo\.com\/(\d+)\w*)/i) { |m| player($2) }
        return string
      end

      private

      def player(token)
        "<iframe src=\"#{@protocol}://player.vimeo.com/video/#{token}\" width=\"500\" height=\"281\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"
      end
    end
  end
end
