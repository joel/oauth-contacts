module Oauth
  module Contacts
    class OAuth2 < Oauth::Contacts::Base

      VERSION = 2.0

      attr_accessor :code

      def version
        VERSION
      end

      def initialize
        super
      end

    end
  end
end
