$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'larrow/qingcloud'
require 'pry'
require 'pry-nav'
require 'simplecov'
require 'yaml'
SimpleCov.start

module Helpers
  extend self
  include Larrow

  def load_by_default
    args = read_content_as_hash
    [args['qy_access_key_id'],
     args['qy_secret_access_key'], 
     args['zone_id']]
  end

  def read_content_as_hash
    file = "#{ENV['HOME']}/.larrow"
    fail "cannot find keyfile: #{file}" unless File.exist?(file)
    YAML.load(File.read file)['qingcloud']
  end
  
  def establish_connection
    access, secret, zone_id = load_by_default
    Qingcloud.establish_connection access, secret, zone_id
  end
end

Helpers.establish_connection
