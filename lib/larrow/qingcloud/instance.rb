module Larrow
  module Qingcloud
    class Instance < Base
      attr_accessor :zone_id, :id, :status
      destroy_action 'TerminateInstances'

      def self.create image_id,instance_type,zone_id,count:1,passwd:'1qaz@WSX'
        image_id ||= 'trustysrvx64'
        instance_type ||= 'small_a'
        zone_id ||= 'pek1'
        $stderr.puts "The default password is weak, you should change it"
        result = conn.service 'get','RunInstances',{
          image_id: image_id, 
          instance_type: instance_type,
          zone:zone_id, 
          count: count,
          login_mode: 'passwd',
          login_passwd: passwd
        }
        wait_for_running zone_id, result['instances']
      end

      def attach_keypair keypair_id='kp-t82jrcvw'
        conn.service 'get','AttachKeyPairs',{
          :zone     => zone_id,
          :'instances.1' => id,
          :'keypairs.1'  => keypair_id
        }
        3.times do
          sleep 2
          return if show(verbose:1)['keypair_ids'].count>0
        end
      end

      def join_vxnet vxnet_id='vxnet-0'
        params = param_by [id], {zone: zone_id,vxnet:vxnet_id}
        conn.service 'get','JoinVxnet',params
        # wait for vxnet assgined
        3.times do
          sleep 5
          return if show['vxnets'].size > 0
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

      def self.wait_for_running zone_id, instance_ids
        3.times do
          sleep 5
          instances = describe instance_ids, {zone:zone_id} do |obj,data|
            obj.id      = data['instance_id']
            obj.status  = data['status']
            obj.zone_id = zone_id
          end
          if instances.map(&:status).uniq == [ 'running' ]
            instances.map(&:join_vxnet)
            instances.map(&:attach_keypair)
            return instances
          end
        end
        []
      end
    end
  end
end
