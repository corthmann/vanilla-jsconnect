module VanillaJsConnect
  class Error < StandardError
    attr_reader :code, :message

    def initialize(code = nil, message = nil)
      @code = code
      @message = message
    end

    def inspect
      "#<VanillaJsConnect::Error: VanillaJsConnect::Error code=\"#{@code}\" message=\"#{@message}\">"
    end

    def to_json
      { code: @code, message: @message }.to_json
    end
  end

  class InvalidRequest < Error
    def initialize(message)
      @code = 'invalid_request'
      @message = message
    end
  end

  class InvalidClient < Error
    def initialize(message)
      @code = 'invalid_client'
      @message = message
    end
  end

  class AccessDenied < Error
    def initialize(message)
      @code = 'access_denied'
      @message = message
    end
  end

end