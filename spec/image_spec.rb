require_relative 'spec_helper'

module Larrow::Qingcloud
  describe Image do
    it 'list not empty' do
      expect(Image.list).not_to be_empty
    end

    it 'capture instance' do
      image = Image.list.select{|i| i.status == :available}.first

      instance = Instance.create(image.id).first
      instance.stop(true).force
      new_image = Image.create instance.id
      expect(new_image).not_to be_nil
      instance.destroy
      new_image.destroy
    end
  end
end
