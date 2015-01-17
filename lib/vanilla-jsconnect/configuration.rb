module VanillaJsConnect
  module Configuration

    VALID_OPTIONS_KEYS = [
        :client_id,
        :secret,
        :hash_method
    ].freeze

    DEFAULT_CLIENT_ID = nil
    DEFAULT_SECRET = nil
    DEFAULT_HASH_METHOD = :sha1

    attr_accessor *VALID_OPTIONS_KEYS

    def self.extended(base)
      base.reset
    end

    def reset
      self.client_id = DEFAULT_CLIENT_ID
      self.secret = DEFAULT_SECRET
      self.hash_method = DEFAULT_HASH_METHOD
    end

    def configure
      yield self
    end

    # Return the configuration values set in this module
    def options
      Hash[ * VALID_OPTIONS_KEYS.map { |key| [key, send(key)] }.flatten ]
    end
  end
end