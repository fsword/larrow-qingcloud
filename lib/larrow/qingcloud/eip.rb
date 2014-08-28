module Larrow
  module Qingcloud
    # External address
    class Eip < Base
      attr_accessor :address
      destroy_action 'ReleaseEips'

      def self.create(bandwidth:1, count:1)
        result = conn.service 'get', 'AllocateEips',
                              bandwidth: bandwidth,
                              count: count

        info "EIP added: #{result['eips']}"
        result['eips'].map do |id| 
          promise(timeout:60){ new(id).wait_for :available }
        end
      end

      def wait_for(status)
        super do |data|
          self.address = data['eip_addr']
        end
      end

      def associate(instance_id)
        conn.service 'get', 'AssociateEip',
                     instance: instance_id,
                     eip: id
        promise(timeout:60){ wait_for :associated }
      end

      # cannot support batch dissociating
      def dissociate(instance_id)
        conn.service 'get', 'DissociateEips',
                     :instance => instance_id,
                     :'eips.1'  => id
        promise(timeout:60){ wait_for :available }
      end
    end
  end
end
