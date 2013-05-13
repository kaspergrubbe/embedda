module Regex
  # Info
  #   This will match
  #     ...http://...
  #     ...https://...
  #   where ... is arbitrary text
  URL = { :scheme => / # Match a Uniform Resource Locator scheme
                       (?:http|https) # http or https       non-capturing group
                       :\/\/          # colon-slash-slash
                       (?:www\.)?     # Optional www.       non-capturing group
                     /x }
end
