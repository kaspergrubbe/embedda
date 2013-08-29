class Embedda
  module Filters
    class Youtube
      def initialize(protocol, width, height)
        @protocol = protocol
        @width    = width
        @height   = height
      end

      def process(string)
        string.gsub!(/(<a[^>]*?youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+).*?<\/a>)/i) { |m| player($2) }
        string.gsub!(/([http|https]+:\/\/(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9\-\_]+)\w*)/i) { |m| player($2) }
        return string
      end

      private

      def player(token)
        %Q{<iframe width="#{@width}" height="#{@height}" src="#{@protocol}://www.youtube.com/embed/#{token}" frameborder="0" allowfullscreen></iframe>}
      end
    end
  end
end

