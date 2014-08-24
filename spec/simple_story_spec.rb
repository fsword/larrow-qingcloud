require 'spec_helper.rb'

module Larrow::Qingcloud
  describe 'simple story' do
    it 'use_instance_by_password' do
      # create instance and eip
      image_id      = 'trustysrvx64a'

      instance = Instance.create(image_id).first
      eip = Eip.create.first

      # bind eip to instance
      eip.associate instance
      eip.dissociate instance

      # destroy instance and eip
      expect(instance.destroy['ret_code']).to be_zero
      eip.destroy.force
    end
  end
end
