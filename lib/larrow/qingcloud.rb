require 'active_support/deprecation'
require 'active_support/core_ext/string'

module Larrow
  # Qingcloud ruby sdk
  module Qingcloud
    def self.establish_connection(access_key, secret_key, zone_id)
      @connection ||= Connection.new access_key, secret_key, zone_id
    end
    class << self
      attr_reader :connection
    end
    autoload :Instance, 'larrow/qingcloud/instance'
    autoload :Eip,      'larrow/qingcloud/eip'
    autoload :Image,    'larrow/qingcloud/image'
  end
end

require 'larrow/qingcloud/version'
require 'larrow/qingcloud/logger'
require 'larrow/qingcloud/errors'
require 'larrow/qingcloud/connection'
require 'larrow/qingcloud/base'
