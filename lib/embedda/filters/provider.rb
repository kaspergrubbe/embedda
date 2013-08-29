require 'embedda/filters/vimeo'
require 'embedda/filters/youtube'
require 'embedda/filters/soundcloud'

class Embedda
  module Filters
    class Provider

      attr_reader :options
      def initialize(options)
        @options = options
      end

      def get(filter_name)
        case filter_name
        when :vimeo
          Vimeo.new(protocol, video_width, video_height, vimeo_url)
        when :youtube
          Youtube.new(protocol, video_width, video_height)
        when :soundcloud
          Soundcloud.new
        else
          raise UnknownFilter.new(filter_name)
        end
      end

      private

      def protocol
        options[:ssl] ? 'https' : 'http'
      end

      def video_width
        options.fetch(:video_width, 560)
      end

      def video_height
        options.fetch(:video_height, 315)
      end

      def vimeo_url
        options.fetch(:vimeo_url, nil)
      end

    end
  end
end
