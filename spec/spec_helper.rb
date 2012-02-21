$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'oauth2'
require "rails_config"
require 'multi_json'
require 'oauth-contacts'