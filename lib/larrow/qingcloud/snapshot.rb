module Larrow
  module Qingcloud
    class Snapshot < Base
      attr_accessor :resource

      destroy_action 'DeleteSnapshots'

      def self.list()
        describe([],{:'status.1' => :available}) do |hash|
          new hash['snapshot_id'], hash.slice('status','resource')
        end
      end

      def self.create resource_id
        result = conn.get 'CreateSnapshots', :'resources.1' => resource_id
        info "snapshot added: #{result}"
        result['snapshots'].map do |id|
          promise(timeout:90){ new(id).wait_for :available }
        end
      end
    end
  end
end
