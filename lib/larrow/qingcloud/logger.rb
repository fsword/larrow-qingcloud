require 'logger'
module Larrow
  module Qingcloud
    def self.logger= logger
      @@logger = logger
    end
    # Qingcloud logger
    # default log file: $current_dir/qingcloud.log
    module Logger
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def logger
          @logger ||= begin
                        if Qingcloud.class_variable_defined? '@@logger'
                          Qingcloud.class_variable_get '@@logger'
                        else
                          ::Logger.new('qingcloud.log')
                        end
                      end
        end

        def debug(msg)
          logger.debug msg
        end

        def info(msg)
          logger.info msg
        end

        def err(msg)
          logger.error msg
        end
      end

      def debug(msg)
        self.class.debug msg
      end

      def info(msg)
        self.class.info msg
      end

      def err(msg)
        self.class.err msg
      end
    end
  end
end
