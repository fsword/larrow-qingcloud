require_relative 'spec_helper'

module Larrow::Qingcloud
  describe Snapshot do
    it 'list not fail' do
      expect{Snapshot.list}.not_to raise_error
    end

    it 'create snapshot' do
      image = Image.list.select{|i| i.status == :available}.first

      instance = Instance.
        create(image.id).
        first
      snapshot = Snapshot.create(instance.id).first
      expect(snapshot.status).to eq :available
      
      expect(instance.destroy['ret_code']).to be_zero
      expect(snapshot.destroy['ret_code']).to be_zero
    end
  end
end
