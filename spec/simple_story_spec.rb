require 'spec_helper.rb'

module Larrow::Qingcloud
  describe 'simple story' do
    it 'use_instance_by_password' do
      # create instance and eip
      instance = Instance.create.first
      eip = Eip.create.first

      # bind eip to instance
      eip = eip.associate instance.id
      eip = eip.dissociate instance.id

      # destroy instance and eip
      expect(instance.destroy['ret_code']).to be_zero
      expect(eip.destroy['ret_code']).to be_zero
    end
  end
end
