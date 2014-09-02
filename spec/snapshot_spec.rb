require_relative 'spec_helper'

module Larrow::Qingcloud
  describe Snapshot do
    let(:base_image) do
      Image.list.select do |i| 
        i.status == :available and i.platform == 'linux'
      end.first
    end

    it 'list not fail' do
      expect{Snapshot.list}.not_to raise_error
    end

    it 'create snapshot' do
      instance = Instance.
        create(image_id: base_image.id).
        first
      snapshot = Snapshot.create(instance.id).first
      expect(snapshot.status).to eq :available
      
      expect(instance.destroy['ret_code']).to be_zero
      expect(snapshot.destroy['ret_code']).to be_zero
    end
  end
end
