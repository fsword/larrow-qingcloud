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
        result['eips'].map{ |id| new(id).wait_for :available }
      end

      def wait_for(status)
        super do |data|
          self.address = data['eip_addr']
        end
      end

      def associate(instance)
        conn.service 'get', 'AssociateEip',
                     instance: instance.id,
                     eip: id

        wait_for(:associated).force
      end

      # cannot support batch dissociating
      def dissociate(instance)
        conn.service 'get', 'DissociateEips',
                     :instance => instance.id,
                     :'eips.1'  => id

        wait_for(:available).force
      end

    end
  end
end
