$:.unshift(File.dirname(__FILE__))
require "dotenv"
require "shopify_api"
require "marketman-sync/version"
require "marketman-sync/connection"
require "marketman-sync/resources"

Dotenv.load(
  File.expand_path("../../../.env", __FILE__),
  File.expand_path("../.env",  __FILE__))

module MarketmanSync
  class Error < StandardError; end
  # Your code goes here...
end
