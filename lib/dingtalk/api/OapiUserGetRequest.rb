# frozen_string_literal: true

module Dingtalk
  module Api
    # get token
    class OapiUserGetRequest < Base
      attr_accessor :userid

      def getHttpMethod
        'GET'
      end

      def getapiname
        'dingtalk.oapi.user.get'
      end
    end
  end
end
