require 'helpers/url_regex'

module Regex
  # Known URL's
  #   https://soundcloud.com/:user/:tracks
  #   https://soundcloud.com/:user/sets/:tracks
  Soundcloud = { :url => / # Match Soundcloud track or sets URL
                         (                        # Capture Group
                           #{Regex::URL[:scheme]} # URL scheme
                           soundcloud.com\/       #
                           [A-Za-z0-9_-]+         # One or more word character, underscore and dash included
                           \/                     # slash
                           (?:sets\/)?            # Optional sets-slash                  non-capturing group
                           [A-Za-z0-9_-]+         # One or more word character, underscore and dash included
                         )
                         /ix }

  Soundcloud[:anchor] = / # Match Soundcloud a-tag with track or sets URL
                           <a.+                 # Start of HTML anchor-tag plus random characters
                            #{Soundcloud[:url]}
                           .+<\/a>              # Random characters plus end of HTML anchor-tag
                           /ix
end
