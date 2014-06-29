module Larrow
  module Qingcloud
    class Eip < Base
      attr_accessor :address
      destroy_action 'ReleaseEips'

      def self.create(zone_id:'pek1', bandwidth:1, count:1)
        result = conn.service 'get', 'AllocateEips',
                              zone: zone_id,
                              bandwidth: bandwidth,
                              count: count

        info "EIP added: #{zone_id} #{result['eips']}"
        result['eips'].map { |id| new id, zone_id }
      end

      def wait_for(status)
        super do |data|
          self.address = data['eip_addr']
        end
      end
    end
  end
end
