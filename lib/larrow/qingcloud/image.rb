module Larrow
  module Qingcloud
    class Image < Base
      attr_accessor :platform, :provider
      destroy_action 'DeleteImages'

      def self.list(provider=:system)
        describe([],{:provider => provider}) do |hash|
          new hash['image_id'],
            hash.slice('status','platform','provider')
        end
      end

      def self.create instance_id
        result = conn.get 'CaptureInstance', instance: instance_id
        info "image added: #{result}"
        image = new result['image_id']
        promise(timeout:90){ image.wait_for :available }
      end

      def wait_for status
        super do |data|
          self.status = status
          self.platform = data['platform']
          self.provider = data['provider']
        end
      end

    end
  end
end
