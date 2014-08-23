require 'spec_helper.rb'

module Larrow::Qingcloud
  describe 'simple story' do
    it 'use_instance_by_password' do
      # create instance and eip
      image_id      = 'trustysrvx64a'
      instance_type = 'small_a'

      instance = Instance.create(
        image_id, instance_type, keypair_id: nil
      ).first
      eip = Eip.create.first

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
  end
end
