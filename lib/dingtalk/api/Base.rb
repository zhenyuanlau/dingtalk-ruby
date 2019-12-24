require 'openssl'
require "base64"
require "faraday"
require "active_support/all"

module Dingtalk
  module Api
    class Base
      attr_accessor :__port, :__domain, :__path

      def initialize(url = nil)
        raise RequestException, "domain must not be empty." if url.nil?

        @__port = 80
        pathUrl = if url.start_with?('http://')
                    url.gsub('http://', '')
                  elsif url.start_with?('https://')
                    url.gsub('https://', '')
                  else
                    raise RequestException, "http protocol is not validate."
        end

        index = pathUrl.index('/').to_i

        if index.positive?
          @__domain = pathUrl[0...index]
          @__path = pathUrl[index..-1]
        else
          @__domain = pathUrl
          @__path = ''
        end

        # puts "domain:#{@__domain}, path: #{@__path}, port: #{@__port}"
      end

      def getRequestHeader
        {
          'Content-type' => 'application/json;charset=UTF-8',
          "Cache-Control" => "no-cache",
          "Connection" => "Keep-Alive"
        }
      end

      def getHttpMethod
        "GET"
      end

      def getapiname
        ""
      end

      def getApiPath
        ""
      end

      def getMultipartParas
        []
      end

      def getCanonicalStringForIsv(timestamp, suiteTicket)
        if suiteTicket.present?
          "#{timestamp}\n#{suiteTicket}"
        else
          timestamp
        end
      end

      def getResponse(authrize: '', accessKey: '', accessSecret: '', suiteTicket: '', corpId: '', timeout: 30)
        sys_parameters = {
          :P_PARTNER_ID => SYSTEM_GENERATE_VERSION
        }
        sys_parameters[P_ACCESS_TOKEN] = authrize if authrize.present?
        application_parameter = getApplicationParameters

        # apiname_split = self.getapiname().split(".")

        sign_parameter = sys_parameters.dup

        sign_parameter.merge!(application_parameter)

        # header = getRequestHeader

        body = application_parameter

        if accessKey.present?
          timestamp = DateTime.now.strftime('%Q')
          puts "timestamp:", timestamp
          canonicalString = getCanonicalStringForIsv(timestamp, suiteTicket)
          puts("canonicalString:" + canonicalString)
          puts("accessSecret:" + accessSecret)
          signature = computeSignature(accessSecret, canonicalString)
          puts("signature:" + signature)
          ps = {}
          ps["accessKey"] = accessKey
          ps["signature"] = signature
          ps["timestamp"] = timestamp
          ps["suiteTicket"] = suiteTicket if suiteTicket.present?
          ps["corpId"] = corpId if corpId != ''
          queryStr = ps.to_query
          fullPath = @__path.include?("?") ? "#{@__path}&#{queryStr}" : "#{@__path}?#{queryStr}"
        else
          fullPath = @__path.include?("?") ? (authrize.present? ? "#{@__path}&access_token=#{authrize}" : @__path) : (authrize.present? ? "#{@__path}?access_token=#{authrize}" : @__path)
        end

        response = if getHttpMethod == "GET"
                     fullPath = fullPath.include?("?") ? "#{fullPath}&#{body.to_query}" : "#{fullPath}?#{body.to_query}"
                     Faraday.get("https://#{@__domain}#{fullPath}") do |req|
                       req.headers['Content-Type'] = 'application/json'
                       req.headers['Accept'] = 'application/json'
                     end
                   else
                     body = if getMultipartParas.present?
                              body
                            else
                              application_parameter.to_json
                            end
                     Faraday.post("https://#{@__domain}#{fullPath}", body, "Content-Type" => "application/json")
                   end
        unless response.success?
          raise RequestException, "invalid http status #{response.status} ,detail body: #{response.body}"
        end

        result = response.body
        # puts "result:", result
        jsonobj = JSON.parse(result)
        if jsonobj.key?(P_CODE) && (jsonobj[P_CODE] != 0)
          # error = TopException.new
          # error.errcode = jsonobj[P_CODE]
          # error.errmsg = jsonobj[P_MSG]
          # error.application_host = response.headers.fetch("Application-Host", "")
          # error.service_host = response.headers.fetch("Location-Host", "")
          raise Error, "TopException"
        end

        jsonobj
      end

      def computeSignature(secret, canonicalString)
        digest = OpenSSL::HMAC.digest('sha256', secret, canonicalString)
        signature = Base64.strict_encode64(digest)
        URI.encode_www_form_component(signature)
        signature
      end

      def getApplicationParameters
        application_parameter = {}
        translate_parameter = getTranslateParas
        instance_variable_names.each do |name|
          next if name.start_with?('@__')

          application_parameter[name[1..-1]] = instance_variable_get(name)
        end
        # application_parameter.each_key do |key|
        #   application_parameter[translate_parameter[key]] = application_parameter[key]
        #   application_parameter.delete(key)
        # end
        application_parameter
      end

      def getTranslateParas
        {}
      end
    end
  end
end
