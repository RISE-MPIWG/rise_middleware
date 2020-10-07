module Exceptions
  class RemoteError < StandardError
    attr_reader :code
    def initialize(msg = "Remote Error", code)
      @code = code
      super(msg)
    end
  end
end
