module Dingtalk
  module Api
    # get token
    class OapiGettokenRequest < Base
      attr_accessor :appkey, :appsecret

      def getHttpMethod
        'GET'
      end
    
      def getapiname
        'dingtalk.oapi.gettoken'
      end

      def getResponse
        super.fetch('access_token', '')
      end
    end
  end
end
