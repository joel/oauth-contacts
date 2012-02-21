module Oauth
  module Contacts
    class Base
      attr_reader :consumer, :access_token, :callback_url

      def initialize
      end

      def authorize_url
        raise "Not Implemented"
      end

      def contacts
        raise "Not Implemented"
      end
    end
  end
end