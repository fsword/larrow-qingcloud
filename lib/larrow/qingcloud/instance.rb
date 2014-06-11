module Larrow
  module Qingcloud
    class Instance < Base
      destroy_action 'TerminateInstances'

      def self.create image_id,instance_type,zone_id:'pek1',count:1,passwd:'1qaz@WSX'
        err "The default password is weak, you should change it"
        result = conn.service 'get','RunInstances',{
          image_id: image_id, 
          instance_type: instance_type,
          zone:zone_id, 
          count: count,
          login_mode: 'passwd',
          login_passwd: passwd
        }
        info "instance added: #{zone_id} #{result['instances']}"
        result['instances'].map{|id| new id, zone_id}
      end

      def attach_keypair keypair_id='kp-t82jrcvw'
        conn.service 'get','AttachKeyPairs',{
          :zone     => zone_id,
          :'instances.1' => id,
          :'keypairs.1'  => keypair_id
        }
        lambda do
          3.times do
            sleep 5
            if show(verbose:1)['keypair_ids'].count>0
              info "instance attach keypair: #{id}"
              return
            end
          end
        end
      end

      def join_vxnet vxnet_id='vxnet-0'
        params = param_by [id], {zone: zone_id,vxnet:vxnet_id}
        conn.service 'get','JoinVxnet',params
        # wait for vxnet assgined
        lambda do
          3.times do
            sleep 8 # join net is too slow to wait a long time
            if show['vxnets'].size > 0
              info "instance joined vxnet: #{id}"
              return
            end
          end
        end
      end

      def associate eip
        conn.service 'get','AssociateEip',{
          zone: zone_id,
          instance: id,
          eip: eip.id
        }
        eip.wait_for :associated
      end

      # cannot support batch dissociating
      def dissociate eip
        conn.service 'get','DissociateEips',{
          :zone     => zone_id,
          :instance => id,
          :'eips.1'  => eip.id
        }
        eip.wait_for :available
      end

      def wait_for status
        super do |data|
          [attach_keypair, join_vxnet].map &:call
        end
      end
    end
  end
end
