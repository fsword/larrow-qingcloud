require_relative 'spec_helper'

module Larrow::Qingcloud
  describe Image do
    it 'list not empty' do
      expect(Image.list).not_to be_empty
    end

    it 'capture instance' do
      image = Image.list.select{|i| i.status == :available}.first

      instance = Instance.
        create(image.id).
        first.
        stop
      new_image = Image.create instance.id
      expect(new_image.status).to eq :available
      
      expect(instance.destroy['ret_code']).to be_zero
      expect(new_image.destroy['ret_code']).to be_zero
    end

    it 'create from snapshot' do
      image = Image.list.select{|i| i.status == :available}.first

      instance = Instance.
        create(image.id).
        first
      snapshot = Snapshot.create(instance.id).first
      new_image = Image.create_from_snapshot snapshot.id

      expect(instance.destroy['ret_code']).to be_zero
      expect(snapshot.destroy['ret_code']).to be_zero
      expect(new_image.destroy['ret_code']).to be_zero
    end
  end
end
