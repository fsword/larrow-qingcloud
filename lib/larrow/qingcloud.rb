require 'promising'

module Larrow
  # Qingcloud ruby sdk
  module Qingcloud
    def self.establish_connection(access_key, secret_key, zone_id)
      @connection ||= Connection.new access_key, secret_key, zone_id
    end

    def self.remove_connection
      @connection = nil
    end

    class << self
      attr_reader :connection
    end
    autoload :Instance, 'larrow/qingcloud/instance'
    autoload :Eip,      'larrow/qingcloud/eip'
    autoload :Image,    'larrow/qingcloud/image'
    autoload :Snapshot, 'larrow/qingcloud/snapshot'
    autoload :KeyPair, 'larrow/qingcloud/key_pair'
  end
end

require 'larrow/qingcloud/version'
require 'larrow/qingcloud/logger'
require 'larrow/qingcloud/errors'
require 'larrow/qingcloud/connection'
require 'larrow/qingcloud/base'
