require 'spec_helper.rb'
require 'pry'

module Larrow
  describe Qingcloud do
    before do
      access, secret = load_by_default
      Qingcloud.establish_connection access,secret
    end

    it 'use images' do
      # list images
      images = Qingcloud::Image.list
      images.size.should > 0
    end

    it 'use_instance_by_keypair' do
      # create instance and eip
      image_id      = 'trustysrvx64a'
      instance_type = 'small_a'

      instance = Qingcloud::Instance.create(
        image_id, instance_type
      ).first
      eip = Qingcloud::Eip.create.first

      instance.vxnet_id.should_not be_nil
      instance.keypair_id.should_not be_nil
      instance.wait_for :running
      instance.status.should == 'running'

      eip.wait_for :available

      # bind eip to instance
      instance.associate eip
      instance.dissociate eip

      # destroy instance and eip
      instance.destroy['ret_code'].should == 0
      eip.destroy
    end

    def load_by_default
      args = read_content_as_hash
      [args['qy_access_key_id'], args['qy_secret_access_key']]
    end
    
    def read_content_as_hash
      file = 'access_key.csv'
      raise "cannot find keyfile: #{file}" unless File.exist?(file)
      Hash[*File.read(file).gsub(/[ ']/,'').split(/[\n:]/)]
    end
  end
end
