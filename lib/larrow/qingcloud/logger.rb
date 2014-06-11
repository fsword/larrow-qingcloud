require 'logger'
module Larrow
  module Qingcloud
    module Logger
      def info msg
        @logger ||= ::Logger.new "#{$LOG_FOLDER}qingcloud.log"
        @logger.info msg
      end
    end
  end
end
