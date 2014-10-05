module Larrow
  module Qingcloud
    class KeyPair < Base
      attr_accessor :id, :name
      def self.list()
        describe([],{}) do |hash|
          new hash['keypair_id'],hash['keypair_name']
        end
      end

      def initialize id,name
        self.id = id
        self.name = name
      end
    end
  end
end
