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
        result['eips'].map { |id| new id }
      end

      def wait_for(status)
        super do |data|
          self.address = data['eip_addr']
        end
      end
    end
  end
end
