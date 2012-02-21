require "oauth/contacts/version"
require 'oauth/contacts/base'
require 'oauth/contacts/oauth2'
require 'oauth/contacts/google'
require 'oauth/contacts/live'

module Oauth
  module Contacts
    class APIAuthenticationError < StandardError; end
    class TypeNotFound < StandardError; end

    SUPPORTED_PROVIDERS = ['google', 'live']

    class << self

      def supported_providers
        @providers ||= SUPPORTED_PROVIDERS.map(&:to_s).join(', ')
      end

      def get_provider(provider)
        if !SUPPORTED_PROVIDERS.include?(provider)
          raise Oauth::Contacts::TypeNotFound, "#{provider} is not supported, please use one of the following : #{Oauth::Contacts.supported_providers}"
        end

        return ("Oauth::Contacts::" + provider.capitalize).constantize.new
      end

    end
  end
end