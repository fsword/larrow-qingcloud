module Larrow
  module Qingcloud
    class Image < Base
      def self.list(provider: 'system')
        params = { provider: provider }
        conn.service 'get', 'DescribeImages', params
      end
    end
  end
end
