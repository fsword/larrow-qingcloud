module Larrow
  module Qingcloud
    class Eip < Base
      attr_accessor :zone_id, :id, :address
      destroy_action 'ReleaseEips'

      def self.create zone_id:'pek1',bandwidth:1,count:1
        result = conn.service 'get','AllocateEips',{
          zone: zone_id,
          bandwidth: bandwidth,
          count: count
        }
        describe(result['eips'],{zone: zone_id}) do |obj, data|
          obj.id      = data['eip_id'  ]
          obj.address = data['eip_addr']
          obj.zone_id = zone_id
          info "EIP created: #{obj.id} - #{obj.address}"
        end
      end

      def wait_for status
        3.times do
          sleep 3
          current_status = show['status']
          if current_status == status.to_s
            info "EIP status changed: #{id} - #{status}"
            return
          else
            debug "EIP wait for status: #{id} - #{current_status}"
          end
        end
      end
    end
  end
end
