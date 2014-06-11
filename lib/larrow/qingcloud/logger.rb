require 'logger'
module Larrow
  module Qingcloud
    module Logger
      def logger
        @logger ||= ::Logger.new "#{$LOG_FOLDER}qingcloud.log"
      end

      def info msg
        logger.info msg
      end
      def err msg
        logger.error msg
      end
    end
  end
end
