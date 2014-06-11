require 'logger'
module Larrow
  module Qingcloud
    module Logger
      def self.included base
        base.extend ClassMethods
      end

      module ClassMethods
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

      def info msg; self.class.info msg end
      def err msg;  self.class.err msg  end

    end
  end
end
