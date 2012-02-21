# encoding: UTF-8
require 'oauth2'
require 'multi_json'

# Create or Manage App => https://manage.dev.live.com/
module Oauth
  module Contacts
    class Live < Oauth::Contacts::OAuth2

      def initialize
        super
        @callback_url = Settings.oauth.contacts.live.callback_url

        opts = { key: Settings.oauth.contacts.live.key, secret: Settings.oauth.contacts.live.secret,
          extra: { site: 'https://oauth.live.com',
            authorize_url: '/authorize',
            token_url: '/token',
            max_redirects: 5,
            raise_errors: true,
            token_method: :post,
            connection_opts: {} # [Hash] :connection_opts ({}) Hash of connection options to pass to initialize Faraday with
          } }

        @consumer = ::OAuth2::Client.new(opts[:key], opts[:secret], opts[:extra])
      end

      def authorize_url
        # Scopes and permissions http://msdn.microsoft.com/en-us/library/hh243646.aspx
        scopes = Settings.oauth.contacts.live.scopes

        extra_params = { scope: scopes.join(' '),
          redirect_uri: callback_url,
          response_type: 'code',
          state: 'live' }

        consumer.auth_code.authorize_url( extra_params )
      end

      # REST API http://msdn.microsoft.com/en-us/library/hh243648.aspx
      def contacts
        token!

        request = 'https://apis.live.net/v5.0/me/contacts'
        @contacts = normalize(MultiJson.decode(access_token.get(request, parse: :json).body))
      end

      private

      def token!
        if @access_token
          @access_token.refresh! if @access_token.expired?
        else
          @access_token = consumer.auth_code.get_token(code, { redirect_uri: callback_url, parse: :json })
        end
      end

      def normalize(contacts) #:nodoc:
        _contacts = { 'contacts' => [] }

        contacts['data'].each do |contact|
          _contacts['contacts'] << {
            name:   contact['name'],
            email: contact['email_hashes'].first,
            emails: contact['email_hashes'] }
        end
        _contacts
      end

    end
  end
end
