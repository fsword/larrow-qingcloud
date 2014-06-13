require 'active_support/deprecation'
require 'active_support/core_ext/string'

module Larrow
  module Qingcloud
    def self.establish_connection access_key, secret_key
      @connection ||= Connection.new access_key, secret_key
    end
    def self.connection
      @connection
    end
    autoload :Instance, 'larrow/qingcloud/instance'
    autoload :Image,    'larrow/qingcloud/image'
    autoload :Eip,      'larrow/qingcloud/eip'
  end
end

require "larrow/qingcloud/version"
require 'larrow/qingcloud/logger'
require 'larrow/qingcloud/errors'
require 'larrow/qingcloud/connection'
require 'larrow/qingcloud/base'

