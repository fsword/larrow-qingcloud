module Larrow
  module Qingcloud
    class Instance < Base
      attr_accessor :vxnet_id, :keypair_id

      destroy_action 'TerminateInstances'

      def self.create(image_id, instance_type, 
                      count:1, 
                      login_mode: 'passwd',
                      passwd:'1qaz@WSX', 
                      keypair_id:'kp-t82jrcvw', 
                      vxnet_id:'vxnet-0')
        err 'The default password is weak, you should change it'
        result = conn.service 'get', 'RunInstances',
                              :image_id         => image_id,
                              :instance_type    => instance_type,
                              :count            => count,
                              :login_mode       => login_mode,
                              :login_passwd     => passwd,
                              :'login_keypair'  => keypair_id,
                              :'vxnets.n'       => vxnet_id

        info "instance added: #{result['instances']}"
        result['instances'].map do |id|
          new(id).tap do |i|
            i.keypair_id = keypair_id
            i.vxnet_id   = vxnet_id
          end
        end
      end

      def attach_keypair(keypair_id = 'kp-t82jrcvw')
        return if self.keypair_id
        conn.service 'get', 'AttachKeyPairs',
                     :'instances.1' => id,
                     :'keypairs.1'  => keypair_id

        Thread.new do
          sleep 10
          4.times do
            if show(verbose: 1)['keypair_ids'].count > 0
              self.keypair_id = keypair_id
              info "instance attach keypair: #{id}"
              break
            end
            sleep 2
          end
        end
      end

      def join_vxnet(vxnet_id = 'vxnet-0')
        return if self.vxnet_id
        params = param_by [id], vxnet: vxnet_id
        conn.service 'get', 'JoinVxnet', params
        Thread.new do
          # wait for vxnet assgined
          sleep 14 # join net is too slow to wait a long time
          4.times do
            if show['vxnets'].size > 0
              self.vxnet_id = vxnet_id
              info "instance joined vxnet: #{id}"
              break
            end
            sleep 2
          end
        end
      end

      def associate(eip)
        conn.service 'get', 'AssociateEip',
                     instance: id,
                     eip: eip.id

        eip.wait_for :associated
      end

      # cannot support batch dissociating
      def dissociate(eip)
        conn.service 'get', 'DissociateEips',
                     :instance => id,
                     :'eips.1'  => eip.id

        eip.wait_for :available
      end
    end
  end
end
