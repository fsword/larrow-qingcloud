require 'faraday'
require 'cgi'
require 'openssl'
require 'base64'
require 'json'

module Larrow
  module Qingcloud
    # Connection delegator for Qingcloud
    class Connection
      include Logger
      URL_TEMPLATE = 'https://api.qingcloud.com/iaas/?%s&signature=%s'
      attr_accessor :access_key, :secret_key, :zone_id

      def initialize(access_key, secret_key, zone_id:'pek1')
        self.access_key = access_key
        self.secret_key = secret_key
        self.zone_id    = zone_id
      end

      def service(method, action, params = {})
        # Time.new.iso8601 cannot be recognized
        time_stamp = Time.new.utc.strftime '%Y-%m-%dT%TZ'
        params.update(
          zone: zone_id,
          action: action,
          time_stamp: time_stamp,
          access_key_id: access_key,
          version: 1,
          signature_method: 'HmacSHA256',
          signature_version: 1
        )

        request_str = params.keys.sort.map do |k|
          "#{CGI.escape k.to_s}=#{CGI.escape params[k].to_s}"
        end.join('&')

        signed_text = format "%s\n/iaas/\n%s", method.upcase, request_str

        signature = Base64.encode64(OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha256'), secret_key, signed_text
        )).strip

        url = format URL_TEMPLATE, request_str, CGI.escape(signature)
        resp = Faraday.send(method.to_sym, url)
        debug "API #{action} #{request_str}"

        JSON.parse(resp.body).tap do |obj|
          if obj['ret_code'] != 0
            debug "Service Error(#{obj['ret_code']}): #{obj['message']}"
            fail ServiceError, obj['message']
          end
        end
      end
    end
  end
end
