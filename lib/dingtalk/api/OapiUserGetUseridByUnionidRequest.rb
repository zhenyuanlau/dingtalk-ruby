# frozen_string_literal: true

module Dingtalk
  module Api
    # get token
    class OapiUserGetUseridByUnionidRequest < Base
      attr_accessor :unionid

      def getHttpMethod
        'GET'
      end

      def getapiname
        'dingtalk.oapi.user.getUseridByUnionid'
      end
    end
  end
end
