require 'embedda'

class String
  def embedda(options = {})
    Embedda.new(self, options).embed
  end
end
