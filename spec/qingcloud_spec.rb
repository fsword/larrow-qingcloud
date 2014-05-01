require 'spec_helper.rb'
require 'pry'

module Larrow
  describe Qingcloud do
    before do
      Qingcloud.establish_connection nil,nil
    end

    it 'use_eip' do
      objs = Qingcloud::Eip.create count:1
      objs.count.should == 1
      objs.first.destroy['ret_code'].should == 0
    end

    it 'use images' do
      # list images
      images = Qingcloud::Image.list
      images.size.should > 0
    end

    it 'use_instance_with_eip' do
      objs = nil
      # create instance
      objs = Qingcloud::Instance.create nil,nil,nil
      objs.count.should == 1
      instance = objs.first
      instance.status.should == 'running'

      # create eip
      eip = Qingcloud::Eip.create(count:1).first

      # bind eip to instance
      instance.associate eip      
      instance.dissociate eip

      # destroy instance and eip
      objs.first.destroy['ret_code'].should == 0
      eip.destroy
    end

  end
end
