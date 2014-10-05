require_relative 'spec_helper'

module Larrow::Qingcloud
  describe KeyPair do

    it 'list not empty' do
      expect(KeyPair.list).not_to be_empty
    end

  end
end
