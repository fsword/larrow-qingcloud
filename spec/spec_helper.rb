$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'larrow/qingcloud'
require 'pry'
require 'pry-nav'
require 'simplecov'
SimpleCov.start

module Helpers
  extend self
  include Larrow

  def load_by_default
    args = read_content_as_hash
    [args['qy_access_key_id'], args['qy_secret_access_key']]
  end

  def read_content_as_hash
    file = 'access_key.csv'
    fail "cannot find keyfile: #{file}" unless File.exist?(file)
    Hash[*File.read(file).gsub(/[ ']/, '').split(/[\n:]/)]
  end
  
  def establish_connection
    access, secret = load_by_default
    Qingcloud.establish_connection access, secret, 'pek2'
  end
end

Helpers.establish_connection
