# vanilla-jsconnect
[![Code Climate](https://codeclimate.com/github/corthmann/vanilla-jsconnect/badges/gpa.svg)](https://codeclimate.com/github/corthmann/vanilla-jsconnect)
[![Test Coverage](https://codeclimate.com/github/corthmann/vanilla-jsconnect/badges/coverage.svg)](https://codeclimate.com/github/corthmann/vanilla-jsconnect)

Library to connect Vanilla forums to ruby applications.

This gem is based upon the official documentation and Vanilla JsConnect library which can be found at https://github.com/vanillaforums/jsConnectRuby.

Installation
-------------
Coming soon...

Configuration
-------------
The gem can be configured either by module or class configuration.
```
# module configuration
VanillaJsConnect.configure do |config|
  config.client_id = 'CLIENT_ID'
  config.secret = 'SECRET'
  config.hash_method = 'HASH_METHOD' # (optional)
end

# class configuration
client = VanillaJsConnect::Client.new(
                client_id: 'CLIENT_ID',
                secret: 'SECRET',
                hash_method: 'HASH_METHOD' # (optional)
            )
```

Using the library
-------------
Vanilla jsConnect User:
```
user = {
    'uniqueid' => 'UNIQUE USER ID FROM YOUR SYSTEM',
    'name' => 'USER NAME',
    'email' => 'USER EMAIL',
    'photourl' => 'USER IMAGE'
}
```
Authenticate a request and generate jsConnect (json) response
```
json = VanillaJsConnect::Client.new.authenticate(request, user).to_json
```

To complete the Single Sign On (SSO) you should render the resulting json string as jsonp. In rails this can be done like this:
```
render :json => json, :callback => params[:callback]
```

Error handling
-------------
The `authenticate` method will raise errors if an incoming request is invalid.

If you have no interest in logging or tracking potential errors then you can do as follows to let it fail gracefully.
```
begin
    client = VanillaJsConnect::Client.new
    json = client.authenticate(request, user).to_json
rescue VanillaJsConnect::Error => error
    json = error.to_json
end
render :json => json, :callback => params[:callback]
```

JsConnect and SSO explained
-------------
When connecting Vanilla to another website through SSO you are typically interested in:

* Authentication
* Login / Logout
* Registration (Sign-up)

In Vanilla SSO authentication happens as an AJAX JSONP request sent to the authentication url configured in the Vanilla Dashboard.

The authentication url then authenticates the incomming request and respond with user data if a signed in user session already exist on the connecting website. It is this authentication the `vanilla-jsconnect` gem adds to your website.

SSO Login, Logout and Registration happens through redirection. To configure these actions correctly it is important to add this query parameter to the respective urls `Target={target}`. When a user then clicks on Register in the Vanilla forum he or she is then taken to the registration page of your main website. Upon completion of the registration flow, the main website then redirects the user back to the forum using the `Target` query parameter as the destination. When the user now enters the forum the authentication request gets user data from the main website.