# encoding: UTF-8
require 'oauth2'

# Create or Manage App => https://code.google.com/apis/console#:access
module Oauth
  module Contacts
    class Google < Oauth::Contacts::OAuth2

      def initialize
        super
        @callback_url = Settings.oauth.contacts.google.callback_url

        opts = { key: Settings.oauth.contacts.google.key, secret: Settings.oauth.contacts.google.secret,
          extra: { site: 'https://accounts.google.com',
            authorize_url: '/o/oauth2/auth',
            token_url: '/o/oauth2/token',
            max_redirects: 5,
            raise_errors: true,
            token_method: :post,
            connection_opts: {} # [Hash] :connection_opts ({}) Hash of connection options to pass to initialize Faraday with
          } }

        @consumer = ::OAuth2::Client.new(opts[:key], opts[:secret], opts[:extra])
      end

      def authorize_url
        scopes = Settings.oauth.contacts.google.scopes

        extra_params = { scope: scopes.join(' '),
          redirect_uri: callback_url,
          response_type: 'code',
          access_type: 'offline',
          approval_prompt: 'force',
          state: 'google' }

        consumer.auth_code.authorize_url( extra_params )
      end

      # http://code.google.com/intl/fr-FR/apis/contacts/docs/3.0/developers_guide.html
      def contacts
        token!

        request = "https://www.google.com/m8/feeds/contacts/default/full?alt=json"
        @contacts = normalize(access_token.get(request, :parse => :json).parsed)
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

        contacts['feed']['entry'].each do |contact|
          emails, nickname = [], nil
          nickname = contact['title']['$t']

          contact['gd$email'].each do |email|
            emails << email['address']
          end
          _contacts['contacts'] << { :email => emails.first, :emails => emails, :name => nickname }
        end
        _contacts
      end

    end
  end
end