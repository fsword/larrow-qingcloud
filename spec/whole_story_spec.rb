require 'spec_helper.rb'

module Larrow
  describe Qingcloud do
    it 'use images' do
      # list images
      images = Qingcloud::Image.list
      expect(images.size).to be > 0
    end

    it 'use_instance_by_keypair' do
      # create instance and eip
      image_id      = 'trustysrvx64a'
      instance_type = 'small_a'

      instance = Qingcloud::Instance.create(
        image_id, instance_type
      ).first
      eip = Qingcloud::Eip.create.first

      expect(instance.vxnet_id).not_to be nil
      expect(instance.keypair_id).not_to be nil
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
