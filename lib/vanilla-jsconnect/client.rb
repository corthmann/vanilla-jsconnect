require 'vanilla-jsconnect/error'

module VanillaJsConnect
  class Client
    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    def initialize(options = {})
      merged_options = VanillaJsConnect.options.merge(options)

      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    def config
      conf = {}
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send(key)
      end
      conf
    end

    # Authenticate JsConnect request and return user object
    # user = { uniqueid: ..., name: ..., photourl: ..., email: ... }
    def authenticate(request, user = {})
      if result = validate_request(request, user)
        result
      elsif has_user(user)
        sign_js_connect(user)
      else
        user_stub_response
      end
    end

    private
    def has_user(user)
      user && !user.empty?
    end

    def user_stub_response(user_name = '', photourl = '')
      { 'name' => user_name , 'photourl' => photourl }
    end

    def validate_request(request, user)
      request_timestamp = (request['timestamp'].nil? ? nil : request['timestamp'].to_i)

      validate_client(request['client_id'])
      if request_timestamp.nil? && request['signature'].nil?
        if has_user(user)
          user_stub_response(user['name'], user['photourl'])
        else
          user_stub_response
        end
      else
        validate_timestamp(request_timestamp)
        validate_signature(request['signature'], request_timestamp)
      end
    end

    def validate_client(request_client_id)
      if !request_client_id
        raise VanillaJsConnect::InvalidRequest.new('The client_id parameter is missing.')
      elsif request_client_id != client_id
        raise VanillaJsConnect::InvalidClient.new("Unknown client #{request_client_id}.")
      end
    end

    def validate_timestamp(request_timestamp)
      if request_timestamp.nil?
        raise VanillaJsConnect::InvalidRequest.new('The timestamp is missing or invalid.')
      elsif (Time.now.to_i - request_timestamp).abs > 30 * 60
        raise VanillaJsConnect::InvalidRequest.new('The timestamp is invalid.')
      end
    end

    def validate_signature(request_signature, request_timestamp)
      if !request_signature
        raise VanillaJsConnect::InvalidRequest.new('The signature is missing.')
      else
        # Make sure the timestamp's signature checks out.
        if generate_signature(request_timestamp) != request_signature
          raise VanillaJsConnect::AccessDenied.new('Signature invalid.')
        end
      end
    end

    def generate_signature(text)
      case hash_method
        when :md5
          Digest::MD5.hexdigest(text.to_s + secret)
        when :sha1
          Digest::SHA1.hexdigest(text.to_s + secret)
        else
          raise VanillaJsConnect::Error.new('configuration_error', 'Invalid hash method configuration')
      end
    end

    def sign_js_connect(data)
      keys = data.keys.sort { |a,b| a.downcase <=> b.downcase }

      sig_str = ''
      keys.each_with_index do |key, index|
        if index > 0
          sig_str += '&'
        end
        sig_str += "#{CGI.escape(key)}=#{CGI.escape(data[key].to_s)}"
      end

      data['clientid'] = client_id
      data['signature'] = generate_signature(sig_str)
      data
    end
  end
end