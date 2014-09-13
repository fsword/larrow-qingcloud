require_relative 'spec_helper'

module Larrow::Qingcloud
  describe Image do

    let(:base_image) do
      Image.list.select do |i| 
        i.status == :available and i.platform == 'linux'
      end.first
    end

    it 'list not empty' do
      expect(Image.list).not_to be_empty
    end

    it 'capture instance' do
      instance = Instance.
        create(image_id: base_image.id).
        first.
        stop(true)
      new_image = Image.create instance.id
      expect(new_image.status).to eq :available
      
      expect(instance.destroy).to be true
      expect(new_image.destroy).to be true
    end

    it 'create from snapshot' do
      instance = Instance.
        create(image_id: base_image.id).
        first
      snapshot = Snapshot.create(instance.id).first
      new_image = Image.create_from_snapshot snapshot.id

      expect(instance.destroy).to be true
      expect(snapshot.destroy).to be true
      expect(new_image.destroy).to be true
    end
  end
end
