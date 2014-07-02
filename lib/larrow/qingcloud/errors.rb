module Larrow
  module Qingcloud
    # Error with code
    class ServiceError < RuntimeError
      attr_accessor :code
      def initialize(code, message)
        super message
        self.code = code
      end
    end
  end
end
