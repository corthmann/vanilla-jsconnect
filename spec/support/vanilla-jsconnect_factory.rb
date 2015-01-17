module VanillaJsConnectFactory
  def self.client_id
    1234567890
  end

  def self.secret
    'nobodyknows'
  end

  def self.user
    { 'uniqueid' => 1, 'name' => 'John Smith', 'photourl' => 'http://example.com/image', 'email' => 'test@email.com' }
  end

end