require 'embedda/filters/provider'

class Embedda
  class UnknownFilter < StandardError
    def initialize(name)
      super "Unknown filter #{name}"
    end
  end

  attr_reader :string, :options

  def initialize(string_to_process, options = {})
    @options = defaultize_options(options)
    @string  = string_to_process.to_s
  end

  def embed
    return @string if @string.empty?
    process_string_with_all_filters
    @string
  end

  private

  def defaultize_options(options)
    {:filters => [:youtube, :vimeo, :soundcloud]}.merge(options)
  end

  def filters
    Array(options[:filters])
  end

  def process_string_with_all_filters
    filters.each{|filter_name| process_with_filter(filter_name) }
  end

  def process_with_filter(filter_name)
    get_filter(filter_name).process(string)
  end

  def get_filter(filter_name)
    filter_provider.get(filter_name)
  end

  def filter_provider
    Filters::Provider.new(options)
  end
end
