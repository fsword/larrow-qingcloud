module Larrow
  module Qingcloud
    class Image < Base
      def self.list(zone_id:'pek1', provider: 'system')
        params = { zone: zone_id, provider: provider }
        conn.service 'get', 'DescribeImages', params
      end
    end
  end
end
