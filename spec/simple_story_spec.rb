require 'spec_helper.rb'
require 'pry'

module Larrow
  describe Qingcloud do
    before do
      access, secret = load_by_default
      Qingcloud.establish_connection access, secret
    end

    it 'use_instance_by_password' do
      # create instance and eip
      image_id      = 'trustysrvx64a'
      instance_type = 'small_a'

      instance = Qingcloud::Instance.create(
        image_id, instance_type, keypair_id: nil
      ).first
      eip = Qingcloud::Eip.create.first

      expect(instance.keypair_id).to be_nil
      expect(instance.vxnet_id).not_to be_nil
      instance.wait_for :running
      expect(instance.running?).to be true

      eip.wait_for :available

      # bind eip to instance
      instance.associate eip

      instance.dissociate eip

      # destroy instance and eip
      expect(instance.destroy['ret_code']).to be_zero
      eip.destroy
    end

    def load_by_default
      args = read_content_as_hash
      [args['qy_access_key_id'], args['qy_secret_access_key']]
    end

    def read_content_as_hash
      file = 'access_key.csv'
      fail "cannot find keyfile: #{file}" unless File.exist?(file)
      Hash[*File.read(file).gsub(/[ ']/, '').split(/[\n:]/)]
    end
  end
end
