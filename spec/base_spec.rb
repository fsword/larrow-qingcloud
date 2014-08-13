require 'spec_helper.rb'
require 'pry'

module Larrow
  module Qingcloud
    describe Base do
      it 'param_by' do
        expect(Base.param_by %w(a b c), 
               key: 'somevalue'
              ).to eq(:'bases.1' => 'a',
                      :'bases.2' => 'b',
                      :'bases.3' => 'c',
                      :key       => 'somevalue'
                     )
      end
    end
  end
end
