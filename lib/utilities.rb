module Utilities
  def valid_json?(json)
    JSON.parse(json)
    true
  rescue JSON::ParserError => e
    false
  end
end
