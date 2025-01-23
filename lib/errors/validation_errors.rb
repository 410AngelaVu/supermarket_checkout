module Errors
  class ValidationError < StandardError
    def initialize(message = "A validation error occurred")
      super(message)
    end
  end
end
