# frozen_string_literal: true

module Dingtalk
  module Api
    # get token
    class OapiSnsGetuserinfoBycodeRequest < Base
      attr_accessor :tmp_auth_code

      def getHttpMethod
        'POST'
      end

      def getapiname
        'dingtalk.oapi.sns.getuserinfo_bycode'
      end
    end
  end
end
