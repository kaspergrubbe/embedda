require 'cgi'

class Embedda
  module Filters
    class Soundcloud
      def process(string)
        r = /(https?:\/\/(?:www.)?soundcloud.com\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*(?!\/sets(?:\/|$))(?:\/[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*){1,2}\/?)/i
        string.gsub!(r) { |m| player(m) }
        return string
      end

      private

      def player(token)
        url_encoded_string = CGI::escape(token)
        # Note: added '&' ...?url=...&
        "<iframe width=\"100%\" height=\"166\" scrolling=\"no\" frameborder=\"no\" src=\"https://w.soundcloud.com/player/?url=#{url_encoded_string}&color=ff6600&amp;auto_play=false&amp;show_artwork=false\"></iframe>"
      end
    end
  end
end
