module Larrow
  module Qingcloud
    class Base
      include Logger
      attr_accessor :id, :zone_id, :status

      def initialize id, zone_id
        self.id = id
        self.zone_id = zone_id
      end

      def conn
        self.class.conn
      end

      def model_name
        self.class.model_name
      end

      def show params={}
        self.class.describe(
          [self], 
          {zone: zone_id}.merge(params)
        ).first
      end

      def wait_for status
        3.times do
          sleep 4
          data = show
          if data['status'] == status.to_s
            info "#{model_name} status changed: #{id} - #{status}"
            self.status = status.to_s
            yield data if block_given?
            return data
          else
            debug "#{model_name} wait for status: #{id} - #{data['status']}"
          end
        end
        raise "#{model_name} cannot wait for #{status}"
      end

      def self.conn
        @@conn ||= Qingcloud.connection
      end

      # multi names( used as param_name )
      # KeyPair -> keypair -> keypairs
      def self.model_name
        name.split(/::/).last
      end
      def self.singular_name
        name.split(/::/).last.downcase
      end
      def self.plural_name
        name.split(/::/).last.downcase.pluralize
      end

      def param_by *args; self.class.param_by *args end

      def self.param_by ids, init_params
        ids.each_with_index.reduce(init_params) do |result, (id, index)|
          result.update :"#{plural_name}.#{index+1}" => id
        end
      end

      # convert hash data to object when block given
      def self.describe objs, params
        params = param_by(objs.map(&:id), params)
        datas = conn.service(
          'get', "Describe#{model_name}s", params
        )["#{singular_name}_set"]
        if block_given?
          datas.map do |data| 
            new.tap{|obj| yield obj,data}
          end
        else
          datas
        end
      end

      def self.destroy_action action
        define_method :destroy do
          params = self.class.param_by [id], {zone: zone_id}
          3.times do |i|
            begin
              result = conn.service 'get', action, params
              info "destroy #{self.class.name}: #{result}"
              return result
            rescue ServiceError => e
              debug "try to destroy: %s" % [e.message]
              sleep 15
            end
          end
          raise "cannot destroy fail #{self.class}: #{id}"
        end
      end

    end
  end
end
