module Larrow
  module Qingcloud
    class Instance < Base
      attr_accessor :vxnet_id, :keypair_id

      destroy_action 'TerminateInstances'

      # return an array(running instance)
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
          instance = new id,keypair_id: keypair_id,vxnet_id:vxnet_id
          promise(timeout:90){ instance.wait_for :running }
        end
      end

      def attach_keypair(keypair_id)
        return self if self.keypair_id
        conn.service 'get', 'AttachKeyPairs',
                     :'instances.1' => id,
                     :'keypairs.1'  => keypair_id
        loop do
          if show(verbose: 1)['keypair_ids'].count > 0
            self.keypair_id = keypair_id
            info "instance attach keypair: #{id}"
            break self
          end
          sleep 2
        end
      end

      def join_vxnet(vxnet_id = 'vxnet-0')
        return self if self.vxnet_id
        params = param_by [id], vxnet: vxnet_id
        conn.service 'get', 'JoinVxnet', params
        loop do
          if show['vxnets'].size > 0
            self.vxnet_id = vxnet_id
            info "instance joined vxnet: #{id}"
            break self
          end
          sleep 2
        end
      end

      # return a delayed instance object
      def stop
        conn.get 'StopInstances', :'instances.1' => id
        promise(timeout:60){ wait_for :stopped }
      end
    end
  end
end
