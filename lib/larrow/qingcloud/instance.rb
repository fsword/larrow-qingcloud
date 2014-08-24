module Larrow
  module Qingcloud
    class Instance < Base
      attr_accessor :vxnet_id, :keypair_id

      destroy_action 'TerminateInstances'

      def self.create(image_id,
                      cpu:1,
                      memory:1024,
                      count:1, 
                      login_mode: 'passwd',
                      passwd:'1qaz@WSX', 
                      keypair_id:nil, 
                      vxnet_id:'vxnet-0')
        err 'The default password is weak, you should change it'
        result = conn.service 'get', 'RunInstances',
                              :image_id         => image_id,
                              :cpu              => cpu,
                              :memory           => memory,
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
          end.wait_for :running
        end
      end

      def attach_keypair(keypair_id = 'kp-t82jrcvw')
        return if self.keypair_id
        conn.service 'get', 'AttachKeyPairs',
                     :'instances.1' => id,
                     :'keypairs.1'  => keypair_id

        Thread.new do
          sleep 2
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
          sleep 2 # join net is too slow to wait a long time
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

      def stop sync=false
        conn.get 'StopInstances', :'instances.1' => id
        if sync
          wait_for(:stopped).force
        end
      end
    end
  end
end
